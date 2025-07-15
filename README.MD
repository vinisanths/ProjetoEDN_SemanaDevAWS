# 🚀 Semana do Desenvolvedor AWS: Arquitetura de Eventos em Ação! 🚀

![Demonstração da Arquitetura do Projeto](https://i.imgur.com/Uv3gV5h.png)
_Uma espiada na poderosa arquitetura que construímos juntos!_

---

## 🎯 Visão Geral do Desafio

Bem-vindo ao repositório do projeto da **Semana do Desenvolvedor AWS** um evento 100% prático da **Escola da Nuvem**.
 O nosso grande objetivo? Construir do zero uma **arquitetura orientada a eventos** na nuvem da AWS, capaz de processar pedidos de forma inteligente e escalável.

Esta solução foi desenhada para lidar com duas frentes de trabalho:
* **Pedidos em Tempo Real** ⚡: Recebidos via uma API REST.
* **Pedidos em Lote** 📂: Processados a partir de arquivos JSON enviados para o Amazon S3.

O resultado é um sistema moderno, **desacoplado, resiliente e escalável**, que usa o melhor dos serviços da AWS de forma integrada.

---

## 🛠️ As Ferramentas do Nosso Laboratório (Arquitetura)

Nossa arquitetura é como uma orquestra bem afinada, onde cada serviço da AWS tem um papel fundamental:

* **🎤 AWS API Gateway**: O nosso "maestro" da linha de frente, atuando como um endpoint funcional para receber todos os pedidos em tempo real.
* **🗃️ Amazon S3**: Nosso Data Lake, o lugar seguro onde os arquivos de pedidos em lote aguardam o processamento.
* **🧠 AWS Lambda**: O cérebro da operação! Funções que executam toda a lógica de validação, processamento central de pedidos e extração de pedidos de arquivos.
* **📬 Amazon SQS**: O nosso sistema de correios inteligente, usando filas para desacoplar o processamento, e garantindo que nenhuma mensagem se perca com o uso de DLQs (Dead-Letter Queues).
* **🌉 Amazon EventBridge**: A nossa central de eventos, que anuncia quando novos pedidos foram validados e os direciona para o lugar certo.
 * **💾 Amazon DynamoDB**: A memória persistente do nosso sistema, onde guardamos o histórico de validação e todos os detalhes dos pedidos processados. 

* **🔔 Amazon SNS**: O nosso sistema de alarme, que nos notifica imediatamente sobre erros na validação dos arquivos. 
---

## 🗺️ Nossa Jornada Dia a Dia

A construção foi uma aventura dividida em quatro dias intensos:
* **Dia 1️⃣: A Porta de Entrada**
    * **Foco:** Ingestão de Pedidos via API e EventBridge.
        - **Servicos**: IAM, Lambda, API Gateway, EventBridge E SQS.

* **Dia 2️⃣: O Poder dos Arquivos**
    * **Foco:** Ingestão de Arquivos via S3 e Rastreamento.

* **Dia 3️⃣: O Coração do Sistema**
    * **Foco:** Processamento Central de Pedidos e Persistência.

* **Dia 4️⃣: Refinando a Resiliência**
    * **Foco:** Implementação de Fluxos Adicionais de Pedidos e DLQs.

---

## 🚀 Como Embarcar Nesta Aventura (Como Usar)

Pronto para colocar a mão na massa?] Siga os passos abaixo para replicar o projeto!

1.  **Checklist de Ferramentas:**
    * ✅ Uma conta na AWS com superpoderes (acesso de administrador).
    * ✅ AWS CLI instalado e configurado.
    * ✅ Node.js e npm (ou seu ambiente de desenvolvimento favorito).
    * ✅ Git para controle de versão.

2.  **Clone o Universo do Projeto:**
    ```bash
    git clone [https://github.com/](https://github.com/)[SEU-USUARIO]/[NOME-DO-REPOSITORIO].git
    cd [NOME-DO-REPOSITORIO]
    ```

3.  **Instale as Dependências Mágicas:**
    
4.  **Lance o Foguete (Deploy):**
---

## 🤝 Quer Fazer Parte? (Contribuição)

Este é um projeto de aprendizado, e toda ajuda é bem-vinda para torná-lo ainda melhor! Se você tem uma ideia incrível, siga estes passos:

1.  **Faça um Fork** 🍴 deste repositório.
2.  **Crie uma Branch** ✨ para sua nova funcionalidade (`git checkout -b feature/minha-ideia-genial`).
3.  **Faça o Commit** ✅ de suas alterações (`git commit -m 'Implementa minha ideia genial'`).
4.  **Faça o Push** ⬆️ para a sua branch (`git push origin feature/minha-ideia-genial`).
5.  **Abra um Pull Request** 📬 e compartilhe sua magia com a gente!

---

## 📜 Licença

Distribuído sob a licença MIT. Sinta-se livre para usar, modificar e compartilhar. Consulte o arquivo `LICENSE` para mais detalhes.