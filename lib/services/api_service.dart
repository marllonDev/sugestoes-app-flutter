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

  // A função que vai enviar a sugestão para o backend.(POST)
  // Ela é 'async' porque operações de rede não são instantâneas.
  static Future<bool> enviarSugestao(Map<String, dynamic> dados) async {
    final url = Uri.parse('$baseUrl/sugestao');

    // Tentamos executar a chamada de rede.
    try {
      // O corpo (body) da nossa requisição.
      // Usamos 'jsonEncode' para transformar nosso mapa Dart em uma string JSON.
      final body = jsonEncode(dados);

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

//  FUNÇÃO PARA BUSCAR DADOS (GET)
  static Future<List<Map<String, dynamic>>> buscarSugestoes() async {
    final url = Uri.parse('$baseUrl/sugestoes');
    
    try {
      // Executa a chamada GET e aguarda a resposta.
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Se a resposta for sucesso (200 OK):
        // 1. Pega o corpo da resposta (que é uma string JSON).
        // 2. Decodifica a string JSON para um objeto Dart (será uma Lista de Mapas).
        final List<dynamic> corpoDecodificado = jsonDecode(response.body);
        
        // Converte a lista de 'dynamic' para o tipo que esperamos.
        final List<Map<String, dynamic>> sugestoes = List.castFrom(corpoDecodificado);
        
        print('✅ ${sugestoes.length} sugestões recebidas da API.');
        return sugestoes;
      } else {
        // Se o servidor respondeu com um erro.
        print('❌ Erro no servidor ao buscar sugestões: ${response.statusCode}');
        return []; // Retorna uma lista vazia em caso de erro.
      }
    } catch (e) {
      // Se houve um erro de conexão.
      print('🔥 Erro de conexão ao buscar sugestões: $e');
      return []; // Retorna uma lista vazia em caso de erro.
    }
  }

}