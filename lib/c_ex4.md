flowchart TD

    A[Scaffold] --> B[AppBar]
    A --> D[Body - SingleChildScrollView]
    A --> S[BottomNavigationBar / BottomAppBar]

    B --> C1[IconButton - Voltar]
    B --> C2["Text - Detalhes do Produto"]
    B --> C3[IconButton - Favorito]

    D --> E[Column]

    E --> F[Image - Pizza hmmm delicia]
    
    E --> G[Padding]
    G --> H[Column]

    H --> I[Text - Pizza boa demais]
    
    H --> J[Row - Categorias]
    J --> J1[Container - Salgada]
    J --> J2[Container - Vegetariana]

    H --> K["Text - R$ 45,90"]

    H --> L[Row - Avaliação]
    L --> L1[Icon - ⭐]
    L --> L2[Icon - ⭐]
    L --> L3[Icon - ⭐]
    L --> L4[Icon - ⭐]
    L --> L5[Icon - ⭐]
    L --> L6["Text - Nota e avaliações"]

    H --> M[Divider]

    H --> N["Text - Descrição"]
    H --> O["Text - Conteúdo descrição"]

    H --> P[Divider]

    H --> Q["Text - Ingredientes"]
    H --> R[Text - Lista de ingredientes]

    S --> T["ElevatedButton - Adicionar ao pedido"]