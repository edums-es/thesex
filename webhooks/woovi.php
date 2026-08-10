<?php

/**
 * Woovi/OpenPix webhook with official RSA SHA-256 signature validation.
 */

define('PAYMENT_WEBHOOK_CONTEXT', true);
require('../bootstrap.php');

if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
  br_payments_json_response(405, ['ok' => false]);
}
if (!$system['woovi_enabled'] || empty($system['woovi_app_id'])) {
  br_payments_json_response(503, ['ok' => false]);
}
$contentLength = (int) ($_SERVER['CONTENT_LENGTH'] ?? 0);
if ($contentLength > 1048576) {
  br_payments_json_response(413, ['ok' => false]);
}
$raw = file_get_contents('php://input');
$signature = (string) ($_SERVER['HTTP_X_WEBHOOK_SIGNATURE'] ?? '');
if (!br_payments_verify_woovi_signature($raw, $signature)) {
  br_payments_json_response(401, ['ok' => false]);
}
$payload = json_decode($raw, true);
if (!is_array($payload)) {
  br_payments_json_response(400, ['ok' => false]);
}

try {
  br_payments_ensure_schema();
  $event = (string) ($payload['event'] ?? '');
  if ($event !== 'OPENPIX:CHARGE_COMPLETED') {
    br_payments_json_response(200, ['ok' => true, 'ignored' => true]);
  }
  $reference = (string) ($payload['charge']['correlationID'] ?? '');
  if (!preg_match('/^thx_[a-f0-9]{32}$/', $reference)) {
    br_payments_json_response(200, ['ok' => true, 'ignored' => true]);
  }
  $transaction = br_payments_get_transaction($reference, 'woovi');
  if (!$transaction) {
    throw new Exception('Unknown payment reference');
  }

  /* Do not trust even a signed event alone: confirm the charge through AppID. */
  $verified = br_payments_get_woovi_charge($reference);
  $charge = $verified['charge'] ?? [];
  if (($charge['status'] ?? '') !== 'COMPLETED'
    || ($charge['correlationID'] ?? '') !== $reference
    || (int) ($charge['value'] ?? 0) !== (int) $transaction['amount_cents']) {
    throw new Exception('Woovi charge verification failed');
  }
  $providerId = $charge['globalID'] ?? $charge['transactionID'] ?? $charge['paymentLinkID'] ?? null;
  $processed = br_payments_complete_transaction($reference, 'woovi', $providerId, $event);
  br_payments_json_response(200, ['ok' => true, 'processed' => $processed]);
} catch (Throwable $e) {
  error_log('Woovi webhook: ' . $e->getMessage());
  br_payments_json_response(503, ['ok' => false]);
}
