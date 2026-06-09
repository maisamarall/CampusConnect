import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../services/carona_service.dart';
import '../utils/colors.dart';

class EcoPointsCard extends StatelessWidget {
  final CaronaService service;

  const EcoPointsCard({
    super.key,
    required this.service,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return const SizedBox.shrink();

    return StreamBuilder<Map<String, dynamic>>(
      stream: service.ecoPointsDoUsuario(user.uid),
      builder: (context, snapshot) {
        final dados = snapshot.data ?? {"total": 0, "co2EstimadoKg": "0.0"};

        return Container(
          width: double.infinity,
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: const Color(0xFFEFFAF1),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: const Color(0xFFCDEFD4)),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFD8F5DD),
                child: FaIcon(
                  FontAwesomeIcons.leaf,
                  size: 18,
                  color: Color(0xFF16833A),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "EcoPoints",
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${dados['total']} pontos acumulados",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "Estimativa: ${dados['co2EstimadoKg']} kg de CO2 evitados",
                      style: TextStyle(color: Colors.grey.shade700),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
