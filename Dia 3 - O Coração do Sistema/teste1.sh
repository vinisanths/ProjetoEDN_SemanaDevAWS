curl -X POST https://x3ymh2e4pb.execute-api.us-east-1.amazonaws.com/dev/pedidos \
  -H "Content-Type: application/json" \
  -d '{
    "pedidoId": "apiP001-Vinicius",
    "clienteId": "clienteXYZ-ViniiusSantos",
    "itens": [
      {
        "Item": "Produto X API",
        "qtd": 1
      }
    ]
  }'