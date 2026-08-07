{include file='_head.tpl'}
{include file='_header.tpl'}

<main class="ts-feed-page">
  <div class="ts-feed-container">
    {if $user->_logged_in}
      <section class="ts-story-section">
        <div class="ts-story-section__top"><strong>Para você</strong><a href="{$system['system_url']}/creators">Ver criadores</a></div>
        {if $user->_data['can_add_stories'] || ($system['stories_enabled'] && !empty($stories['array']))}
          <div class="ts-story-rail stories-wrapper">
            <div id="stories" data-json='{htmlspecialchars($stories["json"], ENT_QUOTES, 'UTF-8')}'>
              {if $user->_data['can_add_stories']}
                <div class="add-story" data-toggle="modal" data-url="posts/story.php?do=create"><div class="img" style="background-image:url({$user->_data['user_picture']});"></div><div class="add"><i class="fa-solid fa-plus"></i></div></div>
              {/if}
            </div>
          </div>
        {/if}
      </section>

      <div class="ts-feed-tabs"><a class="is-active" href="{$system['system_url']}"><i class="fa-solid fa-user-group"></i> Seguindo</a><a href="{$system['system_url']}/discover"><i class="fa-solid fa-arrow-trend-up"></i> Em alta</a><a href="{$system['system_url']}/creators"><i class="fa-regular fa-clock"></i> Novos</a></div>

      <div class="ts-publisher" data-toggle="modal" data-url="posts/publisher.php"><img src="{$user->_data['user_picture']}" alt=""><span>Compartilhe algo com seus assinantes...</span><i class="fa-solid fa-image"></i></div>

      <a class="ts-companion-callout" href="{$system['system_url']}/acompanhantes"><span class="ts-companion-callout__icon"><i class="fa-solid fa-location-dot"></i></span><span><strong>Acompanhantes</strong><small>Perfis por cidade, com filtros e verificação</small></span><i class="fa-solid fa-arrow-right"></i></a>
    {/if}

    <section class="ts-feed-list">
      {include file='_announcements.tpl'}
      {if $posts}
        <ul>{foreach $posts as $post}{include file='__feeds_post.tpl'}{/foreach}</ul>
      {else}
        <div class="ts-empty"><i class="fa-regular fa-star"></i><h4>Seu feed está pronto para ganhar vida</h4><p>Siga criadores para receber conteúdo novo por aqui.</p><a href="{$system['system_url']}/creators">Descobrir criadores</a></div>
      {/if}
    </section>
  </div>
</main>

{include file='_footer.tpl'}
