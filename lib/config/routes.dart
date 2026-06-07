import 'package:flutter/material.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/cadastro_screen.dart';
import '../screens/caronas/criar_carona_screen.dart';
import '../screens/avaliacao/avaliacao_screen.dart';


class AppRoutes {
  // Defini os nomes das rotas como constantes
  static const String welcome = '/';
  static const String login = '/login';
  static const String cadastro = '/cadastro';
  static const String carona = '/carona';
  static const String avaliacao = '/avaliacao';

  // Mapa de rotas associando os nomes às telas correspondentes
  static Map<String, WidgetBuilder> get routes => {
        welcome: (context) => const WelcomeScreen(),
        login: (context) => const LoginScreen(),
        cadastro: (context) => const CadastroScreen(),
        carona: (context) => const CriarCaronaScreen(),
        avaliacao: (context) => const AvaliacaoScreen(
          motoristaId: "123",
          motoristaNome: "Teste",
        ),
      };
}