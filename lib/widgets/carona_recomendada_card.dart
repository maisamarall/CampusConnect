import 'package:flutter/material.dart';

class CaronaRecomendadaCard extends StatelessWidget {
  final String nome;
  final String curso;
  final String origem;
  final String destino;
  final String horario;
  final String vagas;
  final String valor;

  const CaronaRecomendadaCard({
    super.key,
    required this.nome,
    required this.curso,
    required this.origem,
    required this.destino,
    required this.horario,
    required this.vagas,
    required this.valor,
  });

  String get iniciais {
    final partes = nome.trim().split(' ');
    if (partes.length >= 2) {
      return '${partes[0][0]}${partes[1][0]}'.toUpperCase();
    }
    return nome.substring(0, 1).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 14),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.blueGrey.shade100),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.04),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 27,
                backgroundColor: const Color(0xFF075AA6),
                child: Text(
                  iniciais,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome,
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        fontSize: 17,
                      ),
                    ),
                    Text(
                      curso,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 6),
                    const Row(
                      children: [
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        Icon(Icons.star, color: Colors.orange, size: 18),
                        SizedBox(width: 6),
                        Text("4.9"),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "$vagas vagas",
                  style: TextStyle(
                    color: Colors.green.shade600,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 18),

          Row(
            children: [
              const Icon(Icons.location_on_outlined, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  "$origem  →  $destino",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.access_time, size: 20),
              const SizedBox(width: 8),
              Text(
                "Hoje • $horario",
                style: TextStyle(color: Colors.grey.shade700),
              ),
            ],
          ),

          const Divider(height: 28),

          Row(
            children: [
              Text(
                "Valor",
                style: TextStyle(color: Colors.grey.shade600),
              ),
              const Spacer(),
              Text(
                "R\$ $valor",
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}