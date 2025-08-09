import 'package:flutter/material.dart';
import '../widgets/suggestion_form.dart';
import 'suggestions_list_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(19, 248, 188, 6),
        title: const Text('Caixa de Sugestões'),
        centerTitle: true,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.edit), text: 'Enviar'),
            Tab(icon: Icon(Icons.list), text: 'Ver Todas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          Padding(
            padding: EdgeInsets.all(16.0),
            child: SuggestionForm(),
          ),
          // Usamos nossa nova página, que agora tem toda a lógica de busca
          SuggestionsListPage(),
        ],
      ),
    );
  }
}