import 'package:flutter/material.dart';
import '../../config/routes.dart';
import '../../utils/colors.dart';
import '../../widgets/custom_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  double _opacity = 0.0;
  double _yOffset = 40.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 150), () {
      if (mounted) {
        setState(() {
          _opacity = 1.0;
          _yOffset = 0.0;
        });
      }
    });
  }

  Widget _animatedItem({required Widget child, int delayMultiplier = 1}) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 600 * delayMultiplier),
      opacity: _opacity,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 600 * delayMultiplier),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _yOffset * delayMultiplier, 0),
        child: child,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.primary,
              AppColors.secondary,
            ],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const ClampingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 10),

                        // HEADER
                        _animatedItem(
                          delayMultiplier: 1,
                          child: Column(
                            children: [
                              Container(
                                height: 85,
                                width: 85,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white.withOpacity(0.3), width: 1.5),
                                ),
                                child: const Icon(
                                  Icons.insights_rounded,
                                  size: 42,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'CampusConnect',
                                style: TextStyle(
                                  fontSize: 38,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: -1.5,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Caronas universitárias inteligentes.',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white.withOpacity(0.85),
                                  fontWeight: FontWeight.w300,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // CARD CENTRAL
                        _animatedItem(
                          delayMultiplier: 2,
                          child: Container(
                            padding: const EdgeInsets.all(22),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: Colors.white.withOpacity(0.25), width: 1.5),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 25,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildFeatureRow(
                                  Icons.shield_outlined,
                                  'Comunidade Segura',
                                  'Apenas estudantes com e-mail institucional verificado.',
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 14.0),
                                  child: Divider(color: Colors.white12, height: 1),
                                ),
                                _buildFeatureRow(
                                  Icons.wb_sunny_outlined,
                                  'Pegue ou Ofereça',
                                  'Economize no combustível ou encontre viagens rápidas para a aula.',
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 25),

                        // ACTIONS: Dois Botões
                        _animatedItem(
                          delayMultiplier: 3,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0), // Margem para os botões ficarem mais compactos
                            child: Column(
                              children: [
                                // BOTÃO ENTRAR: Usa o seu CustomButton limitado a 50px de altura
                                SizedBox(
                                  width: double.infinity,
                                  height: 50, 
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white, 
                                      foregroundColor: AppColors.primary, // Cor do texto 
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppRoutes.cadastro);
                                    },
                                    child: const Text(
                                      'Cadastrar', // Botão explícito para Cadastrar
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 12),
                                
                                // BOTÃO CADASTRAR:
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white, // Fundo  branco
                                      foregroundColor: AppColors.primary, // Cor do texto 
                                      elevation: 2,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, AppRoutes.login);
                                    },
                                    child: const Text(
                                      'Entrar', // Botão explícito para Entrar
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
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

  Widget _buildFeatureRow(IconData icon, String title, String description) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: Colors.white, size: 24),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.75),
                  fontSize: 13,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}