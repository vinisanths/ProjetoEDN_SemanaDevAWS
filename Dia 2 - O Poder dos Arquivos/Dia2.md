# Laboratório: Arquitetura de Processamento de Pedidos e Arquivos na AWS

Este repositório documenta a arquitetura serverless construída durante a **Semana do Desenvolvedor AWS** da **Escola da Nuvem**. O projeto implementa um sistema de ponta a ponta para a ingestão de pedidos a partir de duas fontes distintas: uma API em tempo real e o processamento de arquivos em lote.

## 🚀 Dia 1: Ingestão de Pedidos via API (Resumo)

A base do projeto, construída no Dia 1, consiste em um fluxo de ingestão de pedidos via API.
- **Fluxo**: `API Gateway (Endpoint REST)` -> `AWS Lambda (Pré-Validação)` -> `Amazon SQS (Fila FIFO)` -> `AWS Lambda (Validação)` -> `Amazon EventBridge (Barramento de Eventos)`
- **Objetivo**: Prover um endpoint para receber pedidos em tempo real, validá-los e publicá-los em um barramento de eventos de forma desacoplada e ordenada. 

---

## 🚀 Dia 2: Ingestão de Arquivos via S3, Rastreamento e Integração

Nesta segunda etapa, o projeto foi expandido para suportar uma nova forma de ingestão de pedidos através do upload de arquivos JSON, integrando-a ao fluxo principal. Adicionalmente, foram implementados mecanismos de rastreamento e notificação de erros. 

### Arquitetura e Fluxo de Dados (Dia 2)

O novo fluxo de processamento de arquivos opera da seguinte forma:

1.  **Upload do Arquivo**: Um parceiro ou sistema externo carrega um arquivo `.json` com um ou mais pedidos em um bucket **Amazon S3**. 
2.  **Notificação de Evento**: O S3 detecta a criação do objeto e envia uma notificação de evento para uma fila **SQS Standard**. Esta fila serve como um buffer para desacoplar a notificação do processamento. 
3.  **Processamento Inteligente**: Uma função **AWS Lambda** (`validacao-s3-arquivos-lambda`) é acionada pela mensagem na fila SQS e executa a lógica principal:
    a.  **Leitura**: A Lambda faz o download do arquivo do S3 usando as informações da mensagem.
    b.  **Rastreamento**: A Lambda grava um registro na tabela do **Amazon DynamoDB**, iniciando o rastreamento com o `nomeArquivo` como chave de partição. 
    c.  **Validação**: O conteúdo do arquivo JSON é validado.
    d.  **Tratamento de Erro**: Se o arquivo for inválido, o status no DynamoDB é atualizado para `ERRO_VALIDACAO_ARQUIVO`  e uma notificação é publicada em um tópico do **Amazon SNS**, que por sua vez envia um alerta por e-mail. 
    e.  **Sucesso e Integração**: Se o arquivo for válido, o status no DynamoDB é atualizado para `ARQUIVO_VALIDADO`.  A Lambda então extrai cada pedido individual do arquivo e envia-os como mensagens separadas para a **fila SQS FIFO** (`pedidos-fifo-queue-seu-nome.fifo`) criada no Dia 1, unificando os dois fluxos de ingestão.

### Configurações Chave

-   **Amazon S3 (`datalake-arquivos-seu-nome`)**
    -   **Event Notification**: Configurada para disparar em `All object create events` e com filtro de sufixo `.json`.
-   **Amazon SQS (`s3-arquivos-json-queue-seu-nome`)**
    -   **Tipo**: Standard. 
    -   **Visibility Timeout**: Definido para `70 segundos`, um valor maior que o timeout da Lambda de processamento para evitar reprocessamentos acidentais. 
-   **AWS Lambda (`validacao-s3-arquivos-lambda-seu-nome`)**
    -   **Runtime**: Python 3.12.
    -   **Timeout**: `1 minuto` para permitir o download e processamento de arquivos. 
    -   **Trigger**: Configurado para a fila SQS `s3-arquivos-json-queue-seu-nome` com `Batch size: 1`. 
    -   **Variáveis de Ambiente**:
        ```
        - DYNAMODB_TABLE_NAME: controle-arquivos-historico-seu-nome 
        - SNS_TOPIC_ARN: <O ARN do seu tópico SNS 'notificacao-erro-arquivos-seu-nome'> 
        - SQS_FIFO_PEDIDOS_URL: <A URL da sua fila FIFO 'pedidos-fifo-queue-seu-nome.fifo' criada na Aula 1> 
        ```
-   **Amazon DynamoDB (`controle-arquivos-historico-seu-nome`)**
    -   **Chave de Partição**: `nomeArquivo` (String).

### Permissões (IAM Role: `lambda-s3-validation-role-seu-nome`)

A role de execução da Lambda precisa das seguintes permissões para interagir com os outros serviços:

-   `AWSLambdaBasicExecutionRole`: Para escrever logs no CloudWatch.
-   `s3:GetObject`: Para ler e fazer o download do arquivo do bucket S3.
-   `dynamodb:PutItem`: Para gravar e atualizar o histórico de validação na tabela DynamoDB.
-   `sns:Publish`: Para enviar notificações de erro para o tópico SNS.
-   `sqs:SendMessage`: **Permissão crítica** para enviar os pedidos extraídos para a fila SQS FIFO principal do Dia 1.
-   `sqs:ReceiveMessage`, `sqs:DeleteMessage`, `sqs:GetQueueAttributes`: Para permitir que a Lambda seja acionada pela fila SQS de arquivos e gerencie as mensagens recebidas. 623, 

### ⚠️ Ponto de Atenção: Permissões S3 -> SQS

Ao configurar a notificação de eventos do S3 para a fila SQS, pode ocorrer o erro `Unable to validate the following destination configurations`. Isso geralmente acontece por falta de permissão para o serviço S3 enviar mensagens para a fila SQS.

**Solução**: É necessário adicionar manualmente uma política de acesso à fila SQS (`s3-arquivos-json-queue-seu-nome`).

1.  Acesse a fila no console SQS.
2.  Vá para a aba "Access policy" e clique em "Edit".
3.  Use o JSON abaixo, substituindo os placeholders pelo ARN do seu bucket e o ID da sua conta AWS:

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Action": "SQS:SendMessage",
      "Resource": "COLE AQUI O ARN DA SUA FILA s3-arquivos-json-queue-seu-nome",
      "Condition": {
        "ArnLike": {
          "aws:SourceArn": "COLE AQUI O ARN DO SEU BUCKET datalake-arquivos-seu-nome"
        },
        "StringEquals": {
          "aws:SourceAccount": "COLE AQUI O ID DA SUA CONTA"
        }
      }
    
}
```
### Testando o Fluxo (Dia 2)

O teste deste fluxo é dividido em dois cenários:

1.  **Cenário de Sucesso**:
    -   Faça o upload do arquivo `arquivo_com_pedidos.json` para o bucket S3. 
    -   **Resultado Esperado**: Um item será criado na tabela do DynamoDB com `statusValidacao: "ARQUIVO_VALIDADO"` , e duas novas mensagens (pedidos) aparecerão na fila `pedidos-fifo-queue-seu-nome.fifo`. 

2.  **Cenário de Falha**:
    -   Faça o upload do arquivo `arquivo_schema_invalido.json` para o bucket S3. 
    -   **Resultado Esperado**: Um item será criado no DynamoDB com `statusValidacao: "ERRO_VALIDACAO_ARQUIVO"` , um e-mail de notificação será enviado via SNS , e nenhuma nova mensagem será adicionada à fila `pedidos-fifo-queue-seu-nome.fifo`.