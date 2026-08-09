<!-- need subscription -->
<div class="creator-lock creator-lock--subscription {if $subscriptions_image}has-cover{/if}" {if $subscriptions_image}style="background-image: url('{$system['system_uploads']}/{$subscriptions_image}');"{/if}>
  <div class="creator-lock__shade"></div>
  <div class="creator-lock__content">
    <div class="creator-lock__icon">
      {include file='__svg_icons.tpl' icon="locked" class="main-icon" width="34px" height="34px"}
    </div>
    <div class="creator-lock__eyebrow">{__("Subscriber-only content")}</div>
    <h3>{__("Exclusive content")}</h3>
    <p>{__("Subscribe to unlock this creator's private content.")}</p>
    {if isset($price)}
      <div class="d-grid">
        <button class="btn creator-lock__cta rounded-pill" data-toggle="modal" data-url="monetization/controller.php?do=get_plans&node_id={$node_id}&node_type={$node_type}" data-size="large">
          <i class="fa fa-crown mr5"></i>{__("Choose a plan")} - {if $discount_enabled}{print_money($price * (1 - $discount_percent / 100))}<span class="creator-lock__old-price">{print_money($price)}</span>{else}{print_money($price)}{/if}
        </button>
      </div>
    {/if}
  </div>
</div>
<!-- need subscription -->
