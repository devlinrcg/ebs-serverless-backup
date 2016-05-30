# Backup de Instâncias Amazon EC2 via EBS snapshot
###### Funcionamento
* Cada diretório neste repositório representa **UMA** Região AWS. Assim, os templates podem ser lançados em **QUALQUER** Região que tenha o AWS Lambda disponível (Virginia, por exemplo), e executar a função na região de sua escolha;
* Cada diretório contém um template, 2 scripts e um script zip_all.sh;
* Para cada edição feita nos scripts, você deve executar o zip_all.sh daquele diretório;
* O template do AWS Cloudformation cria, automaticamente, a role e a policy para execução dos das funções no AWS Lambda;  

###### Uso
* Acesse a console de sua conta AWS e vá até a console de gerenciamento do [Amazon S3](https://console.aws.amazon.com/s3/);
* Crie um Bucket e clique para acessá-lo;
* Faça o upload dos arquivos **ebs-backup-lambda.zip** e **ebs-backup-lambda.template** da Região de sua escolha para seu Bucket Amazon S3 criado no item anterior;
* Copie o link do arquivo, ex: https://s3.amazonaws.com/SEU_BUCKET/ec2-startstop.template
* Agora, vá até a console de gerenciamento do [AWS Cloudformation](https://console.aws.amazon.com/cloudformation/);
* Clique em **Create Stack**;
* No campo **Specify an Amazon S3 template URL**, cole/insira o link que você copiou do template, e clique em next;
* Preencha os campos necessários: em nome do Bucket Amazon S3, coloque o nome do Bucket criado nos passos anteriores. Em tópico SNS, insira um nome para o tópico do AWS Push Notification Service, que será utilizado para receber alertas em caso de erro na execução dos scripts;
* Vá passando pelas opções até lançar o Stack;
* Assim que lançado, os recursos serão criados automaticamente;
* Após terminado o processo, vá até a console de gerenciamento do AWS SNS e se inscreva no tópico criado, para receber os alertas;
* Repita estes passos para outras funções de Regiões diferentes;

##### Agendamento:
Para agendamento da função no horário que quiser, após lançar os Stacks desejados, coloque um Event Source em cada Função AWS Lambda, conforme abaixo:
* Acesse a console de gerenciamento do [AWS Lambda](https://console.aws.amazon.com/lambda);
* Clique na função desejada;
* Clique na aba **Event sources**;
* Clique em **Add event source**;
* Nesta tela, preencha:
    * Event source type: **Cloudwatch Events - Schedule**;
    * Rule name: um nome para a regra, que você possa lembrar;
    * Rule description: uma descrição para regra;
    * Schedule expression: siga os exemplos de  expressão abaixo.
    * Clique em **Submit** e pronto, está agendado;
    * Repita estes passos para as outras funções;  

Obs: como referência, coloque horários diferentes do Backup e do Janitor, para que não coincidam;  

###### Exemplos de Expressões para agendamento
As expressões são do cron (Linux), e seguem a hora UTC (+3BRT). Abaixo seguem alguns exemplos:

* Executado às 17:00 (BRT) de segunda à sexta:
```
cron(0 20 ? * MON-FRI * )
```
* Executado às 08:00 (BRT) de segunda à sexta:
```
cron(0 11 ? * MON-FRI * )
```  

##### Para que Backup seja feito:
- Em cada instância EC2 que você precisa do Backup, coloque a Tag "Backup" ou "backup" (sem aspas); não precisa colocar nenhum valor na Tag.
- Em cada instância EC2 que você precisa de uma retenção, coloque a Tag "Retention" ou "retention" (sem as aspas), com o valor em DIAS (ex: para retenção de 7 dias, coloque 7); você pode colocar múltiplas retenções.
	- Caso não seja inserida a tag Retention com a quantidade de dias a fazer a retenção, serão considerados 7 dias.

##### Estrutura dos Dados:

###### Arquivos
```
ebs-serverless-backup
├── California
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Frankfurt
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Ireland
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Oregon
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── README.md
├── SaoPaulo
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Seoul
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Singapore
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Sydney
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
├── Tokyo
│   ├── ebs-backup-lambda.template
│   ├── ebs-backup-lambda.zip
│   ├── ebs_snapshot_function.py
│   ├── janitor_function.py
│   └── zip_all.sh
└── Virginia
    ├── ebs-backup-lambda.template
    ├── ebs-backup-lambda.zip
    ├── ebs_snapshot_function.py
    ├── janitor_function.py
    └── zip_all.sh
```
