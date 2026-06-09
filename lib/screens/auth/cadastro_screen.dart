import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../utils/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool carregando = false;
  bool mostrarSenha = false;

  Future<void> cadastrar() async {

    setState(() {
      carregando = true;
    });

    try {

      // Cria usuário no Firebase Auth
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      final user = userCredential.user;

      // Salvar dados no Realtime Database
      if (user != null) {
        final dbRef = FirebaseDatabase.instance.ref();

        await dbRef.child("usuarios").child(user.uid).set({
          'nome': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'criadoEm': DateTime.now().toIso8601String(),
        });

        // (Opcional) salvar nome no perfil do usuário
        await user.updateDisplayName(_nameController.text.trim());
      }

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Conta criada com sucesso!"),
        ),
      );

      Navigator.pushReplacementNamed(context, AppRoutes.home);

    } on FirebaseAuthException catch (e) {

      String erro = "Erro ao cadastrar";

      if (e.code == 'email-already-in-use') {
        erro = "Email já está em uso";
      } else if (e.code == 'weak-password') {
        erro = "Senha muito fraca";
      } else if (e.code == 'invalid-email') {
        erro = "Email inválido";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(erro),
        ),
      );

    } catch (e) {

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erro: $e"),
        ),
      );

    }

    setState(() {
      carregando = false;
    });

  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.primary, AppColors.secondary],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: ConstrainedBox(
                  // Força o conteúdo a ter, no mínimo, a altura total da tela para centralizar
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center, // Centraliza na vertical
                      crossAxisAlignment: CrossAxisAlignment.center, // Centraliza na horizontal
                      children: [
                        // Títulos
                        const Text(
                          'Criar Conta',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Colors.white),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Faça parte da maior rede de caronas.',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.white.withOpacity(0.85)),
                        ),
                        const SizedBox(height: 30),

                        // Formulário com efeito de vidro
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.2),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                controller: _nameController,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.person_outline_rounded, color: Colors.white70, size: 20),
                                  hintText: 'Nome Completo',
                                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 14),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                              const Divider(color: Colors.white24, height: 1),
                              TextField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.email_outlined, color: Colors.white70, size: 20),
                                  hintText: 'E-mail Institucional',
                                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 14),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                              const Divider(color: Colors.white24, height: 1),
                              TextField(
                                controller: _passwordController,
                                obscureText: true,
                                style: const TextStyle(color: Colors.white, fontSize: 15),
                                decoration: InputDecoration(
                                  prefixIcon: const Icon(Icons.lock_outlined, color: Colors.white70, size: 20),
                                  hintText: 'Senha de Acesso',
                                  hintStyle: TextStyle(color: Colors.white.withOpacity(0.55), fontSize: 14),
                                  border: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 35),

                        // Botão de cadastrar compacto
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Column(
                            children: [
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: AppColors.primary,
                                    elevation: 2,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  onPressed: () {
                                    carregando ? null : cadastrar();
                                  },
                                  child: const Text(
                                    'Cadastrar',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 12),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(context, AppRoutes.login);
                                },
                                child: const Text(
                                  'Já tem uma conta? Faça Login',
                                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
