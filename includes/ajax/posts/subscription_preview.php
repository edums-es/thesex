<?php

/**
 * ajax -> posts -> subscription preview
 *
 * @package Sngine
 */

// fetch bootstrap
require('../../../bootstrap.php');

// check AJAX Request
is_ajax();

// user access
user_access(true);

// check demo account
if ($user->_data['user_demo']) {
  modal("ERROR", __("Demo Restriction"), __("You can't do this with demo account"));
}

try {
  if (!isset($_GET['post_id']) || !is_numeric($_GET['post_id'])) {
    _error(400);
  }
  $post = $user->get_post($_GET['post_id']);
  if (!$post || !$post['manage_post'] || !$post['for_subscriptions']) {
    _error(403);
  }
  $smarty->assign('post', $post);
  $return['template'] = $smarty->fetch("ajax.subscription_preview.editor.tpl");
  $return['callback'] = "$('#modal').modal('show'); $('.modal-content:last').html(response.template); initialize_modal();";
  return_json($return);
} catch (Exception $e) {
  modal("ERROR", __("Error"), $e->getMessage());
}
