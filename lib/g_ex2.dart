import 'package:flutter/material.dart';

void main() {
  runApp(const MeuAppEx2());
}

class MeuAppEx2 extends StatelessWidget {
  const MeuAppEx2({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercicio 2 - Historico de Pedidos',
      theme: ThemeData.light(
        useMaterial3: true,
      ),
      home: const TelaHistoricoPedidos(),
    );
  }
}

class ResumoPedido {
  const ResumoPedido({
    required this.id,
    required this.descricao,
    required this.valorTotal,
    required this.status,
  });

  final String id;
  final String descricao;
  final double valorTotal;
  final String status; // 'pendente', 'confirmado', 'entregue', 'cancelado'
}

class TelaHistoricoPedidos extends StatefulWidget {
  const TelaHistoricoPedidos({super.key});

  @override
  State<TelaHistoricoPedidos> createState() => _TelaHistoricoPedidosState();
}

class _TelaHistoricoPedidosState extends State<TelaHistoricoPedidos> {
  late TextEditingController _controladorBusca;
  String _termoBusca = '';
  bool _carregando = true;

  // Lista de pedidos de exemplo com diferentes status.
  final List<ResumoPedido> _todosPedidos = const [
    ResumoPedido(
      id: '1',
      descricao: 'Pizza Margherita',
      valorTotal: 45.90,
      status: 'entregue',
    ),
    ResumoPedido(
      id: '2',
      descricao: 'Hamburguer Duplo',
      valorTotal: 32.50,
      status: 'confirmado',
    ),
    ResumoPedido(
      id: '3',
      descricao: 'Pizza Calabresa',
      valorTotal: 52.00,
      status: 'pendente',
    ),
    ResumoPedido(
      id: '4',
      descricao: 'Salada Caesar',
      valorTotal: 28.90,
      status: 'entregue',
    ),
    ResumoPedido(
      id: '5',
      descricao: 'Refrigerante 2L',
      valorTotal: 8.50,
      status: 'cancelado',
    ),
    ResumoPedido(
      id: '6',
      descricao: 'Pizza 4 Queijos',
      valorTotal: 58.00,
      status: 'confirmado',
    ),
    ResumoPedido(
      id: '7',
      descricao: 'Agua com Gas',
      valorTotal: 5.00,
      status: 'entregue',
    ),
    ResumoPedido(
      id: '8',
      descricao: 'Sobremesa Gelada',
      valorTotal: 18.90,
      status: 'cancelado',
    ),
  ];

  @override
  void initState() {
    super.initState();

    // Cria o controlador e atribui um listener para filtrar em tempo real.
    _controladorBusca = TextEditingController();
    _controladorBusca.addListener(_atualizarBusca);

    // Simula um carregamento inicial de 3 segundos (representando
    // operacao como requisicao a servidor ou leitura de banco de dados).
    Future.delayed(const Duration(seconds: 3), () {
      // Verifica se o widget ainda esta montado antes de chamar setState.
      if (mounted) {
        setState(() {
          _carregando = false;
        });
      }
    });
  }

  @override
  void dispose() {
    // Libera o controlador para evitar vazamento de memoria.
    _controladorBusca.dispose();
    super.dispose();
  }

  void _atualizarBusca() {
    // Atualiza o termo de busca e reconstroi a lista filtrada.
    setState(() {
      _termoBusca = _controladorBusca.text.toLowerCase();
    });
  }

  List<ResumoPedido> _obterPedidosFiltrados() {
    // Filtra pedidos cuja descricao contenha o termo buscado.
    if (_termoBusca.isEmpty) {
      return _todosPedidos;
    }
    return _todosPedidos
        .where((pedido) => pedido.descricao.toLowerCase().contains(_termoBusca))
        .toList();
  }

