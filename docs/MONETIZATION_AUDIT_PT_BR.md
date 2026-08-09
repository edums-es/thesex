# Auditoria da monetização nativa do Sngine

## Resumo

O Sngine 4.4.2 já possui uma base comparável a uma plataforma de criadores: planos recorrentes, conteúdo exclusivo para assinantes, publicações avulsas pagas, chat e chamadas pagas, gorjetas, cupons, descontos, saldo, comissão e saques. O principal problema não é ausência da função; é a experiência fragmentada, a tradução incorreta e a falta de recursos operacionais necessários para uma plataforma adulta.

Esta implementação deve continuar usando o tema `default` e os serviços nativos. Novos recursos devem entrar como módulos pequenos e revisáveis.

## Como a monetização é liberada

As condições abaixo precisam estar válidas ao mesmo tempo:

1. Admin → Monetization → `Monetization Enabled`.
2. Admin → Permissions Groups → grupo do usuário → `Monetization`.
3. Admin → Wallet ou Payments → pelo menos uma forma de pagamento utilizável.
4. Se `Required for Monetization` estiver ativo, o criador precisa estar verificado.
5. Criador → Settings → Monetization → ativar a monetização.
6. Criador → criar pelo menos um plano de assinatura.

Sem o item 2, a seção de monetização nem aparece nas configurações do usuário. Sem os itens 5 e 6, o botão de assinatura não aparece no perfil.

## Recursos nativos encontrados

- Planos de assinatura para perfis, páginas e grupos.
- Conteúdo visível somente para assinantes.
- Publicações pagas com desbloqueio individual.
- Blogs pagos.
- Chat por mensagem e chamadas de áudio/vídeo pagas.
- Lives para assinantes ou pagas.
- Cupons de desconto e desconto geral.
- Carteira interna e vários gateways de pagamento.
- Comissão da plataforma, extrato de ganhos e solicitações de saque.
- Gorjetas.
- Marcação de conteúdo adulto e bloqueio por maioridade/verificação.
- Planos gratuitos usados como prévia.

## Problemas confirmados nesta auditoria

- O catálogo `pt_BR` possui 4.919 identificadores, dos quais 1.853 têm tradução vazia e 1.758 estão marcados como imprecisos. Existem traduções semanticamente erradas, como “Monetization” traduzido como “Nenhuma notificação”.
- A ativação depende de várias telas sem um checklist claro.
- A consulta de um plano aplicava desconto mesmo quando o desconto geral estava desligado.
- A validação de publicação paga usava uma condição permissiva e aceitava combinações inválidas via requisição direta.
- O fluxo não tratava de forma amigável callbacks repetidos de desbloqueio.
- O catálogo de criadores e o feed não priorizam perfis monetizados.
- A proteção atual esconde o conteúdo na aplicação, mas não constitui uma camada completa de mídia privada com URLs temporárias. Isso é insuficiente para conteúdo premium em produção.
- Cupons e descontos precisam de uma auditoria contábil em todos os gateways para garantir que valor cobrado, comissão e crédito do criador sejam sempre idênticos.
- A verificação genérica do Sngine não cobre, sozinha, identidade, maioridade, consentimento, documentação de participantes e gestão de chargeback.

## Melhorias aplicadas

- Remoção do tema paralelo `thesex` e retorno automático ao tema `default` caso o tema removido ainda esteja selecionado no banco ou cookie.
- Camada revisada de português brasileiro para o fluxo de monetização e conteúdo adulto.
- Correção da regra que habilita publicações pagas.
- Bloqueio da combinação “assinantes somente” com “publicação paga” na mesma publicação.
- Desconto geral respeitado somente quando realmente ativado.
- Validação da elegibilidade do criador no momento da assinatura.
- Bloqueio de compra ou assinatura do próprio conteúdo.
- Desbloqueio de publicação tolerante a callback repetido.
- Checklist de ativação para administrador e criador.
- Nova apresentação nativa para conteúdo exclusivo e publicação paga, sem trocar de tema.

## Add-ons recomendados

### Prioridade crítica

1. **Onboarding e verificação de criadores** — identidade, maioridade, selfie/documento, status de revisão, expiração e trilha de auditoria.
2. **Consentimento de participantes** — cadastro de coautores/modelos, documento de consentimento por conteúdo e processo de retirada.
3. **Mídia privada** — armazenamento fora da pasta pública, URLs assinadas com expiração, autorização por assinatura/compra, watermark por usuário e prevenção de hotlink.
4. **Moderação adulta** — fila de revisão, denúncias, takedown, hash de arquivos bloqueados, bloqueio emergencial e histórico de decisões.
5. **Livro-caixa de pagamentos** — transações imutáveis, reembolso, chargeback, reserva de saldo, conciliação e idempotência por gateway.

### Prioridade de produto

6. **Descoberta de criadores** — ranking, novos perfis, categorias, cidade/região opcional, faixa de preço, online agora e perfis verificados.
7. **Feed de assinaturas** — abas “Seguindo”, “Exclusivos”, “Novos” e “Em alta”, com recomendação separada do feed social genérico.
8. **Planos aprimorados** — níveis, benefícios, teste promocional, bundles, metas, pausa, presente de assinatura e recuperação de assinantes cancelados.
9. **PPV por mensagem** — mídia bloqueada no chat, campanha segmentada e limite contra spam.
10. **Painel do criador** — receita líquida, conversão de perfil, churn, posts mais rentáveis, origem das assinaturas e calendário de publicação.
11. **Classificados separados** — perfis por região e filtros próprios, sem misturar a regra de assinatura com a regra de anúncio. Exige política jurídica e de segurança específica por localidade.
12. **Lives premium** — ingresso, acesso para assinantes, gorjetas em tempo real e replay pago.

## Ordem sugerida

1. Estabilizar ativação, tradução e testes de pagamento.
2. Implementar mídia privada, verificação e moderação.
3. Criar descoberta de criadores e feed dedicado usando os dados nativos.
4. Adicionar classificados como módulo independente.
5. Evoluir mensagens PPV, lives e analytics.

Não é recomendável abrir a plataforma adulta ao público antes dos itens críticos de identidade, consentimento, mídia privada, moderação e pagamentos estarem concluídos.
