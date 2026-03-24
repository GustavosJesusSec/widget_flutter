import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: TelaFinalizarPedido(),
    );
  }
}



class ItemCarrinho {
  final int id;
  final String nome;
  final String observacao;
  final String imagemUrl;
  final double preco;
  int quantidade;

  ItemCarrinho({
    required this.id,
    required this.nome,
    required this.observacao,
    required this.imagemUrl,
    required this.preco,
    required this.quantidade,
  });

  double get subtotal => preco * quantidade;
}

class Endereco {
  final String logradouro;
  final String complemento;

  Endereco({
    required this.logradouro,
    required this.complemento,
  });
}

enum MetodoPagamento {
  cartaoCredito,
  cartaoDebito,
  pix,
}



class TelaFinalizarPedido extends StatefulWidget {
  const TelaFinalizarPedido({super.key});

  @override
  State<TelaFinalizarPedido> createState() =>
      _TelaFinalizarPedidoState();
}

class _TelaFinalizarPedidoState extends State<TelaFinalizarPedido> {
  late List<ItemCarrinho> _itens;
  MetodoPagamento _metodoPagamento = MetodoPagamento.pix;

  final Endereco endereco = Endereco(
    logradouro: "Rua Exemplo, 123",
    complemento: "Apto 45",
  );

  final double taxaEntrega = 5.0;

  @override
  void initState() {
    super.initState();

    _itens = [
      ItemCarrinho(
        id: 1,
        nome: "Pizza Margherita",
        observacao: "Sem cebola",
        imagemUrl:
            "https://images.unsplash.com/photo-1600891964599-f61ba0e24092",
        preco: 45.0,
        quantidade: 1,
      ),
      ItemCarrinho(
        id: 2,
        nome: "Hambúrguer",
        observacao: "Ponto médio",
        imagemUrl:
            "https://images.unsplash.com/photo-1550547660-d9450f859349",
        preco: 30.0,
        quantidade: 2,
      ),
      ItemCarrinho(
        id: 3,
        nome: "Refrigerante",
        observacao: "Gelado",
        imagemUrl:
            "https://images.unsplash.com/photo-1581636625402-29b2a704ef13",
        preco: 8.0,
        quantidade: 1,
      ),
    ];
  }


  double get totalItens =>
      _itens.fold(0, (sum, item) => sum + item.subtotal);

  double get total => totalItens + taxaEntrega;

  void _confirmarPedido() {
    debugPrint("=== PEDIDO ===");
    for (var item in _itens) {
      debugPrint("${item.nome} x${item.quantidade}");
    }
    debugPrint("Pagamento: $_metodoPagamento");
    debugPrint("Total: $total");
  }

  void _removerItem(ItemCarrinho item) {
    setState(() {
      _itens.remove(item);
    });
  }

  void _alterarQuantidade(ItemCarrinho item, int delta) {
    setState(() {
      item.quantidade = (item.quantidade + delta).clamp(1, 999);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Finalizar Pedido"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                /// ITENS
                SecaoPedido(
                  titulo: "Itens do pedido",
                  child: Column(
                    children: _itens.map((item) {
                      return Dismissible(
                        key: ValueKey(item.id),
                        direction: DismissDirection.endToStart,
                        onDismissed: (_) => _removerItem(item),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerRight,
                          padding:
                              const EdgeInsets.only(right: 16),
                          child: const Icon(
                            Icons.delete,
                            color: Colors.white,
                          ),
                        ),
                        child: CartItemTile(
                          item: item,
                          onAlterarQuantidade: (delta) =>
                              _alterarQuantidade(item, delta),
                        ),
                      );
                    }).toList(),
                  ),
                ),


                SecaoPedido(
                  titulo: "Endereço de entrega",
                  child: Card(
                    margin: const EdgeInsets.all(12),
                    child: ListTile(
                      leading:
                          const Icon(Icons.location_on_outlined),
                      title: Text(endereco.logradouro),
                      subtitle: Text(endereco.complemento),
                      trailing: TextButton(
                        onPressed: () {},
                        child: const Text("Alterar"),
                      ),
                    ),
                  ),
                ),


                SecaoPedido(
                  titulo: "Forma de pagamento",
                  child: Column(
                    children: MetodoPagamento.values.map((metodo) {
                      return RadioListTile<MetodoPagamento>(
                        title: Text(_labelPagamento(metodo)),
                        value: metodo,
                        groupValue: _metodoPagamento,
                        onChanged: (value) {
                          setState(() {
                            _metodoPagamento = value!;
                          });
                        },
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),


          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _linhaResumo("Subtotal", totalItens),
                _linhaResumo("Taxa de entrega", taxaEntrega),
                const Divider(),
                _linhaResumo("Total", total, isBold: true),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _confirmarPedido,
                    child: Text(
                        "Confirmar pedido — R\$ ${total.toStringAsFixed(2)}"),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  String _labelPagamento(MetodoPagamento m) {
    switch (m) {
      case MetodoPagamento.cartaoCredito:
        return "Cartão de crédito";
      case MetodoPagamento.cartaoDebito:
        return "Cartão de débito";
      case MetodoPagamento.pix:
        return "Pix";
    }
  }

  Widget _linhaResumo(String label, double valor,
      {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                fontWeight:
                    isBold ? FontWeight.bold : FontWeight.normal)),
        Text(
          "R\$ ${valor.toStringAsFixed(2)}",
          style: TextStyle(
              fontWeight:
                  isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}



class SecaoPedido extends StatelessWidget {
  final String titulo;
  final Widget child;

  const SecaoPedido({
    super.key,
    required this.titulo,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final ItemCarrinho item;
  final Function(int) onAlterarQuantidade;

  const CartItemTile({
    super.key,
    required this.item,
    required this.onAlterarQuantidade,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                item.imagemUrl,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    item.nome,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold),
                  ),
                  Text(item.observacao),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () =>
                            onAlterarQuantidade(-1),
                      ),
                      Text("${item.quantidade}"),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () =>
                            onAlterarQuantidade(1),
                      ),
                    ],
                  )
                ],
              ),
            ),
            Text(
              "R\$ ${item.subtotal.toStringAsFixed(2)}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}