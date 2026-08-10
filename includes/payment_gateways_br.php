<?php

/**
 * Brazilian payment gateways (Stone/Pagar.me and Woovi/OpenPix).
 *
 * The gateways only create hosted checkouts. Access is granted exclusively
 * after a server-to-server webhook has been independently verified.
 */

const BR_PAYMENTS_SCHEMA_VERSION = '1';
const WOOVI_WEBHOOK_PUBLIC_KEY_BASE64 = 'LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlHZk1BMEdDU3FHU0liM0RRRUJBUVVBQTRHTkFEQ0JpUUtCZ1FDLytOdElranpldnZxRCtJM01NdjNiTFhEdApwdnhCalk0QnNSclNkY2EzcnRBd01jUllZdnhTbmQ3amFnVkxwY3RNaU94UU84aWVVQ0tMU1dIcHNNQWpPL3paCldNS2Jxb0c4TU5waS91M2ZwNnp6MG1jSENPU3FZc1BVVUcxOWJ1VzhiaXM1WloySVpnQk9iV1NwVHZKMGNuajYKSEtCQUE4MkpsbitsR3dTMU13SURBUUFCCi0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=';


/**
 * Add safe runtime defaults for installations upgraded without reinstalling.
 */
function br_payments_apply_defaults(&$system)
{
  $defaults = [
    'br_payments_schema_version' => '0',
    'pagarme_enabled' => '0',
    'pagarme_mode' => 'sandbox',
    'pagarme_secret_key' => '',
    'pagarme_payment_methods' => 'credit_card,pix',
    'pagarme_webhook_secret' => '',
    'pagarme_link_expiration_minutes' => '60',
    'woovi_enabled' => '0',
    'woovi_mode' => 'sandbox',
    'woovi_app_id' => '',
    'woovi_charge_expiration_seconds' => '3600',
  ];
  foreach ($defaults as $key => $value) {
    if (!isset($system[$key])) {
      $system[$key] = $value;
    }
  }
}


/**
 * Create the local idempotency ledger on demand.
 */
