{include file='_head.tpl'}
{include file='_header.tpl'}

<main class="creator-directory companion-directory">
  <div class="container">
    <div class="row align-items-end g-4">
      <div class="col-lg-8">
        <div class="creator-directory__eyebrow">{__("Local discovery")}</div>
        <h1 class="creator-directory__title">{__("Companions near you, with discreet discovery.")}</h1>
        <p class="creator-directory__intro mb-0">{__("Browse public creator profiles by city. Contact, prices and availability must always be confirmed directly with the profile owner.")}</p>
      </div>
      <div class="col-lg-4">
        <div class="creator-directory__actions">
          <a class="creator-secondary-button" href="{$system['system_url']}/creators"><i class="fa fa-crown mr5"></i>{__("Creators")}</a>
          {if $user->_logged_in}
            <a class="creator-primary-button" href="{$system['system_url']}/settings/profile"><i class="fa fa-pen mr5"></i>{__("Update my profile")}</a>
          {/if}
        </div>
      </div>
    </div>

    <form class="companion-search" method="get" action="{$system['system_url']}/acompanhantes">
      <label class="companion-search__field">
        <i class="fa fa-location-dot"></i>
        <input type="search" name="city" value="{$selected_city}" maxlength="64" placeholder="{__("Search by city")}" autocomplete="address-level2">
      </label>
      <button class="creator-primary-button" type="submit"><i class="fa fa-search mr5"></i>{__("Search")}</button>
    </form>

    <div class="companion-disclaimer">
      <i class="fa fa-shield-heart"></i>{__("This directory is restricted to adults. The platform does not intermediate meetings or guarantee information published by users. Never send documents or advance payments outside the platform.")}
    </div>

    {if $companions}
      <div class="companion-grid">
        {foreach $companions as $companion}
          <a class="companion-card" href="{$system['system_url']}/{$companion['user_name']}">
            <div class="companion-card__media">
              <img src="{$companion['user_picture']}" alt="{__("Profile of")} {$companion['user_name']}" loading="lazy">
              <span class="companion-card__badge"><i class="fa fa-location-dot"></i>{__("Public profile")}</span>
            </div>
            <div class="companion-card__body">
              <p class="companion-card__name">
                {if $system['show_usernames_enabled']}{$companion['user_name']}{else}{$companion['user_firstname']} {$companion['user_lastname']}{/if}
                {if $companion['user_verified']}<i class="fa-solid fa-circle-check" aria-label="{__("Verified profile")}"></i>{/if}
              </p>
              <p class="companion-card__location"><i class="fa fa-location-dot mr5"></i>{if $companion['user_current_city']}{$companion['user_current_city']}{else}{__("Location not informed")}{/if}</p>
              <div class="companion-card__meta">
                <span>{__("Content from")} {print_money($companion['min_price'])}</span>
                <span>{__("View profile")}</span>
              </div>
            </div>
          </a>
        {/foreach}
      </div>
    {else}
      <div class="creator-empty">
        <i class="fa fa-location-dot fa-2x mb-3"></i>
        <h4 class="text-white">{__("No public profiles found")}</h4>
        <p class="mb-0">{__("Try another city or clear the search to see all available profiles.")}</p>
      </div>
    {/if}
  </div>
</main>

{include file='_footer.tpl'}
