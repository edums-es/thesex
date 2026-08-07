{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
  .creator-directory { background: #0b0b11; color: #f7f5ff; margin-top: -1px; min-height: calc(100vh - 70px); padding: 54px 0 72px; }
  .creator-directory .eyebrow { color: #fb74ae; font-size: .78rem; font-weight: 700; letter-spacing: .12em; text-transform: uppercase; }
  .creator-directory h1 { font-size: clamp(2.25rem, 5vw, 4.5rem); font-weight: 700; letter-spacing: -.06em; line-height: .95; max-width: 760px; }
  .creator-directory .intro { color: #b9b4c7; font-size: 1.08rem; max-width: 620px; }
  .creator-grid { display: grid; gap: 18px; grid-template-columns: repeat(auto-fill, minmax(210px, 1fr)); }
  .creator-card { background: #15141e; border: 1px solid rgba(255,255,255,.09); border-radius: 22px; color: inherit; display: block; overflow: hidden; text-decoration: none; transition: transform .18s ease, border-color .18s ease; }
  .creator-card:hover { border-color: #ff5ca8; color: inherit; transform: translateY(-4px); }
  .creator-card img { aspect-ratio: 1 / .92; display: block; object-fit: cover; width: 100%; }
  .creator-card__body { padding: 16px; }
  .creator-card__name { align-items: center; display: flex; font-size: 1rem; font-weight: 700; gap: 6px; margin: 0 0 4px; }
  .creator-card__handle { color: #a59eaf; font-size: .86rem; margin: 0 0 16px; }
  .creator-card__meta { align-items: center; color: #f8a9cb; display: flex; font-size: .82rem; font-weight: 600; justify-content: space-between; }
  .creator-card__meta span:last-child { color: #a59eaf; font-weight: 500; }
  .creator-empty { background: #15141e; border: 1px dashed rgba(255,255,255,.16); border-radius: 22px; color: #b9b4c7; padding: 44px 24px; text-align: center; }
</style>

<main class="creator-directory">
  <div class="container">
    <div class="row align-items-end g-4 mb-5">
      <div class="col-lg-8">
        <div class="eyebrow">Descubra novos perfis</div>
        <h1>Conteúdo exclusivo, criadores de verdade.</h1>
        <p class="intro mb-0">Explore perfis que já disponibilizam assinaturas. Você escolhe quem acompanhar e gerencia tudo em um só lugar.</p>
      </div>
      <div class="col-lg-4 text-lg-end">
        {if $user->_logged_in}
          <a class="btn btn-primary rounded-pill px-4" href="{$system['system_url']}/settings/monetization">Quero criar conteúdo</a>
        {else}
          <a class="btn btn-primary rounded-pill px-4" href="{$system['system_url']}/signup">Criar minha conta</a>
        {/if}
      </div>
    </div>

    {if $creators}
      <div class="creator-grid">
        {foreach $creators as $creator}
          <a class="creator-card" href="{$system['system_url']}/{$creator['user_name']}">
            <img src="{$creator['user_picture']}" alt="Perfil de {$creator['user_name']}">
            <div class="creator-card__body">
              <p class="creator-card__name">
                {if $system['show_usernames_enabled']}{$creator['user_name']}{else}{$creator['user_firstname']} {$creator['user_lastname']}{/if}
                {if $creator['user_verified']}<i class="fa-solid fa-circle-check" aria-label="Perfil verificado"></i>{/if}
              </p>
              <p class="creator-card__handle">@{$creator['user_name']}</p>
              <div class="creator-card__meta">
                <span>A partir de {print_money($creator['min_price'])}</span>
                <span>{$creator['subscribers_count']} assinantes</span>
              </div>
            </div>
          </a>
        {/foreach}
      </div>
    {else}
      <div class="creator-empty">
        <h4 class="text-white">Os primeiros criadores estão chegando</h4>
        <p class="mb-0">Assim que um perfil publicar um plano de assinatura, ele aparecerá aqui.</p>
      </div>
    {/if}
  </div>
</main>

{include file='_footer.tpl'}
