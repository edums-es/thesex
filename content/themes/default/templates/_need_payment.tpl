<!-- need payment -->
<div class="creator-lock creator-lock--payment {if $paid_image}has-cover{/if}" {if $paid_image}style="background-image: url('{$system['system_uploads']}/{$paid_image}');"{/if}>
  <div class="creator-lock__shade"></div>
  <div class="creator-lock__content">
    <div class="creator-lock__icon">
      {include file='__svg_icons.tpl' icon="locked" class="main-icon" width="34px" height="34px"}
    </div>
    <div class="creator-lock__eyebrow">{__("Paid Post")}</div>
    <h3>{__("Unlock this publication")}</h3>
    <p>{__("Make a one-time payment to access this content.")}</p>
    <div class="d-grid">
      {if $discounted_price}
        <button class="btn creator-lock__cta rounded-pill {if !$user->_logged_in}js_login{/if}" {if $user->_logged_in}data-toggle="modal" data-url="#payment" data-options='{ "handle": "paid_post", "paid_post": "true", "id": {$post_id}, "price": {$discounted_price}, "vat": "{get_payment_vat_value($discounted_price)}", "fees": "{get_payment_fees_value($discounted_price)}", "total": "{get_payment_total_value($discounted_price)}", "total_printed": "{get_payment_total_value($discounted_price, true)}" }' {/if}>
          <i class="fa fa-lock-open mr5"></i>{__("Unlock for")} {print_money($discounted_price)}<span class="creator-lock__old-price">{print_money($price)}</span>
        </button>
      {else}
        <button class="btn creator-lock__cta rounded-pill {if !$user->_logged_in}js_login{/if}" {if $user->_logged_in}data-toggle="modal" data-url="#payment" data-options='{ "handle": "paid_post", "paid_post": "true", "id": {$post_id}, "price": {$price}, "vat": "{get_payment_vat_value($price)}", "fees": "{get_payment_fees_value($price)}", "total": "{get_payment_total_value($price)}", "total_printed": "{get_payment_total_value($price, true)}" }' {/if}>
          <i class="fa fa-lock-open mr5"></i>{__("Unlock for")} {print_money($price)}
        </button>
      {/if}
      {if $paid_text}
        <div class="creator-lock__description">{$paid_text}</div>
      {/if}
    </div>
  </div>
</div>
<!-- need payment -->
