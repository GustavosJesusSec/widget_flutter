import 'package:flutter/material.dart';

void main() {
  runApp(const MeuAppEx1());
}

class MeuAppEx1 extends StatelessWidget {
  const MeuAppEx1({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercicio 1 - Favoritos',
      home: ContadorFavoritos(
        produtos: const [
          Produto(
            id: 1,
            nome: 'Notebook Pro 14"',
            categoria: 'Eletronicos',
            preco: 5299.90,
            disponivel: true,
          ),
          Produto(
            id: 2,
            nome: 'Fone Bluetooth',
            categoria: 'Acessorios',
            preco: 299.90,
            disponivel: true,
          ),
          Produto(
            id: 3,
            nome: 'Cadeira Ergonomica',
            categoria: 'Moveis',
            preco: 899.50,
            disponivel: false,
          ),
          Produto(
            id: 4,
            nome: 'Mouse Gamer',
            categoria: 'Perifericos',
            preco: 159.99,
            disponivel: true,
          ),
          Produto(
            id: 5,
            nome: 'Teclado Mecanico',
            categoria: 'Perifericos',
            preco: 349.00,
            disponivel: true,
          ),
        ],
      ),
    );
  }
}

class Produto {
  const Produto({
    required this.id,
    required this.nome,
    required this.categoria,
    required this.preco,
    required this.disponivel,
  });

  final int id;
  final String nome;
  final String categoria;
  final double preco;
  final bool disponivel;
}

class CartaoProduto extends StatelessWidget {
  const CartaoProduto({
    super.key,
    required this.nome,
    required this.categoria,
    required this.preco,
    required this.favoritado,
    required this.disponivel,
    required this.aoAlternarFavorito,
  });

  final String nome;
  final String categoria;
  final double preco;
  final bool favoritado;
  final bool disponivel;
  final VoidCallback aoAlternarFavorito;

  @override
  Widget build(BuildContext context) {
    final Color corIcone = !disponivel
        ? Colors.grey.shade400
        : (favoritado ? Colors.red : Colors.grey);

    return Opacity(
      // Produto indisponivel fica visualmente atenuado.
      opacity: disponivel ? 1.0 : 0.55,
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        elevation: 2,
        child: InkWell(
          // Toda a area do card pode receber toque.
          // Quando indisponivel, o toque fica desativado.
          onTap: disponivel ? aoAlternarFavorito : null,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nome em destaque para facilitar leitura.
                      Text(
                        nome,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          categoria,
                          style: TextStyle(
                            color: Colors.blue.shade900,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'R\$ ${preco.toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                      if (!disponivel) ...[
                        const SizedBox(height: 6),
                        const Text(
                          'Indisponivel no momento',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Icon(
                  favoritado ? Icons.favorite : Icons.favorite_border,
                  color: corIcone,
                  size: 28,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ContadorFavoritos extends StatefulWidget {
  const ContadorFavoritos({super.key, required this.produtos});

  final List<Produto> produtos;

  @override
  State<ContadorFavoritos> createState() => _ContadorFavoritosState();
}

class _ContadorFavoritosState extends State<ContadorFavoritos> {
  // O estado real da tela fica no pai: um conjunto com os IDs favoritados.
  final Set<int> _idsFavoritados = <int>{};

  void _alternarFavorito(Produto produto) {
    if (!produto.disponivel) {
      return;
    }

    setState(() {
      if (_idsFavoritados.contains(produto.id)) {
        _idsFavoritados.remove(produto.id);
      } else {
        _idsFavoritados.add(produto.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catalogo de Produtos'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(12),
            ),
            // Texto centralizado para destacar o total de favoritos.
            child: Text(
              'Favoritos: ${_idsFavoritados.length}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.produtos.length,
              itemBuilder: (context, index) {
                final Produto produto = widget.produtos[index];
                return CartaoProduto(
                  nome: produto.nome,
                  categoria: produto.categoria,
                  preco: produto.preco,
                  disponivel: produto.disponivel,
                  favoritado: _idsFavoritados.contains(produto.id),
                  aoAlternarFavorito: () => _alternarFavorito(produto),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}