{include file='_head.tpl'}
{include file='_header.tpl'}

<main class="ts-directory-page">
  <section class="ts-directory-hero"><div class="ts-directory-wrap"><span class="ts-kicker">Descoberta local</span><h1>Acompanhantes</h1><p>Encontre perfis por cidade. Apenas perfis ativos e visíveis publicamente aparecem nesta área.</p><form class="ts-city-search" method="get" action="{$system['system_url']}/acompanhantes"><i class="fa-solid fa-magnifying-glass"></i><input name="city" value="{$selected_city}" placeholder="Digite uma cidade"><button type="submit">Buscar</button></form></div></section>
  <section class="ts-directory-wrap ts-directory-content"><div class="ts-directory-toolbar"><span>{if $selected_city}Resultados em {$selected_city}{else}Perfis em destaque{/if}</span><a href="{$system['system_url']}/settings/monetization">Quero aparecer aqui <i class="fa-solid fa-arrow-right"></i></a></div>
    {if $companions}<div class="ts-profile-grid">{foreach $companions as $companion}<a class="ts-profile-card" href="{$system['system_url']}/{$companion['user_name']}"><img src="{$companion['user_picture']}" alt="Perfil de {$companion['user_name']}"><span class="ts-profile-card__shade"></span><span class="ts-profile-card__content"><strong>{if $system['show_usernames_enabled']}{$companion['user_name']}{else}{$companion['user_firstname']} {$companion['user_lastname']}{/if}{if $companion['user_verified']} <i class="fa-solid fa-circle-check"></i>{/if}</strong><small>{if $companion['user_current_city']}{$companion['user_current_city']}{else}Localização privada{/if}</small><b>A partir de {print_money($companion['min_price'])}</b></span></a>{/foreach}</div>
    {else}<div class="ts-empty"><i class="fa-regular fa-compass"></i><h4>Nenhum perfil encontrado</h4><p>Tente outra cidade ou volte mais tarde.</p><a href="{$system['system_url']}/acompanhantes">Limpar busca</a></div>{/if}
  </section>
</main>

{include file='_footer.tpl'}
