import 'package:flutter/material.dart';
import '../../services/avaliacao_service.dart';
import '../../utils/colors.dart';

class AvaliacaoScreen extends StatefulWidget {
  final String motoristaId;
  final String motoristaNome;

  const AvaliacaoScreen({
    super.key,
    required this.motoristaId,
    required this.motoristaNome,
  });

  @override
  State<AvaliacaoScreen> createState() => _AvaliacaoScreenState();
}

class _AvaliacaoScreenState extends State<AvaliacaoScreen> {
  int nota = 0;

  final comentarioController = TextEditingController();

  final avaliacaoService = AvaliacaoService();

  Future<void> enviarAvaliacao() async {
    if (nota == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Selecione uma nota antes de enviar.',
          ),
        ),
      );
      return;
    }

    await avaliacaoService.salvarAvaliacao(
      motoristaId: widget.motoristaId,
      avaliadorId: "usuarioLogado",
      nota: nota,
      comentario: comentarioController.text,
    );

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Avaliação enviada com sucesso!',
        ),
      ),
    );

    Navigator.pop(context);
  }

  String textoNota() {
    switch (nota) {
      case 1:
        return "Muito ruim";
      case 2:
        return "Ruim";
      case 3:
        return "Regular";
      case 4:
        return "Boa";
      case 5:
        return "Excelente";
      default:
        return "Selecione uma nota";
    }
  }

  Widget construirEstrelas() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        5,
        (index) => IconButton(
          iconSize: 42,
          onPressed: () {
            setState(() {
              nota = index + 1;
            });
          },
          icon: Icon(
            index < nota ? Icons.star : Icons.star_border,
            color: Colors.amber,
          ),
        ),
      ),
    );
  }

  Widget cardMotorista() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 17, 0, 54).withOpacity(0.05),
            blurRadius: 12,
          )
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              const CircleAvatar(
                radius: 45,
                child: Icon(
                  Icons.person,
                  size: 50,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color.fromARGB(255, 111, 232, 116),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shield,
                    size: 18,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            widget.motoristaNome,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            "Universitário",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 12),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star,
                size: 18,
                color: Colors.amber,
              ),
              SizedBox(width: 4),
              Text(
                "4.9",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 4),
              Text("(128 avaliações)"),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: AppColors.secondary,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  "Motorista confiável",
                  style: TextStyle(
                    color: AppColors.secondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            "Como foi sua viagem?",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          construirEstrelas(),
          const SizedBox(height: 8),
          Text(
            textoNota(),
            style: const TextStyle(
              color: Color.fromARGB(255, 193, 193, 193),
            ),
          ),
        ],
      ),
    );
  }

  Widget cardComentario() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.05),
            blurRadius: 12,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Comentário",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: comentarioController,
            maxLength: 240,
            maxLines: 5,
            decoration: InputDecoration(
              hintText: "Conte como foi sua experiência",
              filled: true,
              fillColor: AppColors.background,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,

      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: const Text(
          "Avaliar Viagem",
          style: TextStyle(
            color: AppColors.primary,
          ),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(
                  Icons.route,
                  color: AppColors.secondary,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  "Viagem concluída • Hoje",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            cardMotorista(),

            const SizedBox(height: 20),

            cardComentario(),

            const SizedBox(height: 20),

            const Center(
              child: Text(
                "Sua avaliação ajuda outros estudantes a escolher motoristas confiáveis.",
                textAlign: TextAlign.center,
              ),
            ),

            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 58,
              child: ElevatedButton.icon(
                onPressed: enviarAvaliacao,
                icon: const Icon(Icons.send),
                label: const Text(
                  "Enviar Avaliação",
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}