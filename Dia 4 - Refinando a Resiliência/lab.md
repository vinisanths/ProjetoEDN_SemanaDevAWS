## 🚀 Dia 4: Fluxos Adicionais, DLQs e Conclusão

A última etapa do projeto focou em adicionar funcionalidades para o ciclo de vida completo do pedido (cancelamento e alteração) e em validar a estratégia de tratamento de erros com Dead Letter Queues (DLQs). 

### Arquitetura (Dia 4): Cancelamento e Alteração

Os novos fluxos seguem o padrão orientado a eventos estabelecido anteriormente:

1.  **Disparo do Evento**: Um evento de `Cancelar Pedido` ou `Alterar Pedido` é enviado para o barramento `pedidos-event-bus-seu-nome`.  A origem (`source`) para esses eventos é `lab.aula4.operacoes`. 
2.  **Roteamento por Regra**: Regras específicas no EventBridge (`cancela-pedido-rule` e `altera-pedido-rule`) capturam os eventos baseados no `detail-type` e os direcionam para filas SQS dedicadas. 
3.  **Execução da Lógica**: Cada fila SQS aciona uma Lambda específica (`cancela-pedido-lambda` ou `altera-pedido-lambda`) que executa a lógica de negócio para atualizar o item correspondente na tabela DynamoDB `pedidos-db-seu-nome`. 

### Teste de Resiliência: Dead Letter Queues (DLQs)

Para garantir a robustez do sistema, foi realizado um teste prático de DLQ:
1.  Foi injetado um erro de forma proposital no código da `processa-pedidos-lambda-seu-nome` (ex: `raise ValueError`). 
2.  Um novo pedido foi enviado pelo fluxo normal (via API). 
3.  Observou-se que, após o número configurado de tentativas falhas, a mensagem foi automaticamente movida para a fila DLQ `pedidos-pendentes-dlq-seu-nome`. 
4.  **Importante**: Após o teste, o erro foi removido do código da Lambda para restaurar a funcionalidade normal. 

---

## ✅ Conclusão Geral e Arquitetura Final

Ao longo dos quatro dias, construímos uma arquitetura serverless completa, desacoplada e orientada a eventos. O sistema é capaz de ingerir dados de múltiplas fontes (API e S3), validar, processar e persistir pedidos, além de gerenciar operações de alteração e cancelamento. 
## Arquitetura Final
![Arquitetura Final](https://imgur.com/1Kd3eZ6.png)


### Agradecimentos

Projeto desenvolvido durante a **Semana do Desenvolvedor AWS** da **Escola da Nuvem**, sob a orientação e instrução de **[José de ALmino Junior]([text](https://www.linkedin.com/in/jos%C3%A9-almino/))**.