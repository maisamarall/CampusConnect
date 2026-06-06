import 'package:flutter/material.dart';
import '../screens/auth/welcome_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/cadastro_screen.dart';

class AppRoutes {
  // Defini os nomes das rotas como constantes
  static const String welcome = '/';
  static const String login = '/login';
  static const String cadastro = '/cadastro';

  // Mapa de rotas associando os nomes às telas correspondentes
  static Map<String, WidgetBuilder> get routes => {
        welcome: (context) => const WelcomeScreen(),
        login: (context) => const LoginScreen(),
        cadastro: (context) => const CadastroScreen(),
      };
}