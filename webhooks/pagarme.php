<?php

/**
 * Pagar.me V5 webhook.
 *
 * Pagar.me does not currently document a V5 signature scheme for this
 * endpoint. The URL has a high-entropy local secret and every paid event is
 * confirmed by fetching the order through the authenticated API.
 */

define('PAYMENT_WEBHOOK_CONTEXT', true);
require('../bootstrap.php');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  br_payments_json_response(405, ['ok' => false]);
}
if (!$system['pagarme_enabled'] || empty($system['pagarme_secret_key']) || empty($system['pagarme_webhook_secret'])) {
  br_payments_json_response(503, ['ok' => false]);
}
$token = (string) ($_GET['token'] ?? '');
if ($token === '' || !hash_equals($system['pagarme_webhook_secret'], $token)) {
  br_payments_json_response(401, ['ok' => false]);
}
$contentLength = (int) ($_SERVER['CONTENT_LENGTH'] ?? 0);
if ($contentLength > 1048576) {
  br_payments_json_response(413, ['ok' => false]);
}
$raw = file_get_contents('php://input');
$payload = json_decode($raw, true);
if (!is_array($payload) || empty($payload['type']) || empty($payload['data'])) {
  br_payments_json_response(400, ['ok' => false]);
}

try {
  br_payments_ensure_schema();
  $event = (string) $payload['type'];
  if ($event === 'order.paid') {
    $orderId = (string) ($payload['data']['id'] ?? '');
    $order = br_payments_get_pagarme_order($orderId);
    $reference = (string) ($order['code'] ?? '');
    if (!preg_match('/^thx_[a-f0-9]{32}$/', $reference)) {
      br_payments_json_response(200, ['ok' => true, 'ignored' => true]);
    }
    $transaction = br_payments_get_transaction($reference, 'pagarme');
    if (!$transaction) {
      throw new Exception('Unknown payment reference');
    }
    if (($order['status'] ?? '') !== 'paid'
      || (int) ($order['amount'] ?? 0) !== (int) $transaction['amount_cents']
      || strtoupper((string) ($order['currency'] ?? 'BRL')) !== 'BRL') {
      throw new Exception('Pagar.me order verification failed');
    }
    $processed = br_payments_complete_transaction($reference, 'pagarme', $orderId, $event);
    br_payments_json_response(200, ['ok' => true, 'processed' => $processed]);
  }

  $reference = (string) ($payload['data']['code'] ?? $payload['data']['order']['code'] ?? '');
  $orderId = (string) ($payload['data']['order']['id'] ?? $payload['data']['id'] ?? '');
  $statuses = [
    'order.payment_failed' => 'failed',
    'checkout.canceled' => 'canceled',
    'charge.refunded' => 'refunded',
    'chargeback.received' => 'chargeback',
    'charge.chargedback' => 'chargeback',
  ];
  if (isset($statuses[$event]) && !preg_match('/^thx_[a-f0-9]{32}$/', $reference) && preg_match('/^or_[A-Za-z0-9]+$/', $orderId)) {
    $eventOrder = br_payments_get_pagarme_order($orderId);
    $reference = (string) ($eventOrder['code'] ?? '');
  }
  if (preg_match('/^thx_[a-f0-9]{32}$/', $reference) && isset($statuses[$event])) {
    br_payments_mark_status($reference, 'pagarme', $statuses[$event], $event, $orderId ?: null);
  }
  br_payments_json_response(200, ['ok' => true, 'ignored' => true]);
} catch (Throwable $e) {
  error_log('Pagar.me webhook: ' . $e->getMessage());
  br_payments_json_response(503, ['ok' => false]);
}
