import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/carona_service.dart';
import '../../utils/colors.dart';
import '../../widgets/eco_points_card.dart';
import '../avaliacao/avaliacao_screen.dart';
import '../caronas/buscar_carona_screen.dart';
import '../caronas/criar_carona_screen.dart';
import '../chat/chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _caronaService = CaronaService();
  int _indiceAtual = 0;

  @override
  Widget build(BuildContext context) {
    final paginas = [
      _InicioTab(
        service: _caronaService,
        abrirCriar: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CriarCaronaScreen()),
        ),
        abrirBuscar: () => setState(() => _indiceAtual = 1),
        abrirChat: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const ChatScreen()),
        ),
        abrirAvaliacao: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AvaliacaoScreen(
              motoristaId: '',
              motoristaNome: 'Motorista',
            ),
          ),
        ),
      ),
      const BuscarCaronaScreen(),
      _PerfilTab(service: _caronaService),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: paginas[_indiceAtual]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _indiceAtual,
        onTap: (index) => setState(() => _indiceAtual = index),
        selectedItemColor: AppColors.secondary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search_outlined),
            activeIcon: Icon(Icons.search),
            label: "Buscar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person),
            label: "Perfil",
          ),
        ],
      ),
    );
  }
}

class _InicioTab extends StatelessWidget {
  final CaronaService service;
  final VoidCallback abrirCriar;
  final VoidCallback abrirBuscar;
  final VoidCallback abrirChat;
  final VoidCallback abrirAvaliacao;

  const _InicioTab({
    required this.service,
    required this.abrirCriar,
    required this.abrirBuscar,
    required this.abrirChat,
    required this.abrirAvaliacao,
  });

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final nome = user?.displayName?.trim();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Ola${nome == null || nome.isEmpty ? '' : ', $nome'}",
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            "Encontre colegas indo pelo mesmo caminho.",
            style: TextStyle(color: Colors.grey.shade700),
          ),
          const SizedBox(height: 22),
          EcoPointsCard(service: service),
          const SizedBox(height: 22),
          GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 1.12,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _AtalhoCard(
                icon: Icons.add_road,
                titulo: "Criar carona",
                descricao: "Publique seu trajeto",
                onTap: abrirCriar,
              ),
              _AtalhoCard(
                icon: Icons.travel_explore,
                titulo: "Buscar caronas",
                descricao: "Veja vagas abertas",
                onTap: abrirBuscar,
              ),
              _AtalhoCard(
                icon: Icons.chat_bubble_outline,
                titulo: "Solicitacoes",
                descricao: "Acompanhe pelo chat",
                onTap: abrirChat,
              ),
              _AtalhoCard(
                icon: Icons.star_outline,
                titulo: "Avaliar",
                descricao: "Registre a viagem",
                onTap: abrirAvaliacao,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AtalhoCard extends StatelessWidget {
  final IconData icon;
  final String titulo;
  final String descricao;
  final VoidCallback onTap;

  const _AtalhoCard({
    required this.icon,
    required this.titulo,
    required this.descricao,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: AppColors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                backgroundColor: AppColors.secondary.withOpacity(.12),
                child: Icon(icon, color: AppColors.secondary),
              ),
              const Spacer(),
              Text(
                titulo,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 4),
              Text(
                descricao,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PerfilTab extends StatelessWidget {
  final CaronaService service;

  const _PerfilTab({required this.service});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const Text(
          "Perfil",
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w900,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 18),
        Card(
          elevation: 0,
          color: AppColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(user?.displayName?.isNotEmpty == true
                ? user!.displayName!
                : "Universitario"),
            subtitle: Text(user?.email ?? "Usuario logado"),
          ),
        ),
        const SizedBox(height: 14),
        EcoPointsCard(service: service),
        const SizedBox(height: 14),
        OutlinedButton.icon(
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
            if (!context.mounted) return;
            Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
          },
          icon: const Icon(Icons.logout),
          label: const Text("Sair"),
        ),
      ],
    );
  }
}
