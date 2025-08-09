import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SuggestionForm extends StatefulWidget {
  const SuggestionForm({super.key});

  @override
  State<SuggestionForm> createState() => _SuggestionFormState();
}

class _SuggestionFormState extends State<SuggestionForm> {
  // 1. Temos um controller para cada campo de texto.
  final _autorController = TextEditingController();
  final _sugestaoController = TextEditingController();

  bool _isLoading = false;

  Future<void> _enviarSugestao() async {
    // Validação simples para não enviar sugestões vazias.
    if (_sugestaoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, escreva uma sugestão antes de enviar.'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    // 2. Montamos o mapa (dicionário) com os dados dos dois campos.
    final dadosParaEnviar = {
      'autor': _autorController.text.isNotEmpty ? _autorController.text : 'Anônimo',
      'sugestao': _sugestaoController.text,
    };

    // Chamamos a API, mas agora enviando o mapa completo.
    final sucesso = await ApiService.enviarSugestao(dadosParaEnviar);

    setState(() {
      _isLoading = false;
    });

    if (context.mounted) {
      final mensagem = sucesso
          ? 'Sugestão enviada com sucesso!'
          : 'Erro ao enviar sugestão. Tente novamente.';
      
      final cor = sucesso ? Colors.green : Colors.red;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(mensagem),
          backgroundColor: cor,
        ),
      );

      // 3. Se a operação foi bem-sucedida, limpamos os dois campos.
      if (sucesso) {
        _autorController.clear();
        _sugestaoController.clear();
      }
    }
  }

  @override
  void dispose() {
    // É importante limpar os dois controllers.
    _autorController.dispose();
    _sugestaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 600),
        child: Column(
          children: [
            // 4. Campo de texto para o autor.
            TextField(
              controller: _autorController,
              decoration: InputDecoration(
                labelText: 'Seu nome (opcional)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
            ),
            
            const SizedBox(height: 16),
        
            // O campo de texto para a sugestão.
            TextField(
              controller: _sugestaoController,
              decoration: InputDecoration(
                labelText: 'Sua sugestão',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              maxLines: 5,
            ),
            
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: _isLoading ? null : _enviarSugestao,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 3, color: Colors.white),
                    )
                  : const Text('ENVIAR'),
            ),
          ],
        ),
      ),
    );
  }
}