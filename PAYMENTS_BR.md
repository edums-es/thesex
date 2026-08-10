# Stone/Pagar.me e Woovi/OpenPix

Integração de checkout hospedado para o Sngine 4.4.2. Os dados de cartão não passam pelo site e nenhuma compra é liberada pelo retorno do navegador. A confirmação ocorre somente por webhook verificado e fica registrada em `br_payment_transactions` para impedir processamento duplicado.

## Configuração no Sngine

1. Confirme em **Administração → Configurações → Pagamentos** que a moeda padrão é `BRL`.
2. Na mesma tela, configure primeiro o ambiente de testes.
3. Para Pagar.me, informe a Secret Key de teste, marque cartão/Pix/boleto conforme a conta e salve.
4. Copie a URL de webhook gerada depois do primeiro salvamento e cadastre-a no painel Pagar.me.
5. Para Woovi, informe o AppID do sandbox e salve.
6. Cadastre `https://SEU-DOMINIO/webhooks/woovi.php` na Woovi para o evento `OPENPIX:CHARGE_COMPLETED`.

As credenciais existentes nunca são exibidas. Deixar o campo de segredo em branco preserva o valor já configurado.

## Eventos

Pagar.me:

- `order.paid`
- `order.payment_failed`
- `charge.refunded`
- `chargeback.received`
- `checkout.canceled`

Woovi:

- `OPENPIX:CHARGE_COMPLETED`

O webhook Pagar.me possui um segredo aleatório na URL e consulta novamente o pedido pela API autenticada antes de liberar a compra. O webhook Woovi valida `x-webhook-signature` com RSA SHA-256 e também consulta novamente a cobrança pelo AppID.

## Testes antes da produção

- Criar uma compra de cada tipo utilizado: pacote, carteira, doação, assinatura, post pago, filme e marketplace.
- Confirmar que pagamento pendente não libera conteúdo ou saldo.
- Confirmar que um pagamento aprovado libera exatamente uma vez, mesmo reenviando o webhook.
- Testar cartão aprovado e recusado no Pagar.me e Pix concluído no sandbox Woovi.
- Conferir imposto e taxa de pagamento, pois o gateway recebe o total e o produto recebe apenas o valor-base.
- Conferir `log_payments`, carteira, assinatura/post desbloqueado e `br_payment_transactions`.
- Somente depois trocar ambiente e credenciais para produção.

## Requisitos

- PHP com cURL, OpenSSL e MySQLi.
- HTTPS válido no domínio.
- Chaves de produção compatíveis com o ambiente selecionado.
- Conta aprovada pelos provedores para o modelo de negócio da plataforma.

## Aprovação comercial obrigatória

Antes de produção, descreva por escrito aos dois provedores que a plataforma é uma rede social adulta com assinaturas e venda de conteúdo digital e obtenha a aprovação comercial desse enquadramento. O contrato Pagar.me exige que as transações correspondam à atividade declarada no cadastro, e os termos Woovi permitem suspensão por descumprimento das políticas. A integração usa descrições neutras para preservar a privacidade do comprador, mas isso não substitui a declaração correta do negócio ao provedor.

Documentação oficial usada:

- Pagar.me Checkout V5: https://docs.pagar.me/reference/criar-link
- Pagar.me autenticação: https://docs.pagar.me/reference/autentica%C3%A7%C3%A3o-2
- Pagar.me eventos: https://docs.pagar.me/reference/eventos-de-webhook-1
- Woovi/OpenPix API: https://developers.openpix.com.br/api
- Woovi assinatura de webhook: https://developers.woovi.com/en/docs/webhook/seguranca/webhook-signature-validation
