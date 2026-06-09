import 'package:firebase_database/firebase_database.dart';

import '../models/carona.dart';

class CaronaService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  Future<void> criarCarona({
    required String motoristaId,
    required String motoristaNome,
    required String origem,
    required String destino,
    required String data,
    required String horario,
    required int vagas,
    String observacoes = '',
  }) async {
    await _db.child("caronas").push().set({
      "motoristaId": motoristaId,
      'motoristaNome': motoristaNome,
      "origem": origem,
      "destino": destino,
      "data": data,
      "horario": horario,
      "vagas": vagas,
      "observacoes": observacoes,
      "status": "disponivel",
      "criadoEm": DateTime.now().toIso8601String(),
    });
  }

  Stream<List<Carona>> listarCaronasDisponiveis() {
    return _db.child("caronas").onValue.map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) return <Carona>[];

      final caronas = value.entries
          .where((entry) => entry.value is Map)
          .map((entry) => Carona.fromMap(entry.key.toString(), entry.value))
          .where((carona) => carona.status == 'disponivel' && carona.vagas > 0)
          .toList();

      caronas.sort((a, b) => a.data.compareTo(b.data));
      return caronas;
    });
  }

  Future<bool> usuarioJaSolicitou({
    required String caronaId,
    required String usuarioId,
  }) async {
    final snapshot = await _db
        .child("solicitacoes")
        .child("${caronaId}_$usuarioId")
        .get();
    return snapshot.exists;
  }

  Future<void> solicitarCarona({
    required Carona carona,
    required String passageiroId,
    required String passageiroNome,
  }) async {
    final solicitacaoId = "${carona.id}_$passageiroId";
    final jaSolicitou = await usuarioJaSolicitou(
      caronaId: carona.id,
      usuarioId: passageiroId,
    );

    if (jaSolicitou) {
      throw Exception("Voce ja solicitou esta carona.");
    }

    await _db.child("solicitacoes").child(solicitacaoId).set({
      "caronaId": carona.id,
      "motoristaId": carona.motoristaId,
      "motoristaNome": carona.motoristaNome,
      "passageiroId": passageiroId,
      "passageiroNome": passageiroNome,
      "origem": carona.origem,
      "destino": carona.destino,
      "data": carona.data,
      "horario": carona.horario,
      "status": "pendente",
      "criadoEm": DateTime.now().toIso8601String(),
    });

    await adicionarEcoPoints(
      usuarioId: passageiroId,
      pontos: 10,
      motivo: "Solicitacao de carona",
    );
  }

  Future<void> adicionarEcoPoints({
    required String usuarioId,
    required int pontos,
    required String motivo,
  }) async {
    final ref = _db.child("ecoPoints").child(usuarioId);
    final snapshot = await ref.get();
    final atual = snapshot.child("total").value;
    final totalAtual = int.tryParse(atual?.toString() ?? '') ?? 0;

    await ref.update({
      "total": totalAtual + pontos,
      "co2EstimadoKg": ((totalAtual + pontos) * 0.18).toStringAsFixed(1),
      "atualizadoEm": DateTime.now().toIso8601String(),
    });

    await ref.child("historico").push().set({
      "pontos": pontos,
      "motivo": motivo,
      "data": DateTime.now().toIso8601String(),
    });
  }

  Stream<Map<String, dynamic>> ecoPointsDoUsuario(String usuarioId) {
    return _db.child("ecoPoints").child(usuarioId).onValue.map((event) {
      final value = event.snapshot.value;
      if (value is! Map) {
        return {"total": 0, "co2EstimadoKg": "0.0"};
      }

      return {
        "total": int.tryParse(value["total"]?.toString() ?? '') ?? 0,
        "co2EstimadoKg": value["co2EstimadoKg"]?.toString() ?? "0.0",
      };
    });
  }
}
