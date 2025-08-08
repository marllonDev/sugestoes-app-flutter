import 'package:flutter/material.dart';
import '../widgets/suggestion_form.dart'; // O formulário que já temos

// 1. Criamos um widget simples para ser o conteúdo da nossa segunda aba.
// No futuro, esta tela mostrará a lista de sugestões.
class SuggestionsListPage extends StatelessWidget {
  const SuggestionsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('A lista de sugestões (GET) aparecerá aqui.'),
    );
  }
}

// 2. A HomePage agora precisa controlar o estado das abas.
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
  with SingleTickerProviderStateMixin { // 3. Mixin necessário para o TabController
  
  late TabController _tabController;

  // O método 'initState' é chamado uma única vez quando o widget é criado.
  // É o local perfeito para inicializar nosso controller.
  @override
  void initState() {
    super.initState();
    // Criamos o controller com 2 abas.
    _tabController = TabController(length: 2, vsync: this);
  }

  // É importante liberar os recursos do controller quando o widget for descartado.
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 248, 162, 49),
        title: const Text('Caixa de Sugestões'),
        centerTitle: true,
        // 4. A propriedade 'bottom' da AppBar é o local ideal para a TabBar.
        bottom: TabBar(
          automaticIndicatorColorAdjustment: true,
          indicatorSize: TabBarIndicatorSize.tab,
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.send_rounded), text: 'Enviar'),
            Tab(icon: Icon(Icons.list_alt_rounded), text: 'Ver Todas'),
          ],
        ),
      ),
      // 5. O corpo da página agora é uma TabBarView.
      body: TabBarView(
        controller: _tabController,
        children: const [
          // Conteúdo da primeira aba: nosso formulário
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SuggestionForm(),
          ),
          // Conteúdo da segunda aba: a página de lista que criamos
          SuggestionsListPage(),
        ],
      ),
    );
  }
}