## 1. ##
graph TD

A[Scaffold] --> B[AppBar]
A --> C[Body]
A --> D[BottomActionBar]

B --> B1[BackButton]
B --> B2[Title]
B --> B3[FavoriteButton]

C --> E[Column]

E --> F[Expanded]
F --> G[SingleChildScrollView]

G --> H[Column]

H --> I[ProductImage]
H --> J[ProductInfo]
H --> K[RatingRow]
H --> L[DescriptionSection]
H --> M[IngredientsSection]

D --> N[AddToCartButton]

J --> J1[ProductName]
J --> J2[Price]

K --> K1[StarsRow]
K --> K2[ReviewText]

L --> L1[SectionTitle]
L --> L2[DescriptionText]

M --> M1[SectionTitle]
M --> M2[IngredientsText]