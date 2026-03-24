## 1. ##

graph TD

A[Scaffold] --> B[AppBar]
A --> C[Body]
A --> D[FloatingActionButton]

C --> E[SingleChildScrollView]
E --> F[Column]

F --> G[Header / Greeting + Search]
F --> H[CategorySection]
F --> I[BannerCarousel]
F --> J[PopularSection]
F --> K[NearbySection]

H --> H1[CategoryList - Horizontal ListView]
H1 --> H2[CategoryItem]

I --> I1[PageView]
I1 --> I2[BannerItem]

J --> J1[SectionHeader]
J --> J2[ProductList Horizontal]
J2 --> J3[ProductCard]

K --> K1[SectionHeader]
K --> K2[ProductList Vertical]
K2 --> K3[ProductTile]

D --> D1[Badge]

## 2. ##
| Widget              | Tipo             | Justificativa                                                   |
| ------------------- | ---------------- | --------------------------------------------------------------- |
| CategorySection     | StatelessWidget  | Agrupa título + lista horizontal de categorias                  |
| CategoryItem        | StatelessWidget  | Repetido várias vezes, responsabilidade simples (ícone + texto) |
| BannerCarousel      | StatefulWidget   | Precisa gerenciar estado da página atual (indicador de pontos)  |
| BannerItem          | StatelessWidget  | Cada banner individual é apenas visual                          |
| PopularSection      | StatelessWidget  | Estrutura de seção reutilizável (título + lista)                |
| ProductCard         | StatelessWidget  | Card horizontal reutilizável                                    |
| NearbySection       | StatelessWidget  | Outra seção com mesma ideia estrutural                          |
| ProductTile         | StatelessWidget  | Item vertical simples                                           |
| SectionHeader       | StatelessWidget  | Título + botão "ver todos", reutilizável                        |
| Badge (FAB counter) | StatelessWidget* | Visualmente simples, mas depende de estado global               |


## 3. ##
