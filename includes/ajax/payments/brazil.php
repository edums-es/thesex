<?php

/**
 * ajax -> payments -> Stone/Pagar.me and Woovi/OpenPix
 */

require('../../../bootstrap.php');

is_ajax();
user_access(true, true);

try {
  $gateway = $_POST['gateway'] ?? '';
  if (!in_array($gateway, ['pagarme', 'woovi'], true)) {
    _error(400);
  }
  if ($gateway === 'pagarme') {
    if (!$system['pagarme_enabled']) {
      throw new Exception(__('This feature has been disabled by the admin'));
    }
    if (empty($system['pagarme_secret_key']) || empty($system['pagarme_webhook_secret'])) {
      throw new Exception(__('Pagar.me is not fully configured'));
    }
  } else {
    if (!$system['woovi_enabled']) {
      throw new Exception(__('This feature has been disabled by the admin'));
    }
    if (empty($system['woovi_app_id'])) {
      throw new Exception(__('Woovi is not fully configured'));
    }
  }

  $handle = (string) ($_POST['handle'] ?? '');
  $purchase = br_payments_prepare_purchase($handle, $_POST);
  $link = br_payments_start_checkout($gateway, $purchase);

  return_json([
    'callback' => 'window.location.href = ' . json_encode($link, JSON_UNESCAPED_SLASHES) . ';'
  ]);
} catch (Throwable $e) {
  modal('ERROR', __('Error'), $e->getMessage());
}