  void _limparBusca() {
    _controladorBusca.clear();
    _atualizarBusca();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pedidosFiltrados = _obterPedidosFiltrados();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historico de Pedidos',
          style: theme.textTheme.titleLarge,
        ),
        backgroundColor: theme.colorScheme.primary,
        centerTitle: true,
      ),
      body: _carregando
          ? _construirTelaCarregamento(theme)
          : Column(
              children: [
                // Campo de busca com filtro em tempo real.
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: TextField(
                    controller: _controladorBusca,
                    decoration: InputDecoration(
                      hintText: 'Buscar pedido...',
                      prefixIcon: Icon(
                        Icons.search,
                        color: theme.colorScheme.primary,
                      ),
                      suffixIcon: _controladorBusca.text.isEmpty
                          ? null
                          : IconButton(
                              icon: Icon(
                                Icons.clear,
                                color: theme.colorScheme.error,
                              ),
                              onPressed: _limparBusca,
                            ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                  ),
                ),
                // Texto indicando quantidade de resultados.
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '${pedidosFiltrados.length} pedido(s) encontrado(s)',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                // Lista ou estado vazio.
                Expanded(
                  child: pedidosFiltrados.isEmpty
                      ? _construirEstadoVazio(theme)
                      : _construirListaPedidos(theme, pedidosFiltrados),
                ),
              ],
            ),
    );
  }

  Widget _construirTelaCarregamento(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Carregando pedidos...',
            style: theme.textTheme.bodyLarge,
          ),
        ],
      ),
    );
  }

  Widget _construirEstadoVazio(ThemeData theme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 64,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
          ),
          const SizedBox(height: 16),
          Text(
            'Nenhum pedido encontrado',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tente outro termo de busca',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
            ),
          ),
        ],
      ),
    );
  }

  Widget _construirListaPedidos(
    ThemeData theme,
    List<ResumoPedido> pedidos,
  ) {
    return ListView.builder(
      itemCount: pedidos.length,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemBuilder: (context, index) {
        final pedido = pedidos[index];
        // ValueKey garante que o estado correto seja mantido quando
        // a ordem muda, mesmo que aqui usemos StatelessWidget.
        return CartaoPedido(
          key: ValueKey(pedido.id),
          pedido: pedido,
        );
      },
    );
  }
}

class CartaoPedido extends StatelessWidget {
  const CartaoPedido({
    super.key,
    required this.pedido,
  });

  final ResumoPedido pedido;

  Color _obterCorPorStatus(ThemeData theme) {
    switch (pedido.status) {
      case 'entregue':
        return Colors.green.shade50;
      case 'confirmado':
        return Colors.blue.shade50;
      case 'pendente':
        return Colors.orange.shade50;
      case 'cancelado':
        return Colors.red.shade50;
      default:
        return theme.colorScheme.surface;
    }
  }

  Color _obterCorTextoStatus(ThemeData theme) {
    switch (pedido.status) {
      case 'entregue':
        return Colors.green.shade700;
      case 'confirmado':
        return Colors.blue.shade700;
      case 'pendente':
        return Colors.orange.shade700;
      case 'cancelado':
        return Colors.red.shade700;
      default:
        return theme.colorScheme.onSurface;
    }
  }

  String _traduzirStatus(String status) {
    final traducoes = {
      'entregue': 'Entregue',
      'confirmado': 'Confirmado',
      'pendente': 'Pendente',
      'cancelado': 'Cancelado',
    };
    return traducoes[status] ?? status;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      color: _obterCorPorStatus(theme),
      elevation: pedido.status == 'cancelado' ? 0 : 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Pedido #${pedido.id}',
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _obterCorTextoStatus(theme).withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    _traduzirStatus(pedido.status),
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: _obterCorTextoStatus(theme),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              pedido.descricao,
              style: theme.textTheme.bodyMedium?.copyWith(
                decoration: pedido.status == 'cancelado'
                    ? TextDecoration.lineThrough
                    : null,
                color: pedido.status == 'cancelado'
                    ? theme.colorScheme.onSurface.withValues(alpha: 0.5)
                    : null,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.bottomRight,
              child: Text(
                'R\$ ${pedido.valorTotal.toStringAsFixed(2)}',
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
