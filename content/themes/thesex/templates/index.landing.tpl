{include file='_head.tpl'}
{include file='_header.tpl'}

<style>
  .ts-landing { --ts-ink: #0b0b11; --ts-panel: #171620; --ts-muted: #a9a4b4; --ts-pink: #ff4fa3; --ts-pink-soft: #ffb6d7; background: var(--ts-ink); color: #faf8ff; margin-top: -1px; overflow: hidden; }
  .ts-landing * { box-sizing: border-box; }
  .ts-hero { min-height: 690px; padding: 82px 0 64px; position: relative; }
  .ts-hero:before, .ts-hero:after { border-radius: 999px; content: ''; filter: blur(12px); opacity: .65; pointer-events: none; position: absolute; }
  .ts-hero:before { background: #b4287a; height: 430px; right: -150px; top: 35px; width: 430px; }
  .ts-hero:after { background: #5133b5; bottom: -210px; height: 460px; left: -185px; width: 460px; }
  .ts-hero .container, .ts-section .container { position: relative; z-index: 1; }
  .ts-overline { align-items: center; color: var(--ts-pink-soft); display: flex; font-size: .75rem; font-weight: 700; gap: 9px; letter-spacing: .12em; text-transform: uppercase; }
  .ts-overline:before { background: currentColor; border-radius: 50%; content: ''; height: 7px; width: 7px; }
  .ts-title { font-size: clamp(3rem, 7vw, 6.4rem); font-weight: 700; letter-spacing: -.075em; line-height: .9; margin: 20px 0 24px; max-width: 710px; }
  .ts-title em { color: var(--ts-pink); font-style: normal; }
  .ts-subtitle { color: #c6c0d0; font-size: 1.08rem; line-height: 1.65; max-width: 570px; }
  .ts-actions { align-items: center; display: flex; flex-wrap: wrap; gap: 14px; margin-top: 32px; }
  .ts-primary, .ts-secondary { border-radius: 999px; font-weight: 700; padding: 13px 22px; text-decoration: none; }
  .ts-primary { background: var(--ts-pink); color: #19030e; }
  .ts-primary:hover { background: #ff75b9; color: #19030e; }
  .ts-secondary { border: 1px solid rgba(255,255,255,.22); color: #fff; }
  .ts-secondary:hover { border-color: #fff; color: #fff; }
  .ts-age { color: #a9a4b4; font-size: .78rem; margin: 20px 0 0; }
  .ts-login { background: rgba(23,22,32,.88); border: 1px solid rgba(255,255,255,.13); border-radius: 24px; box-shadow: 0 28px 80px rgba(0,0,0,.35); padding: 8px; }
  .ts-login .card { background: transparent; border: 0; color: #fff; }
  .ts-login .card-header, .ts-login .card-body { background: transparent; color: inherit; }
  .ts-login .card-title { color: #fff; }
  .ts-login .form-control, .ts-login .form-select, .ts-login .input-group-text { background: rgba(255,255,255,.06); border-color: rgba(255,255,255,.12); color: #fff; }
  .ts-login .form-control::placeholder { color: #aaa3b3; }
  .ts-login .btn-primary { background: var(--ts-pink); border-color: var(--ts-pink); color: #19030e; }
  .ts-login a { color: var(--ts-pink-soft); }
  .ts-pulse-card { background: rgba(255,255,255,.08); border: 1px solid rgba(255,255,255,.12); border-radius: 18px; display: flex; gap: 14px; margin-top: 30px; max-width: 490px; padding: 15px; }
  .ts-pulse-card i { background: rgba(255,79,163,.15); border-radius: 12px; color: var(--ts-pink-soft); display: grid; flex: 0 0 43px; height: 43px; place-items: center; }
  .ts-pulse-card strong, .ts-pulse-card span { display: block; }
  .ts-pulse-card span { color: var(--ts-muted); font-size: .84rem; margin-top: 2px; }
  .ts-section { padding: 86px 0; }
  .ts-section--soft { background: #12111a; }
  .ts-section h2 { font-size: clamp(2rem, 4vw, 3.5rem); font-weight: 700; letter-spacing: -.055em; line-height: 1; max-width: 620px; }
  .ts-section p.lead { color: var(--ts-muted); font-size: 1.05rem; line-height: 1.7; max-width: 580px; }
  .ts-path-card { background: #1a1924; border: 1px solid rgba(255,255,255,.08); border-radius: 22px; height: 100%; padding: 28px; }
  .ts-path-card i { color: var(--ts-pink); font-size: 1.35rem; }
  .ts-path-card h3 { font-size: 1.28rem; font-weight: 700; margin: 20px 0 10px; }
  .ts-path-card p { color: var(--ts-muted); line-height: 1.6; }
  .ts-path-card a { color: var(--ts-pink-soft); font-weight: 700; text-decoration: none; }
  .ts-steps { counter-reset: ts-step; display: grid; gap: 18px; grid-template-columns: repeat(3, 1fr); margin-top: 38px; }
  .ts-step { border-top: 1px solid rgba(255,255,255,.17); padding-top: 18px; }
  .ts-step:before { color: var(--ts-pink); content: '0' counter(ts-step); counter-increment: ts-step; display: block; font-size: .76rem; font-weight: 700; letter-spacing: .12em; margin-bottom: 18px; }
  .ts-step h3 { font-size: 1rem; font-weight: 700; }
  .ts-step p { color: var(--ts-muted); font-size: .9rem; line-height: 1.6; margin: 0; }
  .ts-safety { background: linear-gradient(135deg, #24142b, #171620 65%); border: 1px solid rgba(255,182,215,.18); border-radius: 26px; padding: 34px; }
  .ts-safety h3 { font-size: 1.45rem; font-weight: 700; }
  .ts-safety p { color: #c6c0d0; line-height: 1.65; margin: 0; }
  @media (max-width: 991px) { .ts-hero { min-height: auto; padding-top: 52px; } .ts-login { margin-top: 22px; } }
  @media (max-width: 767px) { .ts-title { font-size: 3.3rem; } .ts-section { padding: 64px 0; } .ts-steps { grid-template-columns: 1fr; } }
</style>

<main class="ts-landing">
  <section class="ts-hero">
    <div class="container">
      <div class="row align-items-center g-5">
        <div class="col-lg-7">
          <div class="ts-overline">Uma plataforma para maiores de 18 anos</div>
          <h1 class="ts-title">Mais perto de quem você <em>quer acompanhar.</em></h1>
          <p class="ts-subtitle">Descubra criadores, acompanhe conteúdo exclusivo e encontre perfis e anúncios em uma experiência privada, moderna e feita para o celular.</p>
          <div class="ts-actions">
            <a class="ts-primary" href="{$system['system_url']}/creators">Explorar criadores</a>
            <a class="ts-secondary" href="{$system['system_url']}/signup">Criar minha conta</a>
          </div>
          <p class="ts-age">Ao continuar, você declara ter 18 anos ou mais e concorda com os Termos e a Política de Privacidade.</p>
          <div class="ts-pulse-card">
            <i class="fa-solid fa-shield-heart"></i>
            <div><strong>Privacidade e controle vêm primeiro.</strong><span>Perfis, conteúdo e interações protegidos por regras claras e moderação.</span></div>
          </div>
        </div>
        <div class="col-lg-5">
          <div class="ts-login">{include file='_sign_form.tpl' do="in"}</div>
        </div>
      </div>
    </div>
  </section>

  <section class="ts-section ts-section--soft">
    <div class="container">
      <div class="row g-5 align-items-end mb-4">
        <div class="col-lg-7"><div class="ts-overline">Dois jeitos de participar</div><h2 class="mt-3 mb-0">Uma comunidade que valoriza escolha e autonomia.</h2></div>
        <div class="col-lg-5"><p class="lead mb-0">A estrutura existente já suporta perfis, assinaturas, publicações pagas, mensagens e carteira. Agora ela ganha uma experiência pensada para este produto.</p></div>
      </div>
      <div class="row g-4">
        <div class="col-md-6"><article class="ts-path-card"><i class="fa-solid fa-sparkles"></i><h3>Assine seus criadores</h3><p>Escolha perfis, acompanhe posts exclusivos e mantenha suas assinaturas organizadas em um único lugar.</p><a href="{$system['system_url']}/creators">Ver criadores <i class="fa-solid fa-arrow-right ms-1"></i></a></article></div>
        <div class="col-md-6"><article class="ts-path-card"><i class="fa-solid fa-location-dot"></i><h3>Encontre o que procura</h3><p>Uma área de classificados com descoberta por localização, categorias, planos de destaque e perfis verificados.</p><a href="{$system['system_url']}/market">Explorar classificados <i class="fa-solid fa-arrow-right ms-1"></i></a></article></div>
      </div>
    </div>
  </section>

  <section class="ts-section">
    <div class="container">
      <div class="ts-overline">Simples desde o início</div>
      <h2 class="mt-3">Você entra. Escolhe. Acompanha.</h2>
      <div class="ts-steps">
        <div class="ts-step"><h3>Crie sua conta</h3><p>Monte seu perfil e defina as preferências que fazem sentido para você.</p></div>
        <div class="ts-step"><h3>Descubra perfis</h3><p>Explore criadores e, em breve, encontre anúncios por categoria e localização.</p></div>
        <div class="ts-step"><h3>Controle sua experiência</h3><p>Assinaturas, mensagens, privacidade e pagamentos ficam sempre sob seu controle.</p></div>
      </div>
    </div>
  </section>

  <section class="ts-section pt-0">
    <div class="container"><div class="ts-safety"><div class="row g-4 align-items-center"><div class="col-lg-8"><h3>Uma plataforma adulta exige responsabilidade.</h3><p>Antes de liberar publicações e classificados para todos, vamos implementar verificação de idade, consentimento, denúncia, bloqueio, análise de conteúdo e trilha de auditoria.</p></div><div class="col-lg-4 text-lg-end"><a class="ts-primary d-inline-block" href="{$system['system_url']}/static/terms">Ler nossos termos</a></div></div></div></div>
  </section>
</main>

{include file='_footer.tpl'}
