import 'config/routes.dart'; // Importa o arquivo de rotas que organizamos
import 'utils/colors.dart';  // Importa suas cores padronizadas (AppColors)
import 'package:flutter/material.dart'; // Importa o Flutter Material para usar os widgets básicos
import 'package:firebase_core/firebase_core.dart'; // Importa o Firebase Core para inicializar o Firebase
import 'firebase_options.dart'; // Importa as opções de configuração do Firebase
import 'package:supabase_flutter/supabase_flutter.dart'; // Importa o Supabase Flutter para usar o Supabase

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,

    
  );
   await Supabase.initialize(
    url: 'https://xbuqkasvlhzqthkmscxp.supabase.co',
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InhidXFrYXN2bGh6cXRoa21zY3hwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA2OTUzODcsImV4cCI6MjA5NjI3MTM4N30.MnU0DRA7DSkqmRdPtAoEN-K6hBPsSx0VB1SM6e6ufCA',
    );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override 
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CampusConnect',
      debugShowCheckedModeBanner: false,
      
      // Define a identidade visual global do seu app baseada nas suas cores
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
        ),
        useMaterial3: true,
      ),

      // aqui define que o app vai entrar na tela de boas-vindas (welcome) ao iniciar
      initialRoute: AppRoutes.welcome, 
      
      // Carrega o mapa de rotas (/welcome, /login, /cadastro)
      routes: AppRoutes.routes,

    );
  }
}