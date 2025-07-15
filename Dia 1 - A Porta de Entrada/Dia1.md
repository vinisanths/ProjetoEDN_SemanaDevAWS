# Laboratório 1: Arquitetura de Ingestão de Pedidos com API Gateway e EventBridge

Este repositório contém a documentação e os aprendizados do primeiro laboratório da **Semana do Desenvolvedor AWS**, promovida pela **Escola da Nuvem**. 

## 🎯 Visão Geral

O objetivo deste projeto é construir um fluxo serverless para a ingestão e processamento inicial de pedidos na AWS. A arquitetura é projetada para ser escalável, resiliente e orientada a eventos, utilizando serviços gerenciados para minimizar a sobrecarga operacional.

## 🏗️ Arquitetura

O fluxo de dados segue a seguinte sequência:

`API Gateway (Endpoint REST)` -> `AWS Lambda (Pré-Validação)` -> `Amazon SQS (Fila FIFO)` -> `AWS Lambda (Validação)` -> `Amazon EventBridge (Barramento de Eventos)`

### Recursos Criados na AWS:
* **IAM Roles:** `lambda-prevalidacao-role` e `lambda-validacao-pedidos-role`. 
* **Amazon SQS FIFO:** Fila `pedidos-fifo-queue` e sua respectiva Dead-Letter Queue (DLQ).
* **AWS Lambda:** Funções `pre-validacao-lambda` e `validacao-pedidos-lambda`. 
* **Amazon API Gateway:** Uma API REST (`pedidos-api`) com um recurso `/pedidos` e método POST. 
* **Amazon EventBridge:** Um barramento de eventos customizado (`pedidos-event-bus`). 

## 🚀 Como Usar

Para replicar este laboratório, você precisará configurar os serviços na AWS conforme descrito no guia da aula. Os passos principais são:

1.  **Configurar Permissões no IAM:** Criar as roles para as funções Lambda com as políticas necessárias (`AWSLambdaBasicExecutionRole`, permissão para enviar mensagens ao SQS e para publicar eventos no EventBridge). 
2.  **Criar Filas SQS FIFO:** Configurar a fila principal e a DLQ para garantir o processamento ordenado e o tratamento de falhas. 
3.  **Implementar as Funções Lambda:** Criar as duas funções em Python, adicionar o código-fonte e configurar as variáveis de ambiente (`SQS_QUEUE_URL` e `EVENT_BUS_NAME`). 
4.  **Expor a API com API Gateway:** Criar a API REST, o recurso `/pedidos` e integrá-lo com a função `pre-validacao-lambda`. 
5.  **Configurar o EventBridge:** Criar o barramento de eventos que receberá as notificações dos pedidos validados. 
6.  **Adicionar Triggers:** Configurar o gatilho da API Gateway para a primeira Lambda e o gatilho do SQS para a segunda Lambda. 

## 🧪 Testando o Fluxo

Após o deploy, você pode testar o endpoint utilizando um cliente HTTP como o `curl`:

```bash
curl -X POST <SUA_INVOKE_URL>/pedidos \
-H "Content-Type: application/json" \
-d '{
  "pedidoId": "lab-teste-01",
  "clienteId": "cliente-xyz-01",
  "itens": [
    {"produto": "Caneta Azul", "quantidade": 10},
    {"produto": "Caderno Universitário", "quantidade": 2}
  ]
}'
```

Uma resposta de sucesso indicará que o pedido foi recebido e enfileirado para processamento.

## 🤝 Contribuição
Pull requests são bem-vindos. Para mudanças importantes, por favor, abra uma issue para discutir o que você gostaria de mudar.

📄 Licença
MIT