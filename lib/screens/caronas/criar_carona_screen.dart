import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../services/carona_service.dart';

import '../../utils/colors.dart';

class CriarCaronaScreen extends StatefulWidget {
  const CriarCaronaScreen({super.key});

  @override
  State<CriarCaronaScreen> createState() => _CriarCaronaScreenState();
}

class _CriarCaronaScreenState extends State<CriarCaronaScreen> {
  final _origemController = TextEditingController();
  final _destinoController = TextEditingController();

  final CaronaService _caronaService = CaronaService();

  DateTime? _dataSelecionada;
  TimeOfDay? _horarioSelecionado;

  int vagas = 1;
  bool carregando = false;

  Future<void> selecionarData() async {
    final data = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
    );

    if (data != null) {
      setState(() {
        _dataSelecionada = data;
      });
    }
  }

  Future<void> selecionarHorario() async {
    final horario = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (horario != null) {
      setState(() {
        _horarioSelecionado = horario;
      });
    }
  }

  Future<void> publicarCarona() async {
    if (_origemController.text.isEmpty ||
        _destinoController.text.isEmpty ||
        _dataSelecionada == null ||
        _horarioSelecionado == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos'),
        ),
      );
      return;
    }

    setState(() {
      carregando = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception("Usuário não autenticado");
      }

      await _caronaService.criarCarona(
        motoristaId: user.uid,
        motoristaNome: user.displayName ?? '',
        origem: _origemController.text.trim(),
        destino: _destinoController.text.trim(),
        data: _dataSelecionada!.toIso8601String(),
        horario: _horarioSelecionado!.format(context),
        vagas: vagas,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Carona criada com sucesso!'),
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro: $e'),
        ),
      );
    }

    setState(() {
      carregando = false;
    });
  }

  Widget campo({
    required IconData icon,
    required String hint,
    required TextEditingController controller,
  }) {
    return Container(
      height: 76,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: TextField(
        controller: controller,
        onChanged: (_) => setState(() {}),
        decoration: InputDecoration(
          border: InputBorder.none,
          hintText: hint,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 26,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.secondary,
            ),
          ),
        ),
      ),
    );
  }

  String get dataTexto {
    if (_dataSelecionada == null) {
      return "--";
    }

    return "${_dataSelecionada!.day.toString().padLeft(2, '0')}/"
        "${_dataSelecionada!.month.toString().padLeft(2, '0')}/"
        "${_dataSelecionada!.year}";
  }

  String get horarioTexto {
    if (_horarioSelecionado == null) {
      return "--";
    }

    return _horarioSelecionado!.format(context);
  }

  @override
  void dispose() {
    _origemController.dispose();
    _destinoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColors.background,
        centerTitle: true,
        title: const Text(
          "Criar Carona",
          style: TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            campo(
              icon: Icons.location_on_outlined,
              hint: "Digite o local de saída",
              controller: _origemController,
            ),

            const SizedBox(height: 16),

            campo(
              icon: Icons.flag_outlined,
              hint: "Digite o destino",
              controller: _destinoController,
            ),

            const SizedBox(height: 20),

            Row(
              children: [

                Expanded(
                  child: GestureDetector(
                    onTap: selecionarData,
                    child: Container(
                      height: 76,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [

                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(.10),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.calendar_month,
                              color: AppColors.secondary,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              dataTexto,
                              style: const TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: GestureDetector(
                    onTap: selecionarHorario,
                    child: Container(
                      height: 76,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                      ),
                      child: Row(
                        children: [

                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColors.secondary.withOpacity(.10),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.access_time,
                              color: AppColors.secondary,
                            ),
                          ),

                          const SizedBox(width: 10),

                          Expanded(
                            child: Text(
                              horarioTexto,
                              style: const TextStyle(fontSize: 16),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                children: [

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "VAGAS DISPONÍVEIS",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Quantos passageiros cabem?",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [

                      IconButton(
                        onPressed: () {
                          if (vagas > 1) {
                            setState(() {
                              vagas--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),

                      Text(
                        vagas.toString(),
                        style: const TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      IconButton(
                        onPressed: () {
                          setState(() {
                            vagas++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  )
                ],
              ),
            ),

            const SizedBox(height: 24),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [

                  const Text(
                    "Resumo da carona",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),

                  const SizedBox(height: 20),

                  _itemResumo(
                    "📍",
                    "Origem",
                    _origemController.text.isEmpty
                        ? "--"
                        : _origemController.text,
                  ),

                  _itemResumo(
                    "🏁",
                    "Destino",
                    _destinoController.text.isEmpty
                        ? "--"
                        : _destinoController.text,
                  ),

                  _itemResumo(
                    "📅",
                    "Data",
                    dataTexto,
                  ),

                  _itemResumo(
                    "🕒",
                    "Horário",
                    horarioTexto,
                  ),

                  _itemResumo(
                    "👥",
                    "Vagas",
                    "$vagas vaga${vagas > 1 ? 's' : ''}",
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                onPressed:
                    carregando ? null : publicarCarona,
                icon: carregando
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.directions_car),

                label: const Text(
                  "Publicar Carona",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.secondary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemResumo(
    String emoji,
    String titulo,
    String valor,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [

          Text(
            emoji,
            style: const TextStyle(fontSize: 18),
          ),

          const SizedBox(width: 10),

          Text(
            titulo,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),

          const Spacer(),

          Text(
            valor,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}