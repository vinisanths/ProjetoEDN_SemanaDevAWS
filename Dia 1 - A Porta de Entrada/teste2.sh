curl -X POST https:// Sua requisição /dev/pedidos\
-H "Content-Type: application/json" \
-d '{
    "pedidoId": "lab001-Vincius",
    "clienteId": "clienteABC-Vinicius",
    "itens": [
        {"produto": "Borracha Branca", "quantidade": 5}
]
}'

