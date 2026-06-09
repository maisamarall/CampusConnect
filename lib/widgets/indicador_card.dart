import 'package:flutter/material.dart';
import '../utils/colors.dart';

class IndicadorCard extends StatelessWidget {
  final IconData icon;
  final String valor;
  final String titulo;
  final Color corIcone;

  const IndicadorCard({
    super.key,
    required this.icon,
    required this.valor,
    required this.titulo,
    required this.corIcone,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        height: 115,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: corIcone),
            const Spacer(),
            Text(
              valor,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              titulo,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}