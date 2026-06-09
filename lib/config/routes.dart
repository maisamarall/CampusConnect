import 'package:flutter/material.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/cadastro_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/caronas/criar_carona_screen.dart';
import '../screens/caronas/buscar_carona_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/avaliacao/avaliacao_screen.dart';


class AppRoutes {
  // Defini os nomes das rotas como constantes
  static const String welcome = '/';
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String home = '/home';
  static const String carona = '/carona';
  static const String buscarCaronas = '/buscar-caronas';
  static const String chat = '/chat';
  static const String avaliacao = '/avaliacao';

  // Mapa de rotas associando os nomes às telas correspondentes
  static Map<String, WidgetBuilder> get routes => {
        welcome: (context) => const WelcomeScreen(),
        login: (context) => const LoginScreen(),
        cadastro: (context) => const CadastroScreen(),
        home: (context) => const HomeScreen(),
        carona: (context) => const CriarCaronaScreen(),
        buscarCaronas: (context) => const BuscarCaronaScreen(),
        chat: (context) => const ChatScreen(),
        avaliacao: (context) => const AvaliacaoScreen(
          motoristaId: "123",
          motoristaNome: "Teste",
        ),
      };
}
