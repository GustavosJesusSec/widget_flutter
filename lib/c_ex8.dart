import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(
    home: TelaCatalogo(),
  ));
}


class Produto {
  final String id;
  final String nome;
  final String categoria;
  final double preco;
  final double avaliacao;
  final String imagemUrl;

  Produto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.preco,
    required this.avaliacao,
    required this.imagemUrl,
  });
}


class TelaCatalogo extends StatefulWidget {
  const TelaCatalogo({super.key});

  @override
  State<TelaCatalogo> createState() => _TelaCatalogoState();
}

class _TelaCatalogoState extends State<TelaCatalogo> {
  String _categoriaSelecionada = "Todos";

  final List<String> categorias = [
    "Todos",
    "Pizza",
    "Hamburguer",
    "Sushi",
    "Bebidas"
  ];

  final List<Produto> produtos = [
    Produto(id: "1", nome: "Pizza 1", categoria: "Pizza", preco: 40, avaliacao: 4.5, imagemUrl: ""),
    Produto(id: "2", nome: "Pizza 2", categoria: "Pizza", preco: 45, avaliacao: 4.6, imagemUrl: ""),
    Produto(id: "3", nome: "Pizza 3", categoria: "Pizza", preco: 50, avaliacao: 4.7, imagemUrl: ""),

    Produto(id: "4", nome: "Hamburguer 1", categoria: "Hamburguer", preco: 25, avaliacao: 4.2, imagemUrl: ""),
    Produto(id: "5", nome: "Hamburguer 2", categoria: "Hamburguer", preco: 30, avaliacao: 4.3, imagemUrl: ""),
    Produto(id: "6", nome: "Hamburguer 3", categoria: "Hamburguer", preco: 35, avaliacao: 4.4, imagemUrl: ""),

    Produto(id: "7", nome: "Sushi 1", categoria: "Sushi", preco: 60, avaliacao: 4.8, imagemUrl: ""),
    Produto(id: "8", nome: "Sushi 2", categoria: "Sushi", preco: 65, avaliacao: 4.7, imagemUrl: ""),
    Produto(id: "9", nome: "Sushi 3", categoria: "Sushi", preco: 70, avaliacao: 4.9, imagemUrl: ""),

    Produto(id: "10", nome: "Bebida 1", categoria: "Bebidas", preco: 8, avaliacao: 4.0, imagemUrl: ""),
    Produto(id: "11", nome: "Bebida 2", categoria: "Bebidas", preco: 10, avaliacao: 4.1, imagemUrl: ""),
    Produto(id: "12", nome: "Bebida 3", categoria: "Bebidas", preco: 12, avaliacao: 4.2, imagemUrl: ""),
  ];

  List<Produto> get _produtosFiltrados {
    if (_categoriaSelecionada == "Todos") {
      return produtos;
    }
    return produtos
        .where((p) => p.categoria == _categoriaSelecionada)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cardápio")),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: categorias.length,
              itemBuilder: (context, index) {
                final categoria = categorias[index];
                final selecionado =
                    categoria == _categoriaSelecionada;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _categoriaSelecionada = categoria;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: selecionado
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      categoria,
                      style: TextStyle(
                        color: selecionado
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),


          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: _produtosFiltrados.length,
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final produto = _produtosFiltrados[index];

                return CartaoProduto(
                  produto: produto,
                  onAdicionar: () {
                    debugPrint(produto.nome);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}


class CartaoProduto extends StatelessWidget {
  final Produto produto;
  final VoidCallback onAdicionar;

  const CartaoProduto({
    super.key,
    required this.produto,
    required this.onAdicionar,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Container(height: 100, color: Colors.grey),
          Text(produto.nome),
          Text("R\$ ${produto.preco}"),
          ElevatedButton(
            onPressed: onAdicionar,
            child: const Text("Adicionar"),
          )
        ],
      ),
    );
  }
}