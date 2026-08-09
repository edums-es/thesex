# Xngine sanitizado para o The Sex

Esta cópia mantém os templates e os estilos visuais do Xngine 1.6.2, originalmente declarado para Sngine 4.4.1, e foi adaptada para o Sngine 4.4.2.

## Alterações de segurança e compatibilidade

- O painel de temas foi substituído pela versão nativa do Sngine 4.4.2.
- O atualizador remoto que enviava domínio e código de compra para `k97.in` foi removido.
- O manipulador duplicado de mensagens/solicitações, que executava código devolvido pelo servidor e podia duplicar eventos do núcleo, foi removido.
- Nenhum arquivo PHP, executável ou atualizador remoto do pacote da comunidade foi incorporado.
- O changelog e a tela de monetização administrativa usam os templates atuais do projeto.
- O tema padrão permanece instalado como opção de retorno.

## Recursos do projeto incorporados

- diretórios `/creators` e `/acompanhantes`;
- botões de acesso rápido para Criadores e Acompanhantes;
- bloqueios visuais para conteúdo pago e exclusivo;
- roteiro visual de ativação da monetização;
- estilos responsivos para desktop e celular.
