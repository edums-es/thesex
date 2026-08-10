<?php

/**
 * ajax -> admin -> languages
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

// handle languages
try {

  switch ($_GET['do']) {
    case 'edit':
      /* valid inputs */
      if (!isset($_GET['id']) || !is_numeric($_GET['id'])) {
        _error(400);
      }
      $language_id = (int) $_GET['id'];
      if (!in_array($language_id, [EN_FALLBACK_LANGUAGE_ID, BR_LANGUAGE_ID], true)) {
        throw new Exception('O modo Brasil permite apenas Português (Brasil) e o inglês técnico de reserva');
      }
      /* prepare */
      $_POST['default'] = ($language_id === BR_LANGUAGE_ID) ? '1' : '0';
      $_POST['enabled'] = ($language_id === BR_LANGUAGE_ID) ? '1' : '0';
      $_POST['code'] = ($language_id === BR_LANGUAGE_ID) ? 'pt_br' : 'en_us';
      $_POST['title'] = ($language_id === BR_LANGUAGE_ID) ? 'Português (Brasil)' : 'English (fallback)';
      $_POST['flag'] = ($language_id === BR_LANGUAGE_ID) ? 'flags/pt_br.png' : 'flags/en_us.png';
      $_POST['dir'] = 'LTR';
      $_POST['language_order'] = ($language_id === BR_LANGUAGE_ID) ? 1 : 2;
      /* if default is set -> set all languages as not default first */
      if ($_POST['default']) {
        $db->query("UPDATE system_languages SET system_languages.default = '0'");
      }
      /* update */
      $db->query(sprintf("UPDATE system_languages SET system_languages.default = %s, enabled = %s, code = %s, title = %s, flag = %s, dir = %s, language_order = %s WHERE language_id = %s", secure($_POST['default']), secure($_POST['enabled']), secure($_POST['code']), secure($_POST['title']), secure($_POST['flag']), secure($_POST['dir']), secure($_POST['language_order'], 'int'), secure($_GET['id'], 'int')));
      /* remove pending uploads */
      remove_pending_uploads([$_POST['flag']]);
      /* return */
      return_json(['success' => true, 'message' => __("Language info have been updated")]);
      break;

    case 'add':
      throw new Exception('O modo Brasil não permite adicionar outros idiomas');

    default:
      _error(400);
      break;
  }
} catch (Exception $e) {
  return_json(['error' => true, 'message' => $e->getMessage()]);
}
