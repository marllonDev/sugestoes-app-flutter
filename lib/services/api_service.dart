import 'dart:convert'; // Necessário para codificar o corpo da requisição em JSON
import 'package:http/http.dart' as http; // Importa o pacote que acabamos de instalar

class ApiService {
  // A URL base do nosso backend. Como estamos testando localmente,
  // usamos o endereço especial '10.0.2.2' para o emulador de Android
  // se conectar ao 'localhost' do seu PC. Para web, 'localhost' funciona.
  // Vamos criar uma forma inteligente de lidar com isso.
  static String get baseUrl {
    // A biblioteca 'kIsWeb' nos diz se o app está rodando na web.
    // Infelizmente não podemos usá-la aqui diretamente, mas faremos a verificação no widget.
    // Por enquanto, vamos focar na web.
    return 'http://localhost:5000';
  }

  // A função que vai enviar a sugestão para o backend.
  // Ela é 'async' porque operações de rede não são instantâneas.
  static Future<bool> enviarSugestao(String sugestao) async {
    // Montamos a URL completa do endpoint.
    final url = Uri.parse('$baseUrl/sugestao');

    // Tentamos executar a chamada de rede.
    try {
      // O corpo (body) da nossa requisição.
      // Usamos 'jsonEncode' para transformar nosso mapa Dart em uma string JSON.
      final body = jsonEncode({
        'sugestao': sugestao,
      });

      // Aqui a chamada HTTP acontece!
      // - url: O endereço de destino.
      // - headers: Informações importantes sobre a requisição. Dizemos ao backend que estamos enviando um JSON.
      // - body: O conteúdo que estamos enviando.
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      // Verificamos o código de status da resposta.
      // Códigos 2xx (como 200) geralmente significam sucesso.
      if (response.statusCode == 200) {
        print('✅ Sugestão enviada com sucesso!');
        return true;
      } else {
        // Se o status não for 200, algo deu errado no backend.
        print('❌ Erro no servidor: ${response.statusCode}');
        print('   Corpo da resposta: ${response.body}');
        return false;
      }
    } catch (e) {
      // Se a chamada de rede falhar (ex: sem internet, backend desligado).
      print('🔥 Erro de conexão ao enviar sugestão: $e');
      return false;
    }
  }
}