import 'package:flutter/material.dart';
import 'pages/home_page.dart'; // 1. Importa nossa nova página principal

void main() {
  runApp(const MeuApp());
}

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Caixa de Sugestões',
      // Removemos o 'debugShowCheckedModeBanner' para um visual mais limpo
      debugShowCheckedModeBanner: false, 
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // 2. Aponta para a HomePage que agora vive em seu próprio arquivo
      home: const HomePage(), 
    );
  }
}