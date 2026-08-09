{include file='_head.tpl'}
{include file='_header.tpl'}

<main class="creator-directory">
  <div class="container">
    <div class="row align-items-end g-4">
      <div class="col-lg-8">
        <div class="creator-directory__eyebrow">{__("Discover creators")}</div>
        <h1 class="creator-directory__title">{__("Exclusive content from creators worth following.")}</h1>
        <p class="creator-directory__intro mb-0">{__("Explore verified profiles with active subscriptions, paid publications and direct ways to connect.")}</p>
      </div>
      <div class="col-lg-4">
        <div class="creator-directory__actions">
          <a class="creator-secondary-button" href="{$system['system_url']}/acompanhantes">
            <i class="fa fa-location-dot mr5"></i>{__("Companions")}
          </a>
          {if $user->_logged_in}
            <a class="creator-primary-button" href="{$system['system_url']}/settings/monetization">{__("Become a creator")}</a>
          {else}
            <a class="creator-primary-button" href="{$system['system_url']}/signup">{__("Create Account")}</a>
          {/if}
        </div>
      </div>
    </div>

    <div class="creator-trust-strip">
      <div class="creator-trust-item"><i class="fa fa-circle-check"></i>{__("Verified profiles appear first")}</div>
      <div class="creator-trust-item"><i class="fa fa-lock"></i>{__("Exclusive content protected by subscriptions")}</div>
      <div class="creator-trust-item"><i class="fa fa-triangle-exclamation"></i>{__("Adults only. Report suspicious profiles.")}</div>
    </div>

    {if $creators}
      <div class="creator-grid">
        {foreach $creators as $creator}
          <a class="creator-card" href="{$system['system_url']}/{$creator['user_name']}">
            <div class="creator-card__media">
              <img src="{$creator['user_picture']}" alt="{__("Profile of")} {$creator['user_name']}" loading="lazy">
              <span class="creator-card__badge"><i class="fa fa-crown"></i>{__("Creator")}</span>
            </div>
            <div class="creator-card__body">
              <p class="creator-card__name">
                {if $system['show_usernames_enabled']}{$creator['user_name']}{else}{$creator['user_firstname']} {$creator['user_lastname']}{/if}
                {if $creator['user_verified']}<i class="fa-solid fa-circle-check" aria-label="{__("Verified profile")}"></i>{/if}
              </p>
              <p class="creator-card__handle">@{$creator['user_name']}</p>
              <div class="creator-card__meta">
                <span>{__("From")} {print_money($creator['min_price'])}</span>
                <span>{$creator['subscribers_count']} {__("Subscribers")|lower}</span>
              </div>
            </div>
          </a>
        {/foreach}
      </div>
    {else}
      <div class="creator-empty">
        <i class="fa fa-crown fa-2x mb-3"></i>
        <h4 class="text-white">{__("The first creators are arriving")}</h4>
        <p class="mb-0">{__("Profiles will appear here after activating monetization and publishing a subscription plan.")}</p>
      </div>
    {/if}
  </div>
</main>

{include file='_footer.tpl'}