function br_payments_ensure_schema()
{
  global $db, $system;
  $db->query("CREATE TABLE IF NOT EXISTS `br_payment_transactions` (
    `transaction_id` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
    `reference` varchar(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
    `gateway` varchar(16) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
    `external_id` varchar(128) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
    `provider_order_id` varchar(128) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
    `user_id` int UNSIGNED NOT NULL,
    `handle` varchar(32) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL,
    `handle_id` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
    `base_amount_cents` int UNSIGNED NOT NULL,
    `amount_cents` int UNSIGNED NOT NULL,
    `currency` char(3) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT 'BRL',
    `coupon_code` varchar(128) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
    `status` varchar(24) CHARACTER SET ascii COLLATE ascii_general_ci NOT NULL DEFAULT 'pending',
    `checkout_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci,
    `last_event` varchar(64) CHARACTER SET ascii COLLATE ascii_general_ci DEFAULT NULL,
    `processed_at` datetime DEFAULT NULL,
    `created_at` datetime NOT NULL,
    `updated_at` datetime NOT NULL,
    PRIMARY KEY (`transaction_id`),
    UNIQUE KEY `reference` (`reference`),
    KEY `gateway_external` (`gateway`, `external_id`),
    KEY `gateway_order` (`gateway`, `provider_order_id`),
    KEY `user_status` (`user_id`, `status`)
  ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci ROW_FORMAT=DYNAMIC") or throw new Exception('Could not initialize the payment transaction ledger');

  if ($system['br_payments_schema_version'] !== BR_PAYMENTS_SCHEMA_VERSION) {
    update_system_options([
      'br_payments_schema_version' => secure(BR_PAYMENTS_SCHEMA_VERSION),
    ]);
    $system['br_payments_schema_version'] = BR_PAYMENTS_SCHEMA_VERSION;
  }
}


/**
 * Persist gateway settings and create a webhook secret when required.
 */
function br_payments_save_settings($values)
{
  global $system;
  br_payments_ensure_schema();
  if (empty($system['pagarme_webhook_secret'])) {
    $values['pagarme_webhook_secret'] = secure(bin2hex(random_bytes(24)));
  }
  update_system_options($values);
}


/**
 * Convert a decimal monetary value to integer cents.
 */
function br_payments_to_cents($amount)
{
  if (!is_numeric($amount)) {
    throw new Exception(__('Enter valid amount of money'));
  }
  $cents = (int) round(((float) $amount) * 100, 0, PHP_ROUND_HALF_UP);
  if ($cents <= 0 || $cents > 4294967295) {
    throw new Exception(__('Enter valid amount of money'));
  }
  return $cents;
}


/**
 * Build an authoritative purchase snapshot from database data.
 */
function br_payments_prepare_purchase($handle, $input)
{
  global $db, $system, $user;
  if (strtoupper($system['system_currency']) !== 'BRL') {
    throw new Exception(__('Stone/Pagar.me and Woovi require BRL as the site currency'));
  }

  $purchase = [
    'handle' => $handle,
    'handle_id' => null,
    'price' => 0,
    'coupon_code' => null,
    'description' => __('Payment'),
  ];

  switch ($handle) {
    case 'packages':
      $id = $input['package_id'] ?? $input['id'] ?? null;
      if (!is_numeric($id)) {
        _error(400);
      }
      $package = $user->get_package($id);
      if (!$package || (float) $package['price'] <= 0) {
        throw new Exception(__('This package is not available'));
      }
      if ($user->_data['user_subscribed'] && $user->_data['user_package'] == $package['package_id']) {
        throw new Exception(__('You already subscribed to this package, Please select different package'));
      }
      $purchase['handle_id'] = (string) $package['package_id'];
      $purchase['price'] = $package['price'];
      $purchase['description'] = __('Premium plan');
      break;

    case 'wallet':
      $price = $input['price'] ?? null;
      if (!is_numeric($price) || (float) $price <= 0) {
        throw new Exception(__('Enter valid amount of money'));
      }
      $purchase['price'] = $price;
      $purchase['description'] = __('Wallet Credit');
      break;

    case 'donate':
      $id = $input['post_id'] ?? $input['id'] ?? null;
      $price = $input['price'] ?? null;
      if (!is_numeric($id) || !is_numeric($price) || (float) $price <= 0) {
        _error(400);
      }
      $post = $user->get_post($id);
      if (!$post) {
        throw new Exception(__('This post is not available'));
      }
      $funding = $db->query(sprintf("SELECT COUNT(*) AS count FROM posts_funding WHERE post_id = %s", secure($id, 'int')))->fetch_assoc();
      if ((int) $funding['count'] === 0) {
        throw new Exception(__('This post is not available'));
      }
      $purchase['handle_id'] = (string) (int) $id;
      $purchase['price'] = $price;
      $purchase['description'] = __('Creator support');
      break;

    case 'subscribe':
      $id = $input['plan_id'] ?? $input['id'] ?? null;
      if (!is_numeric($id)) {
        _error(400);
      }
      $plan = $user->get_monetization_plan($id, true);
      if (!$plan) {
        throw new Exception(__('This monetization plan is not available'));
      }
      if ($user->is_subscribed($plan['node_id'], $plan['node_type'])) {
        throw new Exception(__('You already subscribed to this') . ' ' . __($plan['node_type']));
      }
      $price = (!empty($plan['discounted_price'])) ? $plan['discounted_price'] : $plan['price'];
      $purchase['handle_id'] = (string) $plan['plan_id'];
      $purchase['description'] = __('Creator subscription');
      $purchase['price'] = br_payments_apply_coupon($price, $input, $purchase);
      break;

    case 'paid_post':
      $id = $input['post_id'] ?? $input['id'] ?? null;
      if (!is_numeric($id)) {
        _error(400);
      }
      $post = $user->get_post($id, false, false, true);
      if (!$post || !$post['needs_payment']) {
        throw new Exception(__("This post doesn't need payment"));
      }
      $price = (!empty($post['post_price_discounted'])) ? $post['post_price_discounted'] : $post['post_price'];
      $purchase['handle_id'] = (string) (int) $id;
      $purchase['description'] = __('Digital content access');
      $purchase['price'] = br_payments_apply_coupon($price, $input, $purchase);
      break;

    case 'movies':
      $id = $input['movie_id'] ?? $input['id'] ?? null;
      if (!is_numeric($id)) {
        _error(400);
      }
      $movie = $user->get_movie($id);
      if (!$movie || (float) $movie['price'] <= 0) {
        throw new Exception(__('This movie is not available'));
      }
      if ($movie['can_watch']) {
        throw new Exception(__('You already paid to this movie'));
      }
      $purchase['handle_id'] = (string) $movie['movie_id'];
      $purchase['price'] = $movie['price'];
      $purchase['description'] = __('Video access');
      break;

    case 'marketplace':
      $id = $input['orders_collection_id'] ?? $input['id'] ?? null;
      if (!$id || strlen((string) $id) > 128) {
        _error(400);
      }
      $ownership = $db->query(sprintf("SELECT COUNT(*) AS count FROM orders WHERE order_collection_id = %s AND buyer_id = %s", secure($id), secure($user->_data['user_id'], 'int')))->fetch_assoc();
      if ((int) $ownership['count'] === 0) {
        throw new Exception(__('This order is not available'));
      }
      $orders = $user->get_orders_collection($id);
      if (!$orders || $orders['paid']) {
        throw new Exception(__('You already paid to this order'));
      }
      $purchase['handle_id'] = (string) $id;
      $purchase['price'] = $orders['total'];
      $purchase['description'] = __('Marketplace order');
      break;

    default:
      _error(400);
  }

  $purchase['base_amount_cents'] = br_payments_to_cents($purchase['price']);
  $purchase['amount_cents'] = br_payments_to_cents(get_payment_total_value($purchase['price']));
  $purchase['description'] = mb_substr(strip_tags($purchase['description']), 0, 64);
  return $purchase;
}


/**
 * Apply a valid monetization coupon without consuming it before payment.
 */
function br_payments_apply_coupon($price, $input, &$purchase)
{
  global $user;
  $code = trim((string) ($input['promo_code'] ?? ''));
  if ($code === '') {
    return $price;
  }
  $coupon = $user->check_monetization_coupon($code, $user->_data['user_id']);
  if (!$coupon) {
    return $price;
  }
  $purchase['coupon_code'] = $code;
  return (float) $price * (1 - ((float) $coupon['discount_percent'] / 100));
}


/**
 * Create the local transaction before talking to a provider.
 */
function br_payments_create_transaction($gateway, $purchase)
{
  global $db, $date, $user;
  br_payments_ensure_schema();
  $reference = 'thx_' . bin2hex(random_bytes(16));
  $db->query(sprintf(
    "INSERT INTO br_payment_transactions (reference, gateway, user_id, handle, handle_id, base_amount_cents, amount_cents, currency, coupon_code, status, created_at, updated_at) VALUES (%s, %s, %s, %s, %s, %s, %s, 'BRL', %s, 'pending', %s, %s)",
    secure($reference),
    secure($gateway),
    secure($user->_data['user_id'], 'int'),
    secure($purchase['handle']),
    ($purchase['handle_id'] === null) ? 'NULL' : secure($purchase['handle_id']),
    secure($purchase['base_amount_cents'], 'int'),
    secure($purchase['amount_cents'], 'int'),
    ($purchase['coupon_code'] === null) ? 'NULL' : secure($purchase['coupon_code']),
    secure($date),
    secure($date)
  )) or throw new Exception(__('Could not start the payment'));
  return $reference;
}


/**
 * Execute a JSON HTTPS API request.
 */
function br_payments_api_request($method, $url, $headers, $body = null)
{
  $ch = curl_init($url);
  $options = [
    CURLOPT_CUSTOMREQUEST => strtoupper($method),
    CURLOPT_HTTPHEADER => array_merge(['Accept: application/json'], $headers),
    CURLOPT_RETURNTRANSFER => true,
    CURLOPT_HEADER => false,
    CURLOPT_CONNECTTIMEOUT => 10,
    CURLOPT_TIMEOUT => 30,
    CURLOPT_SSL_VERIFYPEER => true,
    CURLOPT_SSL_VERIFYHOST => 2,
  ];
  if (defined('CURLOPT_PROTOCOLS') && defined('CURLPROTO_HTTPS')) {
    $options[CURLOPT_PROTOCOLS] = CURLPROTO_HTTPS;
  }
  if ($body !== null) {
    $options[CURLOPT_POSTFIELDS] = json_encode($body, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
  }
  curl_setopt_array($ch, $options);
  $response = curl_exec($ch);
  $error = curl_error($ch);
  $status = (int) curl_getinfo($ch, CURLINFO_HTTP_CODE);
  curl_close($ch);
  if ($response === false || $error) {
    throw new Exception(__('The payment provider could not be reached'));
  }
  $decoded = json_decode($response, true);
  if ($status < 200 || $status >= 300 || !is_array($decoded)) {
    $message = '';
    if (is_array($decoded)) {
      $message = $decoded['message'] ?? $decoded['error'] ?? '';
    }
    throw new Exception(__('The payment provider rejected the request') . (($message && is_string($message)) ? ': ' . mb_substr(strip_tags($message), 0, 180) : ''));
  }
  return $decoded;
}


function br_payments_pagarme_base_url()
{
  global $system;
  return ($system['pagarme_mode'] === 'production') ? 'https://api.pagar.me/core/v5' : 'https://sdx-api.pagar.me/core/v5';
}


function br_payments_woovi_base_url()
{
  global $system;
  return ($system['woovi_mode'] === 'production') ? 'https://api.openpix.com.br' : 'https://api.woovi-sandbox.com';
}


/**
 * Create a Pagar.me V5 hosted checkout.
 */
function br_payments_create_pagarme_checkout($reference, $purchase)
{
  global $system;
  $methods = array_values(array_intersect(array_filter(array_map('trim', explode(',', $system['pagarme_payment_methods']))), ['credit_card', 'pix', 'boleto']));
  if (!$methods) {
    throw new Exception(__('Select at least one Pagar.me payment method'));
  }
  $expiration = max(5, min(10080, (int) $system['pagarme_link_expiration_minutes']));
  $payload = [
    'is_building' => false,
    'name' => mb_substr($purchase['description'] . ' ' . substr($reference, -6), 0, 64),
    'order_code' => $reference,
    'type' => 'order',
    'expires_in' => $expiration,
    'max_sessions' => 1,
    'max_paid_sessions' => 1,
    'payment_settings' => [
      'accepted_payment_methods' => $methods,
    ],
    'cart_settings' => [
      'items' => [[
        'name' => $purchase['description'],
        'description' => $purchase['description'],
        'amount' => $purchase['amount_cents'],
        'default_quantity' => 1,
      ]],
    ],
  ];
  $response = br_payments_api_request(
    'POST',
    br_payments_pagarme_base_url() . '/paymentlinks',
    [
      'Authorization: Basic ' . base64_encode($system['pagarme_secret_key'] . ':'),
      'Content-Type: application/json',
      'User-Agent: pagarme-skill-generated/1.0',
    ],
    $payload
  );
  if (empty($response['id']) || empty($response['url']) || !filter_var($response['url'], FILTER_VALIDATE_URL)) {
    throw new Exception(__('The payment provider returned an invalid checkout'));
  }
  return ['external_id' => $response['id'], 'url' => $response['url']];
}


/**
 * Create a Woovi/OpenPix Pix charge.
 */
function br_payments_create_woovi_charge($reference, $purchase)
{
  global $system, $user;
  $expiration = max(300, min(2592000, (int) $system['woovi_charge_expiration_seconds']));
  $payload = [
    'correlationID' => $reference,
    'value' => $purchase['amount_cents'],
    'comment' => $purchase['description'],
    'expiresIn' => $expiration,
    'additionalInfo' => [
      ['key' => 'Reference', 'value' => $reference],
      ['key' => 'Product', 'value' => $purchase['handle']],
    ],
  ];
  $name = trim($user->_data['user_firstname'] . ' ' . $user->_data['user_lastname']);
  if ($name !== '' && valid_email($user->_data['user_email'])) {
    $payload['customer'] = [
      'name' => mb_substr($name, 0, 120),
      'email' => $user->_data['user_email'],
    ];
  }
  $response = br_payments_api_request(
    'POST',
    br_payments_woovi_base_url() . '/api/v1/charge?return_existing=true',
    [
      'Authorization: ' . $system['woovi_app_id'],
      'Content-Type: application/json',
      'User-Agent: sngine-br-payments/1.0',
    ],
    $payload
  );
  $charge = $response['charge'] ?? [];
  if (empty($charge['correlationID']) || $charge['correlationID'] !== $reference || empty($charge['paymentLinkUrl']) || !filter_var($charge['paymentLinkUrl'], FILTER_VALIDATE_URL)) {
    throw new Exception(__('The payment provider returned an invalid checkout'));
  }
  $externalId = $charge['globalID'] ?? $charge['paymentLinkID'] ?? $reference;
  return ['external_id' => $externalId, 'url' => $charge['paymentLinkUrl']];
}


/**
 * Create a checkout and attach it to the local ledger.
 */
function br_payments_start_checkout($gateway, $purchase)
{
  global $db, $date;
  $reference = br_payments_create_transaction($gateway, $purchase);
  try {
    $checkout = ($gateway === 'pagarme')
      ? br_payments_create_pagarme_checkout($reference, $purchase)
      : br_payments_create_woovi_charge($reference, $purchase);
    $db->query(sprintf(
      "UPDATE br_payment_transactions SET external_id = %s, checkout_url = %s, status = 'checkout_created', updated_at = %s WHERE reference = %s",
      secure($checkout['external_id']), secure($checkout['url']), secure($date), secure($reference)
    )) or throw new Exception(__('Could not save the payment checkout'));
    return $checkout['url'];
  } catch (Throwable $e) {
    $db->query(sprintf("UPDATE br_payment_transactions SET status = 'creation_failed', updated_at = %s WHERE reference = %s", secure($date), secure($reference)));
    throw $e;
  }
}


function br_payments_get_transaction($reference, $gateway, $for_update = false)
{
  global $db;
  $suffix = ($for_update) ? ' FOR UPDATE' : '';
  $query = $db->query(sprintf("SELECT * FROM br_payment_transactions WHERE reference = %s AND gateway = %s LIMIT 1%s", secure($reference), secure($gateway), $suffix));
  return ($query && $query->num_rows) ? $query->fetch_assoc() : false;
}


/**
 * Complete one purchase exactly once.
 */
function br_payments_complete_transaction($reference, $gateway, $provider_order_id = null, $event = null)
{
  global $db, $date, $user;
  br_payments_ensure_schema();
  $db->begin_transaction();
  try {
    $transaction = br_payments_get_transaction($reference, $gateway, true);
    if (!$transaction) {
      throw new Exception('Unknown payment reference');
    }
    /* processed_at is permanent even if status later becomes refunded/chargeback */
    if ($transaction['processed_at'] !== null) {
      $db->commit();
      return false;
    }
    $baseAmount = ((int) $transaction['base_amount_cents']) / 100;
    $handleId = $transaction['handle_id'];
    $userId = (int) $transaction['user_id'];

    switch ($transaction['handle']) {
      case 'packages':
        $package = $user->get_package($handleId);
        if (!$package) throw new Exception('Package is no longer available');
        $user->update_user_package($package, $userId);
        break;

      case 'wallet':
        $user->wallet_update_balance($baseAmount, '+', $userId);
        $user->wallet_set_transaction($userId, 'recharge', 0, $baseAmount, 'in');
        break;

      case 'donate':
        $user->funding_donation($handleId, $baseAmount, $userId);
        break;

      case 'subscribe':
        $user->subscribe($handleId, $userId, false, $baseAmount);
        break;

      case 'paid_post':
        $user->unlock_paid_post($handleId, $userId, $baseAmount);
        break;

      case 'movies':
        $user->movie_payment($handleId, $userId);
        break;

      case 'marketplace':
        $user->mark_orders_collection_as_paid($handleId);
        break;

      default:
        throw new Exception('Unsupported payment handle');
    }

    if (!empty($transaction['coupon_code']) && in_array($transaction['handle'], ['subscribe', 'paid_post'], true)) {
      try {
        $user->update_monetization_coupon($transaction['coupon_code'], $userId);
      } catch (Throwable $e) {
        /* The buyer already paid the quoted amount; coupon races cannot deny access. */
      }
    }
    $user->log_payment($userId, $baseAmount, $gateway, $transaction['handle']);
    $db->query(sprintf(
      "UPDATE br_payment_transactions SET status = 'paid', provider_order_id = %s, last_event = %s, processed_at = %s, updated_at = %s WHERE transaction_id = %s",
      ($provider_order_id === null) ? 'NULL' : secure($provider_order_id),
      ($event === null) ? 'NULL' : secure($event),
      secure($date), secure($date), secure($transaction['transaction_id'], 'int')
    )) or throw new Exception('Could not finalize payment transaction');
    $db->commit();
    return true;
  } catch (Throwable $e) {
    $db->rollback();
    throw $e;
  }
}


function br_payments_mark_status($reference, $gateway, $status, $event = null, $provider_order_id = null)
{
  global $db, $date;
  br_payments_ensure_schema();
  $allowed = ['pending', 'checkout_created', 'failed', 'canceled', 'expired', 'refunded', 'chargeback'];
  if (!in_array($status, $allowed, true)) return;
  $db->query(sprintf(
    "UPDATE br_payment_transactions SET status = IF(status = 'paid' AND %s NOT IN ('refunded','chargeback'), status, %s), last_event = %s, provider_order_id = COALESCE(%s, provider_order_id), updated_at = %s WHERE reference = %s AND gateway = %s",
    secure($status), secure($status), ($event === null) ? 'NULL' : secure($event), ($provider_order_id === null) ? 'NULL' : secure($provider_order_id), secure($date), secure($reference), secure($gateway)
  ));
}


function br_payments_get_pagarme_order($order_id)
{
  global $system;
  if (!preg_match('/^or_[A-Za-z0-9]+$/', (string) $order_id)) {
    throw new Exception('Invalid Pagar.me order ID');
  }
  return br_payments_api_request(
    'GET',
    br_payments_pagarme_base_url() . '/orders/' . rawurlencode($order_id),
    [
      'Authorization: Basic ' . base64_encode($system['pagarme_secret_key'] . ':'),
      'Content-Type: application/json',
      'User-Agent: pagarme-skill-generated/1.0',
    ]
  );
}


function br_payments_get_woovi_charge($reference)
{
  global $system;
  return br_payments_api_request(
    'GET',
    br_payments_woovi_base_url() . '/api/v1/charge/' . rawurlencode($reference),
    [
      'Authorization: ' . $system['woovi_app_id'],
      'Content-Type: application/json',
      'User-Agent: sngine-br-payments/1.0',
    ]
  );
}


/**
 * Verify Woovi's x-webhook-signature over the exact raw request body.
 */
function br_payments_verify_woovi_signature($payload, $signature)
{
  if (!function_exists('openssl_pkey_get_public') || !function_exists('openssl_verify')) return false;
  if (!is_string($signature) || $signature === '') return false;
  $decodedSignature = base64_decode($signature, true);
  $publicPem = base64_decode(WOOVI_WEBHOOK_PUBLIC_KEY_BASE64, true);
  if ($decodedSignature === false || $publicPem === false) return false;
  $publicKey = openssl_pkey_get_public($publicPem);
  if (!$publicKey) return false;
  return openssl_verify($payload, $decodedSignature, $publicKey, OPENSSL_ALGO_SHA256) === 1;
}


function br_payments_json_response($status, $payload)
{
  http_response_code($status);
  header('Content-Type: application/json; charset=utf-8');
  echo json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
  exit;
}
