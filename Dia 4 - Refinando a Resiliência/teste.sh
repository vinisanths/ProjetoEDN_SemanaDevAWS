curl -X POST <INVOKE_URL>/pedidos \
  -H "Content-Type: application/json" \
  -d '{
    "pedidoId": "apiP001-seu-nome",
    "clienteId": "clienteXYZ-seu-nome",
    "itens": [
      {
        "Item": "Produto X API",
        "qtd": 1
      }
    ]
  }'