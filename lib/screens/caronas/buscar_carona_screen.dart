import 'package:flutter/material.dart';

import '../../models/carona.dart';
import '../../services/carona_service.dart';
import '../../utils/colors.dart';
import '../../widgets/card_carona.dart';
import 'detalhes_carona_screen.dart';

class BuscarCaronaScreen extends StatefulWidget {
  const BuscarCaronaScreen({super.key});

  @override
  State<BuscarCaronaScreen> createState() => _BuscarCaronaScreenState();
}

class _BuscarCaronaScreenState extends State<BuscarCaronaScreen> {
  final _service = CaronaService();
  String _filtro = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          "Buscar Caronas",
          style: TextStyle(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            child: TextField(
              onChanged: (value) => setState(() => _filtro = value.trim()),
              decoration: InputDecoration(
                hintText: "Buscar por origem ou destino",
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: AppColors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          Expanded(
            child: StreamBuilder<List<Carona>>(
              stream: _service.listarCaronasDisponiveis(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final caronas = (snapshot.data ?? []).where((carona) {
                  if (_filtro.isEmpty) return true;
                  final texto =
                      "${carona.origem} ${carona.destino}".toLowerCase();
                  return texto.contains(_filtro.toLowerCase());
                }).toList();

                if (caronas.isEmpty) {
                  return const _EstadoVazio();
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: caronas.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final carona = caronas[index];
                    return CardCarona(
                      carona: carona,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                DetalhesCaronaScreen(carona: carona),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EstadoVazio extends StatelessWidget {
  const _EstadoVazio();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.route, size: 54, color: Colors.grey.shade400),
            const SizedBox(height: 12),
            const Text(
              "Nenhuma carona disponivel",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 6),
            Text(
              "Quando alguem publicar uma rota com vagas, ela aparece aqui.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ),
    );
  }
}
