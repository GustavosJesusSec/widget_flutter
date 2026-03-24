## 1. ##
```mermaid
flowchart TD

    A[Scaffold] --> B[AppBar]
    A --> D[Body - SingleChildScrollView]
    
    B --> C1[IconButton - Voltar]
    B --> C2["Text - Pedido"]

    D --> E[Column]

    E --> F[Card - Status]
    F --> F1[Column]
    F1 --> F1a[Row: Icone Cozinheiro + Text: Em preparo]
    F1 --> F1b[LinearProgressIndicator]
    F1 --> F1c[Row: Etapas Confirm./Preparo/Saiu/Entregue]

    E --> G[Card - Itens do Pedido]
    G --> H[Padding]
    H --> I[Column]
    I --> I1["Text - Itens do pedido"]
    I --> I2[Row: 2x Pizza Margherita + Preço]
    I --> I3[Row: 1x Refrigerante + Preço]
    I --> I4[Divider]
    I --> I5[Row: Subtotal + Valor]
    I --> I6[Row: Taxa de entrega + Valor]
    I --> I7["Text: Total + R$ 102,80"]

    E --> J[Card - Endereço de Entrega]
    J --> J1[ListTile]
    J1 --> J1a[Icon - Mapa/Localização]
    J1 --> J1b["Text - Rua das Flores, 123..."]

    E --> K[Card - Entregador]
    K --> L[ListTile]
    L --> L1[CircleAvatar - Foto Carlos Silva]
    L --> L2["Text - Carlos Silva [fone] / Entregador"]
    L --> L3[IconButton - Telefone]
```


## 2. Tabela de Componentes e Justificativa de Extração: ##
Decisão sobre quais partes da tela devem ser transformadas em widgets independentes para melhor organização.

Widget Sugerido:      |  Responsabilidade:                                         |   Critério de Extração: 
CardStatusPedido     |   Gerencia a barra de progresso e ícones de etapa.          |    Coesão: Isola a lógica visual do status.
CardItensPedido      |   Lista os produtos comprados e calcula o total.            |    Manutenção: Facilita alterar o layout da lista.
CardEndereco         |   Exibe o local de entrega com ícone.                       |    Reutilização: Pode ser usado na tela de Perfil ou Checkout.
CardEntregador       |   Mostra foto, nome e botão de contato.                     |    Coesão: Separa os dados de terceiros do resto do pedido.


## 3. Análise de StatefulWidget: ##
Se a tela precisasse consultar o servidor a cada 30 segundos para atualizar o status automaticamente, seriam necessários os seguintes ajustes:
Widget Stateful: O widget que contém o corpo da página (Body) precisaria ser um StatefulWidget para gerenciar o estado das atualizações e disparar o "rebuild" da interface.

Campos de Estado:
- statusAtual: Para controlar qual etapa está marcada e o texto de status.
- valorProgresso: Um valor numérico para a barra de carregamento.
- dadosDoEntregador: Para atualizar informações caso o entregador mude.