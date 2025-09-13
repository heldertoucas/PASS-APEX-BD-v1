# **Guia de Criação: Passaporte Competências Digitais em Oracle APEX**

## Passo 1: Preparar o Ambiente e a Base de Dados

Olá\! Bem-vindo ao início da jornada para dar vida à sua aplicação. Nesta primeira fase, vamos criar e configurar a infraestrutura fundamental na Oracle Cloud. Pense nisto como adquirir o terreno e construir as fundações da sua casa. No final deste passo, terá uma base de dados robusta e um ambiente de desenvolvimento prontos para começar a criar as funcionalidades da aplicação.

### 1.1. Criar a sua Conta Gratuita na Oracle Cloud (Free Tier)

A Oracle oferece um nível de serviço "Sempre Gratuito" (Always Free) que é perfeito para desenvolver e até mesmo hospedar esta aplicação sem custos.

1. Aceda ao site: Abra o seu navegador e vá para [https://www.oracle.com/pt/cloud/free/](https://www.oracle.com/pt/cloud/free/).  
2. Inicie o registo: Clique no botão "Sign up" ou "Comece gratuitamente".  
3. Preencha os seus dados: Terá de fornecer um endereço de e-mail, país, nome e apelido. Irá também criar uma palavra-passe para a sua conta Cloud.  
4. Verificação e detalhes da conta: Siga os passos de verificação por e-mail. Terá de fornecer mais alguns detalhes e, por fim, adicionar um cartão de crédito. Não se preocupe, o cartão é apenas para verificação de identidade e para o caso de querer fazer um upgrade para serviços pagos no futuro. Não será cobrado nada pelos serviços "Always Free".  
5. Conclusão: Após a confirmação, a sua conta Oracle Cloud será provisionada. Pode demorar alguns minutos. Receberá um e-mail quando tudo estiver pronto.

### 1.2. Criar a sua Base de Dados Autónoma (Autonomous Database)

Agora que tem a sua conta, vamos criar a base de dados que irá armazenar toda a informação do Passaporte Digital.

1. Aceda ao painel de controlo: Faça login na sua conta em [cloud.oracle.com](https://cloud.oracle.com/).  
2. Navegue para a Autonomous Database: No menu principal (geralmente no canto superior esquerdo, com um ícone de três linhas), procure por "Oracle Database" e selecione "Autonomous Transaction Processing".  
3. Crie a base de dados: Clique no botão "Create Autonomous Database".  
4. Configure a base de dados:  
   * Choose a workload type: Selecione "Transaction Processing".  
   * Choose a deployment type: Selecione "Shared Infrastructure".  
   * Always Free: Este é o passo mais importante. Certifique-se de que a opção "Always Free" está ativada. Isto garante que não terá custos.  
   * Create administrator credentials: Defina uma palavra-passe para o utilizador administrador da base de dados (o utilizador chama-se ADMIN). Guarde esta palavra-passe num local seguro\!  
   * Network access: Deixe a opção padrão selecionada.  
5. Finalize a criação: Clique em "Create Autonomous Database" no final da página. A base de dados começará a ser provisionada (pode ficar com o estado "Provisioning" a laranja). Aguarde até que fique verde e com o estado "Available". Isto pode levar alguns minutos.

### 1.3. Criar o seu Ambiente de Desenvolvimento (Workspace APEX)

Com a base de dados pronta, vamos criar o espaço de trabalho onde irá efetivamente construir a sua aplicação.

1. Aceda às ferramentas da base de dados: Na página da sua base de dados recém-criada, clique no separador "Database Actions".  
2. Inicie o APEX: Na secção "Development", clique no cartão "APEX".  
3. Crie o Workspace: Será levado para uma página de login do APEX. Clique em "Create Workspace".  
4. Associe a base de dados:  
   * Selecione "New Schema".  
   * Workspace Name: Dê um nome ao seu ambiente, por exemplo, PASSAPORTE\_DIGITAL.  
   * Username: Crie um nome de utilizador para si, que será o administrador deste Workspace (pode ser o seu nome ou e-mail).  
   * Password: Crie uma palavra-passe forte para aceder ao seu ambiente de desenvolvimento APEX.  
   * Advanced \> Schema Name: Para manter tudo organizado, pode dar um nome específico ao *schema* da base de dados que será criado, como PASSAPORTE\_APP. Se deixar em branco, será igual ao nome do Workspace.  
5. Conclua a criação: Clique em "Create Workspace".

Após alguns instantes, o seu Workspace estará criado. Faça login com o utilizador e a palavra-passe que acabou de definir.

Parabéns\! Concluiu a fase mais técnica de todo o processo. Neste momento, tem uma fundação sólida:

* Uma conta na Oracle Cloud.  
* Uma base de dados autónoma, segura e gerida pela Oracle.  
* Um ambiente de desenvolvimento APEX pronto a ser usado.
