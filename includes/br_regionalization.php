<?php

/**
 * Brazil-only regionalization.
 *
 * English remains the Sngine source/fallback locale, while Portuguese (Brazil),
 * Brazil and BRL are the only regional choices exposed by the application.
 */

const BR_REGIONALIZATION_VERSION = '1';
const BR_COUNTRY_ID = 30;
const BR_CURRENCY_ID = 2;
const BR_LANGUAGE_ID = 12;
const EN_FALLBACK_LANGUAGE_ID = 1;


/**
 * Run a regionalization statement or stop the migration safely.
 */
function br_regionalization_query($query)
{
  global $db;
  $result = $db->query($query);
  if ($result === false) {
    throw new Exception('Brazil regionalization failed: ' . $db->error);
  }
  return $result;
}


/**
 * Apply the one-time migration to existing installations.
 */
function br_regionalization_apply()
{
  global $db;

  $version_result = $db->query("SELECT option_value FROM system_options WHERE option_name = 'br_regionalization_version' LIMIT 1");
  if ($version_result && $version_result->num_rows > 0) {
    $version = $version_result->fetch_assoc();
    if ($version['option_value'] === BR_REGIONALIZATION_VERSION) {
      return;
    }
  }

  try {
    $db->begin_transaction();

    /* essential regional catalog */
    br_regionalization_query("DELETE FROM system_countries WHERE country_code = 'BR' AND country_id <> " . BR_COUNTRY_ID);
    br_regionalization_query("INSERT INTO system_countries (country_id, country_code, country_name, phone_code, country_vat, `default`, enabled, country_order)
      VALUES (" . BR_COUNTRY_ID . ", 'BR', 'Brasil', '+55', NULL, '1', '1', 1)
      ON DUPLICATE KEY UPDATE country_code = 'BR', country_name = 'Brasil', phone_code = '+55', `default` = '1', enabled = '1', country_order = 1");
    br_regionalization_query("UPDATE users SET user_country = " . BR_COUNTRY_ID . ", user_language = 'pt_br'");
    br_regionalization_query("DELETE FROM system_countries WHERE country_id <> " . BR_COUNTRY_ID);

    /* canonical BRL currency */
    br_regionalization_query("INSERT INTO system_currencies (currency_id, name, code, symbol, dir, `default`, enabled)
      VALUES (" . BR_CURRENCY_ID . ", 'Real brasileiro', 'BRL', 'R$', 'left', '1', '1')
      ON DUPLICATE KEY UPDATE name = 'Real brasileiro', code = 'BRL', symbol = 'R$', dir = 'left', `default` = '1', enabled = '1'");
    br_regionalization_query("DELETE FROM system_currencies WHERE currency_id <> " . BR_CURRENCY_ID);

    /* Portuguese is public; English is retained disabled as source fallback */
    br_regionalization_query("DELETE FROM system_languages WHERE code = 'en_us' AND language_id <> " . EN_FALLBACK_LANGUAGE_ID);
    br_regionalization_query("DELETE FROM system_languages WHERE code = 'pt_br' AND language_id <> " . BR_LANGUAGE_ID);
    br_regionalization_query("INSERT INTO system_languages (language_id, code, title, flag, dir, `default`, enabled, language_order)
      VALUES (" . EN_FALLBACK_LANGUAGE_ID . ", 'en_us', 'English (fallback)', 'flags/en_us.png', 'LTR', '0', '0', 2)
      ON DUPLICATE KEY UPDATE code = 'en_us', title = 'English (fallback)', flag = 'flags/en_us.png', dir = 'LTR', `default` = '0', enabled = '0', language_order = 2");
    br_regionalization_query("INSERT INTO system_languages (language_id, code, title, flag, dir, `default`, enabled, language_order)
      VALUES (" . BR_LANGUAGE_ID . ", 'pt_br', 'Português (Brasil)', 'flags/pt_br.png', 'LTR', '1', '1', 1)
      ON DUPLICATE KEY UPDATE code = 'pt_br', title = 'Português (Brasil)', flag = 'flags/pt_br.png', dir = 'LTR', `default` = '1', enabled = '1', language_order = 1");
    br_regionalization_query("DELETE FROM system_languages WHERE language_id NOT IN (" . EN_FALLBACK_LANGUAGE_ID . ", " . BR_LANGUAGE_ID . ")");

    /* Brazilian presentation defaults */
    br_regionalization_query("INSERT INTO system_options (option_name, option_value) VALUES
      ('auto_language_detection', '0'),
      ('system_datetime_format', 'd/m/Y H:i'),
      ('br_only_mode', '1')
      ON DUPLICATE KEY UPDATE option_value = VALUES(option_value)");
    br_regionalization_query("UPDATE system_options SET option_value = 'Voltaremos em breve' WHERE option_name = 'system_message' AND option_value = 'We will Back Soon'");
    br_regionalization_query("UPDATE system_options SET option_value = 'Compartilhe momentos, conheça pessoas e acompanhe seus criadores favoritos' WHERE option_name = 'system_description' AND option_value = 'Share your memories, connect with others, make new friends'");
    br_regionalization_query("UPDATE system_options SET option_value = 'Brasil' WHERE option_name = 'bank_account_country' AND option_value = ''");

    $db->commit();
  } catch (Throwable $error) {
    $db->rollback();
    error_log($error->getMessage());
    return;
  }

  /* normalize optional modules without allowing one absent module to block PT-BR */
  $optional_queries = [
    'pages' => "UPDATE pages SET page_country = " . BR_COUNTRY_ID . ", page_language = " . BR_LANGUAGE_ID,
    'groups' => "UPDATE `groups` SET group_country = " . BR_COUNTRY_ID . ", group_language = " . BR_LANGUAGE_ID,
    'events' => "UPDATE events SET event_country = " . BR_COUNTRY_ID . ", event_language = " . BR_LANGUAGE_ID,
    'ads_campaigns' => "UPDATE ads_campaigns SET audience_countries = '" . BR_COUNTRY_ID . "' WHERE audience_countries <> ''",
    'auto_connect' => "DELETE FROM auto_connect WHERE country_id <> " . BR_COUNTRY_ID,
    'posts_jobs' => "UPDATE posts_jobs SET salary_minimum_currency = " . BR_CURRENCY_ID . ", salary_maximum_currency = " . BR_CURRENCY_ID,
    'posts_courses' => "UPDATE posts_courses SET fees_currency = " . BR_CURRENCY_ID,
    'widgets' => "UPDATE widgets SET language_id = " . BR_LANGUAGE_ID . " WHERE language_id <> 0",
  ];
  $optional_success = true;
  foreach ($optional_queries as $table => $query) {
    $safe_table = $db->real_escape_string($table);
    $table_result = $db->query("SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name = '" . $safe_table . "' LIMIT 1");
    if (!$table_result || $table_result->num_rows === 0) {
      continue;
    }
    try {
      br_regionalization_query($query);
    } catch (Throwable $error) {
      $optional_success = false;
      error_log($error->getMessage());
    }
  }

  if ($optional_success) {
    try {
      br_regionalization_query("INSERT INTO system_options (option_name, option_value)
        VALUES ('br_regionalization_version', '" . BR_REGIONALIZATION_VERSION . "')
        ON DUPLICATE KEY UPDATE option_value = VALUES(option_value)");
    } catch (Throwable $error) {
      error_log($error->getMessage());
    }
  }
}


/**
 * Expose immutable regional defaults to templates and integrations.
 */
function br_regionalization_apply_defaults(&$system)
{
  $system['br_only_mode'] = '1';
  $system['auto_language_detection'] = '0';
}
