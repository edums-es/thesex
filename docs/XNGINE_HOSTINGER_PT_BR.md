# Xngine 1.6.2 no Sngine 4.4.2 e recuperação de uploads

## O que foi instalado

O tema completo está em `content/themes/xngine`. Ele mantém o layout original do Xngine, recebe os diretórios de Criadores e Acompanhantes e continua usando o núcleo do Sngine 4.4.2.

O tema foi isolado do `default`. Assim, uma falha de template pode ser revertida sem apagar o tema padrão.

## Segurança aplicada

O pacote da comunidade continha um atualizador que enviava o domínio e um código de compra para um servidor externo e aceitava uma URL remota de arquivo ZIP. Esse painel foi removido e substituído pelo gerenciador de temas nativo do Sngine 4.4.2.

Também foi removido um manipulador duplicado de mensagens e solicitações que executava uma resposta do servidor e concorria com o JavaScript atual do Sngine. O retorno do CCBill foi atualizado para o template da versão 4.4.2.

## Ativação na Hostinger

1. Faça backup dos arquivos e do banco antes do deploy.
2. Publique o repositório na pasta já usada pelo site, sem apagar `content/uploads`.
3. Confirme que existe `public_html/content/themes/xngine/version.json`.
4. No painel administrativo do Sngine, abra **Design > Themes** e clique em **Add New Theme**.
5. Preencha o nome exatamente como `xngine`, marque **Default** e **Selectable**, e salve.
6. Apague apenas arquivos compilados antigos dentro de `content/themes/xngine/templates_compiled`, preservando `index.html`.
7. Limpe o cache da Hostinger e faça um recarregamento completo no navegador.

Para voltar, edite o tema `default`, marque-o como padrão e salve. Não apague `xngine` antes de concluir o retorno.

## Por que as fotos sumiram

O banco ainda aponta para arquivos como:

`content/uploads/photos/2026/08/sngine_9ee2cd426cdfcf920baa755267a97390.jpg`

O servidor responde 404 para esses endereços, enquanto bandeiras, reações e imagens padrão abrem normalmente. A pasta `content/uploads/photos/2026/08` também não existe no projeto local. Portanto, os registros de foto permaneceram no banco, mas os arquivos físicos não estão mais no servidor.

Tema ou CSS não consegue restaurar um arquivo removido.

## Recuperação sem perder o código novo

1. No hPanel, abra **Sites > Gerenciar > Backups > Restaurar e baixar**.
2. Baixe um backup de arquivos criado antes de as fotos desaparecerem.
3. Extraia o backup em uma pasta temporária; não restaure todo o `public_html` por cima do site atual.
4. Copie do backup apenas `domains/thesex.online/public_html/content/uploads/photos/2026/08` para o mesmo caminho no site atual.
5. Se também faltarem vídeos ou áudios, recupere da mesma forma as pastas correspondentes em `content/uploads`.
6. No hPanel, execute **Fix File Ownership** se os arquivos existirem mas continuarem inacessíveis.
7. Verifique uma das URLs exatas no navegador. Ela precisa abrir a imagem, e não a página “This Page Does Not Exist”.

Não é necessário restaurar o banco enquanto os posts e perfis ainda aparecem. Restaurar o banco poderia desfazer usuários e publicações recentes.

## Regra para próximos deploys

Uploads de usuários não pertencem ao Git e agora estão explicitamente ignorados. Mantenha um backup separado de `content/uploads` e nunca use uma publicação que recrie `public_html` ou copie arquivos com opção de exclusão sobre essa pasta.
