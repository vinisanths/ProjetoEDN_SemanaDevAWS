curl -X POST Sua Requisição/dev/pedidos \
  -H "Content-Type: application/json" \
  -d '{
    "pedidoId": "lab001-Vinicus",
    "clienteId": "clienteABC-Vinicius",
    "itens": [
      {
        "produto": "Curso AWS",
        "quantidade": 10
      },
      {
        "produto": "Estojo UniversitÃ¡rio",
        "quantidade": 2
      }
    ]
  }'
