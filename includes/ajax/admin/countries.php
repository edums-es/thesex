<?php

/**
 * ajax -> admin -> countries
 * 
 * @package Sngine
 * @author Zamblek
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// check admin|moderator permission
if (!$user->_is_admin) {
  modal("MESSAGE", __("System Message"), __("You don't have the right permission to access this"));
}

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

// handle countries
try {

  switch ($_GET['do']) {
    case 'edit':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id']) || (int) $_GET['id'] !== BR_COUNTRY_ID) {
        _error(400);
      }
      /* prepare */
      $_POST['default'] = '1';
      $_POST['enabled'] = '1';
      $_POST['country_code'] = 'BR';
      $_POST['country_name'] = 'Brasil';
      $_POST['phone_code'] = '+55';
      $_POST['country_order'] = 1;
      /* if default is set -> set all countries as not default first */
      if ($_POST['default']) {
        $db->query("UPDATE system_countries SET system_countries.default = '0'");
      }
      /* update */
      $db->query(sprintf("UPDATE system_countries SET system_countries.default = %s, `enabled` = %s, country_code = %s, country_name = %s, phone_code = %s, country_vat = %s, country_order = %s WHERE country_id = %s", secure($_POST['default']), secure($_POST['enabled']), secure($_POST['country_code']), secure($_POST['country_name']), secure($_POST['phone_code']), secure($_POST['country_vat'], 'float'), secure($_POST['country_order'], 'int'), secure($_GET['id'], 'int')));
      /* return */
      return_json(['success' => true, 'message' => __("Country info have been updated")]);
      break;

    case 'add':
      throw new Exception('O modo Brasil não permite adicionar outros países');

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
