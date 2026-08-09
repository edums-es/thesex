<?php

/**
 * companions discovery directory
 *
 * Reuses public profile, location and monetization data. It does not create a
 * second payment system and deliberately avoids exposing private locations.
 */

require('bootloader.php');

try {
  user_access();
  $city = mb_substr(trim($_GET['city'] ?? ''), 0, 64);

  page_header(
    'Acompanhantes | ' . __($system['system_title']),
    'Descubra perfis públicos por cidade',
    $system['system_url'] . '/content/themes/' . $system['theme'] . '/images/og-thesex.png'
  );

  $where_city = '';
  if ($city !== '') {
    $where_city = sprintf(" AND users.user_current_city LIKE %s", secure('%' . $city . '%'));
  }

  $companions = [];
  $get_companions = $db->query("SELECT
      users.user_id, users.user_name, users.user_firstname, users.user_lastname,
      users.user_gender, users.user_picture, users.user_verified,
      users.user_current_city, plans.min_price
    FROM users
    INNER JOIN (
      SELECT node_id, MIN(price) AS min_price
      FROM monetization_plans
      WHERE node_type = 'profile'
      GROUP BY node_id
    ) AS plans ON plans.node_id = users.user_id
    WHERE users.user_banned = '0'
      AND users.user_activated = '1'
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
