import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Importa nosso serviço de API

class SuggestionsListPage extends StatefulWidget {
  const SuggestionsListPage({super.key});

  @override
  State<SuggestionsListPage> createState() => _SuggestionsListPageState();
}

class _SuggestionsListPageState extends State<SuggestionsListPage> {
  // 1. Variável para armazenar o "Future" da nossa chamada de API.
  // Um Future é um objeto que representa um valor que estará disponível no futuro.
  late Future<List<Map<String, dynamic>>> _sugestoesFuture;

  // O método 'initState' é chamado uma vez quando o widget é inserido na árvore.
  // É o lugar perfeito para iniciar nossa chamada de API.
  @override
  void initState() {
    super.initState();
    // 2. Chamamos a função da API e guardamos o Future retornado na nossa variável.
    _sugestoesFuture = ApiService.buscarSugestoes();
  }

  @override
  Widget build(BuildContext context) {
    // 3. Usamos o widget FutureBuilder.
    // Ele se reconstrói automaticamente com base no estado do nosso Future.
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _sugestoesFuture, // O Future que ele vai observar
      builder: (context, snapshot) {
        // CASO 1: O Future ainda está em andamento (carregando).
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        // CASO 2: O Future completou com um erro.
        if (snapshot.hasError) {
          return Center(child: Text('Erro ao carregar sugestões: ${snapshot.error}'));
        }

        // CASO 3: O Future completou com sucesso, mas não temos dados.
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma sugestão encontrada.'));
        }

        // CASO 4: O Future completou com sucesso e temos dados!
        final sugestoes = snapshot.data!;
        
        // Usamos um ListView.builder para construir a lista de forma eficiente.
        return ListView.builder(
          itemCount: sugestoes.length,
          itemBuilder: (context, index) {
            final sugestao = sugestoes[index];
            // Usamos um Card para dar um visual mais agradável a cada item.
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                leading: CircleAvatar(child: Text('${sugestao['id']}')),
                title: Text(sugestao['sugestao'] ?? 'Sem texto'),
                subtitle: Text('Autor: ${sugestao['autor'] ?? 'Anônimo'}'),
              ),
            );
          },
        );
      },
    );
  }
}