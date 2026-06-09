import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../models/carona.dart';
import '../../services/carona_service.dart';
import '../../utils/colors.dart';
import '../avaliacao/avaliacao_screen.dart';
import '../chat/chat_screen.dart';

class DetalhesCaronaScreen extends StatefulWidget {
  final Carona carona;

  const DetalhesCaronaScreen({
    super.key,
    required this.carona,
  });

  @override
  State<DetalhesCaronaScreen> createState() => _DetalhesCaronaScreenState();
}

class _DetalhesCaronaScreenState extends State<DetalhesCaronaScreen> {
  final _service = CaronaService();
  bool _carregando = false;
  bool _solicitada = false;

  @override
  void initState() {
    super.initState();
    _verificarSolicitacao();
  }

  String get _dataFormatada {
    final data = DateTime.tryParse(widget.carona.data);
    if (data == null) return widget.carona.data;
    return "${data.day.toString().padLeft(2, '0')}/"
        "${data.month.toString().padLeft(2, '0')}/${data.year}";
  }

  Future<void> _verificarSolicitacao() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final jaSolicitou = await _service.usuarioJaSolicitou(
      caronaId: widget.carona.id,
      usuarioId: user.uid,
    );

    if (mounted) {
      setState(() => _solicitada = jaSolicitou);
    }
  }

  Future<void> _solicitarCarona() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Faca login para solicitar carona.")),
      );
      return;
    }

    if (user.uid == widget.carona.motoristaId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Voce e o motorista desta carona.")),
      );
      return;
    }

    setState(() => _carregando = true);

    try {
      await _service.solicitarCarona(
        carona: widget.carona,
        passageiroId: user.uid,
        passageiroNome: user.displayName ?? user.email ?? "Passageiro",
      );

      if (!mounted) return;
      setState(() => _solicitada = true);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Solicitacao registrada!")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceFirst("Exception: ", ""))),
      );
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final chatId = user == null
        ? widget.carona.id
        : "${widget.carona.id}_${user.uid}";

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        title: const Text(
          "Detalhes da Carona",
          style: TextStyle(color: AppColors.primary),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      radius: 26,
                      backgroundColor: Color(0xFFEFF6FF),
                      child: Icon(Icons.person, color: AppColors.secondary),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.carona.motoristaNome.isEmpty
                                ? "Motorista"
                                : widget.carona.motoristaNome,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          Text(
                            "Motorista universitario",
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                    ),
                    if (_solicitada)
                      Chip(
                        label: const Text("Solicitada"),
                        backgroundColor: Colors.green.shade50,
                        labelStyle: TextStyle(color: Colors.green.shade700),
                      ),
                  ],
                ),
                const SizedBox(height: 22),
                _LinhaDetalhe(
                  icon: Icons.location_on_outlined,
                  titulo: "Origem",
                  valor: widget.carona.origem,
                ),
                _LinhaDetalhe(
                  icon: Icons.flag_outlined,
                  titulo: "Destino",
                  valor: widget.carona.destino,
                ),
                _LinhaDetalhe(
                  icon: Icons.calendar_month,
                  titulo: "Data",
                  valor: _dataFormatada,
                ),
                _LinhaDetalhe(
                  icon: Icons.access_time,
                  titulo: "Horario",
                  valor: widget.carona.horario,
                ),
                _LinhaDetalhe(
                  icon: Icons.event_seat,
                  titulo: "Vagas",
                  valor:
                      "${widget.carona.vagas} vaga${widget.carona.vagas == 1 ? '' : 's'}",
                ),
                if (widget.carona.observacoes.isNotEmpty)
                  _LinhaDetalhe(
                    icon: Icons.notes,
                    titulo: "Observacoes",
                    valor: widget.carona.observacoes,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed:
                  _carregando || _solicitada ? null : _solicitarCarona,
              icon: _carregando
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(_solicitada ? Icons.check : Icons.hail),
              label: Text(_solicitada ? "Solicitacao enviada" : "Solicitar carona"),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondary,
                foregroundColor: AppColors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          OutlinedButton.icon(
            onPressed: !_solicitada
                ? null
                : () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChatScreen(
                          chatId: chatId,
                          titulo: widget.carona.motoristaNome,
                        ),
                      ),
                    ),
            icon: const Icon(Icons.chat_bubble_outline),
            label: const Text("Abrir chat"),
          ),
          OutlinedButton.icon(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => AvaliacaoScreen(
                  caronaId: widget.carona.id,
                  motoristaId: widget.carona.motoristaId,
                  motoristaNome: widget.carona.motoristaNome,
                ),
              ),
            ),
            icon: const Icon(Icons.star_outline),
            label: const Text("Avaliar viagem"),
          ),
        ],
      ),
    );
  }
}

class _LinhaDetalhe extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String valor;

  const _LinhaDetalhe({
    required this.icon,
    required this.titulo,
    required this.valor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.secondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  titulo,
                  style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                ),
                const SizedBox(height: 2),
                Text(
                  valor,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
