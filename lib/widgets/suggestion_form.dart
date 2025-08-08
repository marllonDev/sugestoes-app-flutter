import 'package:flutter/material.dart';

class SuggestionForm extends StatefulWidget {
  const SuggestionForm({super.key});

  @override
  State<SuggestionForm> createState() => _SuggestionFormState();
}

class _SuggestionFormState extends State<SuggestionForm> {
  final _controller = TextEditingController();

  void _enviarSugestao() {
    final textoDaSugestao = _controller.text;
    print('Sugestão a ser enviada: $textoDaSugestao');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // 1. Usamos o 'Center' para centralizar nosso formulário na tela.
    return Center(
      // 2. Usamos o 'ConstrainedBox' para limitar a largura máxima.
      // Isso impede que o formulário se estique em telas grandes.
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600), // Largura máxima
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Sua sugestão anônima',
                border: OutlineInputBorder(
                  // 3. Adicionamos o borderRadius para ter bordas arredondadas.
                  borderRadius: BorderRadius.circular(12.0),
                ),
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            // 4. O botão agora terá seu tamanho natural, sem se esticar.
            ElevatedButton(
              onPressed: _enviarSugestao,
              child: const Text('ENVIAR'),
            ),
          ],
        ),
      ),
    );
  }
}