<?php

/**
 * public creators directory
 *
 * @package Sngine
 */

require('bootloader.php');

try {
  page_header(
    'Criadores | ' . __($system['system_title']),
    'Descubra perfis com planos de assinatura ativos',
    $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/og-thesex.png'
  );

  /*
   * The current monetization module already owns plans and subscriptions.
   * This directory only exposes profiles that opted into monetization; it does
   * not create a second payment or subscription system.
   */
  $creators = [];
  $get_creators = $db->query("SELECT
      users.user_id,
      users.user_name,
      users.user_firstname,
      users.user_lastname,
      users.user_gender,
      users.user_picture,
      users.user_verified,
      plans.min_price,
      plans.period_num,
      plans.period,
      COALESCE(subscriptions.total, 0) AS subscribers_count
    FROM users
    INNER JOIN (
      SELECT node_id, MIN(price) AS min_price, MIN(period_num) AS period_num, MIN(period) AS period
      FROM monetization_plans
      WHERE node_type = 'profile'
      GROUP BY node_id
    ) AS plans ON plans.node_id = users.user_id
    LEFT JOIN (
      SELECT node_id, COUNT(*) AS total
      FROM subscribers
      WHERE node_type = 'profile'
      GROUP BY node_id
    ) AS subscriptions ON subscriptions.node_id = users.user_id
    WHERE users.user_banned = '0' AND users.user_monetization_enabled = '1'
    ORDER BY users.user_verified DESC, subscribers_count DESC, users.user_id DESC
    LIMIT 24");

  while ($creator = $get_creators->fetch_assoc()) {
    $creator['user_picture'] = get_picture($creator['user_picture'], $creator['user_gender']);
    $creators[] = $creator;
  }
  $smarty->assign('creators', $creators);
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

page_footer('creators');
