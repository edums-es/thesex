<?php

/**
 * companions discovery directory
 *
 * This page deliberately reuses the existing profile and monetization data.
 * It introduces no destructive database changes and is safe to disable by
 * removing the route or switching back to the default theme.
 */

require('bootloader.php');

try {
  user_access();
  $city = trim($_GET['city'] ?? '');

  page_header('Acompanhantes | ' . __($system['system_title']), 'Perfis para descobrir por cidade');

  $where_city = '';
  if ($city !== '') {
    $where_city = sprintf(" AND users.user_current_city LIKE %s", secure('%' . $city . '%'));
  }

  $companions = [];
  $get_companions = $db->query("SELECT
      users.user_id, users.user_name, users.user_firstname, users.user_lastname,
      users.user_gender, users.user_picture, users.user_verified,
      users.user_current_city, plans.min_price, plans.period
    FROM users
    INNER JOIN (
      SELECT node_id, MIN(price) AS min_price, MIN(period) AS period
      FROM monetization_plans
      WHERE node_type = 'profile'
      GROUP BY node_id
    ) AS plans ON plans.node_id = users.user_id
    WHERE users.user_banned = '0'
      AND users.user_monetization_enabled = '1'
      AND users.user_privacy_location = 'public'" . $where_city . "
    ORDER BY users.user_verified DESC, users.user_id DESC
    LIMIT 36");

  while ($companion = $get_companions->fetch_assoc()) {
    $companion['user_picture'] = get_picture($companion['user_picture'], $companion['user_gender']);
    $companions[] = $companion;
  }

  $smarty->assign('companions', $companions);
  $smarty->assign('selected_city', htmlspecialchars($city, ENT_QUOTES, 'UTF-8'));
} catch (Exception $e) {
  _error(__("Error"), $e->getMessage());
}

page_footer('acompanhantes');
