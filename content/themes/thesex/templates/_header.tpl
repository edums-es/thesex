<body data-hash-tok="{$session_hash['token']}" data-hash-pos="{$session_hash['position']}" {if $user->_logged_in}data-chat-enabled="{$user->_data['user_chat_enabled']}"{/if} class="ts-shell {if !$user->_logged_in}visitor{/if}">
  <div class="main-wrapper">
    <header class="ts-header">
      <div class="ts-header__inner">
        <a href="{$system['system_url']}" class="ts-brand" aria-label="Início">
          <span class="ts-brand__mark">t</span><span>{__($system['system_title'])}</span>
        </a>

        {if $user->_logged_in}
          <nav class="ts-nav" aria-label="Navegação principal">
            <a class="{if $page == 'index'}is-active{/if}" href="{$system['system_url']}"><i class="fa-solid fa-house"></i><span>Feed</span></a>
            <a href="{$system['system_url']}/creators"><i class="fa-regular fa-compass"></i><span>Descobrir</span></a>
            <a class="ts-nav__featured {if $page == 'acompanhantes'}is-active{/if}" href="{$system['system_url']}/acompanhantes"><i class="fa-solid fa-location-dot"></i><span>Acompanhantes</span></a>
          </nav>
          <a class="ts-search" href="{$system['system_url']}/creators"><i class="fa-solid fa-magnifying-glass"></i><span>Pesquisar criadores</span></a>
          <nav class="ts-actions" aria-label="Atalhos">
            <a href="{$system['system_url']}/messages" title="Mensagens"><i class="fa-regular fa-message"></i></a>
            <a href="{$system['system_url']}/notifications" title="Notificações"><i class="fa-regular fa-bell"></i></a>
            <a class="ts-wallet" href="{$system['system_url']}/wallet"><i class="fa-solid fa-wallet"></i><span>{print_money($user->_data['user_wallet_balance'])}</span></a>
            <a class="ts-avatar" href="{$system['system_url']}/{$user->_data['user_name']}" title="Meu perfil"><img src="{$user->_data['user_picture']}" alt="Meu perfil"></a>
          </nav>
        {else}
          <nav class="ts-actions ts-actions--visitor">
            <a href="{$system['system_url']}/creators">Explorar</a>
            <a href="{$system['system_url']}/signin">Entrar</a>
            <a class="ts-join" href="{$system['system_url']}/signup">Criar conta</a>
          </nav>
        {/if}
      </div>
    </header>
