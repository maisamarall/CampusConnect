import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'indicador_card.dart';

class DashboardIndicadores extends StatelessWidget {
  const DashboardIndicadores({super.key});

  @override
  Widget build(BuildContext context) {
    final caronasRef = FirebaseDatabase.instance.ref('caronas');

    return StreamBuilder<DatabaseEvent>(
      stream: caronasRef.onValue,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 115,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return const Text("Erro ao carregar indicadores");
        }

        if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
          return const _IndicadoresVazios();
        }

        final dadosFirebase = Map<dynamic, dynamic>.from(
          snapshot.data!.snapshot.value as Map,
        );

        final caronas = dadosFirebase.entries.map((entry) {
          final dadosCarona = Map<String, dynamic>.from(entry.value as Map);

          return {
            'id': entry.key.toString(), // ID/hash da carona
            ...dadosCarona,
          };
        }).toList();

        final disponiveisHoje = caronas.where((carona) {
          return carona['status'] == 'disponível' ||
              carona['status'] == 'disponivel';
        }).length;

        final pendentes = caronas.where((carona) {
          return carona['status'] == 'pendente';
        }).length;

        final proximas = caronas.where((carona) {
          return (carona['status'] == 'disponível' ||
                  carona['status'] == 'disponivel') &&
              carona['hora'] != null;
        }).toList();

        proximas.sort((a, b) {
          return a['hora'].toString().compareTo(b['hora'].toString());
        });

        String proximaHora = "--:--";

        if (proximas.isNotEmpty) {
          proximaHora = proximas.first['hora'].toString();

          // Aqui você já tem o ID/hash da próxima carona
          debugPrint("ID da próxima carona: ${proximas.first['id']}");
        }

        return Row(
          children: [
            IndicadorCard(
              icon: Icons.calendar_month_outlined,
              valor: disponiveisHoje.toString(),
              titulo: "Disponíveis",
              corIcone: Colors.blue,
            ),
            const SizedBox(width: 12),
            IndicadorCard(
              icon: Icons.access_time,
              valor: pendentes.toString(),
              titulo: "Pendentes",
              corIcone: Colors.orange,
            ),
            const SizedBox(width: 12),
            IndicadorCard(
              icon: Icons.calendar_today_outlined,
              valor: proximaHora,
              titulo: "Próxima",
              corIcone: Colors.green,
            ),
          ],
        );
      },
    );
  }
}

class _IndicadoresVazios extends StatelessWidget {
  const _IndicadoresVazios();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        IndicadorCard(
          icon: Icons.calendar_month_outlined,
          valor: "0",
          titulo: "Disponíveis hoje",
          corIcone: Colors.blue,
        ),
        SizedBox(width: 12),
        IndicadorCard(
          icon: Icons.access_time,
          valor: "0",
          titulo: "Pendentes",
          corIcone: Colors.orange,
        ),
        SizedBox(width: 12),
        IndicadorCard(
          icon: Icons.calendar_today_outlined,
          valor: "--:--",
          titulo: "Próxima",
          corIcone: Colors.green,
        ),
      ],
    );
  }
}