## 🚀 Dia 3: Processamento Central de Pedidos e Persistência

Esta é a etapa final do projeto, onde a lógica de negócio central é executada. Este fluxo consome os eventos de pedidos validados, gerados pelos fluxos dos Dias 1 e 2, processa-os e os persiste em um banco de dados final.

### Arquitetura e Fluxo de Dados (Dia 3)

O fluxo de processamento central é totalmente orientado a eventos e funciona da seguinte maneira:

1.  **Captura do Evento**: Uma **Regra do Amazon EventBridge** (`novo-pedido-validado-rule-seu-nome`) é configurada no barramento de eventos customizado (`pedidos-event-bus-seu-nome`). Ela filtra eventos com o seguinte padrão:
    ```json
    {
      "source": ["lab.aula1.pedidos.validacao"],
      "detail-type": ["NovoPedidoValidado"]
    }
    ```
2.  **Enfileiramento**: A regra envia os eventos correspondentes como mensagens para uma fila **SQS Standard** (`pedidos-pendentes-queue-seu-nome`), que atua como um buffer de processamento.
3.  **Processamento e Persistência**: Uma função **AWS Lambda** (`processa-pedidos-lambda-seu-nome`) é acionada pela fila SQS. Ela executa as seguintes ações:
    -   Consome a mensagem contendo os detalhes do pedido validado.
    -   Simula a lógica de negócio (ex: verificação de inventário, etc.).
    -   Grava o item final em uma tabela **Amazon DynamoDB** (`pedidos-db-seu-nome`), usando o `pedidoId` como chave de partição e definindo o `statusPedido` como `PEDIDO_PROCESSADO`.

### Novos Recursos Criados (Dia 3)

-   **IAM Role**: `lambda-processa-pedidos-role-seu-nome` 
-   **Amazon SQS (Standard)**: Fila `pedidos-pendentes-queue-seu-nome` e sua DLQ. 
-   **Amazon DynamoDB Table**: `pedidos-db-seu-nome` (Chave de Partição: `pedidoId`) 
-   **AWS Lambda**: Função `processa-pedidos-lambda-seu-nome` 
-   **Amazon EventBridge Rule**: `novo-pedido-validado-rule-seu-nome` 

### Testando o Fluxo de Ponta a Ponta

Para testar o sistema completo, você pode iniciar um pedido em qualquer uma das duas pontas (API ou S3) e observar o resultado final no DynamoDB.

1.  **Inicie um Pedido**:
    -   **Via API**: Envie uma requisição `POST` para o seu endpoint da API Gateway com um novo `pedidoId` (ex: `apiP001-seu-nome`).
    -   **Via S3**: Faça o upload de um novo arquivo JSON de pedidos (ex: `outro_arquivo_pedidos.json`) para o seu bucket S3.

2.  **Verifique o Resultado Final**:
    -   Acesse o serviço **Amazon DynamoDB**.
    -   Selecione a tabela `pedidos-db-seu-nome` e clique em "Explore table items".
    -   **Resultado Esperado**: Você deve encontrar itens na tabela correspondentes aos `pedidoId` que você enviou. Cada item deve ter um atributo `statusPedido` com o valor `PEDIDO_PROCESSADO` e um atributo `origem` indicando se veio da `API` ou `S3_FILE`, confirmando que todo o pipeline, desde a ingestão até a persistência, funcionou com sucesso. 