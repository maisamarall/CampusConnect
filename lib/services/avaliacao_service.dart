import 'package:firebase_database/firebase_database.dart';

class AvaliacaoService {
  final DatabaseReference _db =
      FirebaseDatabase.instance.ref("avaliacoes");

  Future<void> salvarAvaliacao({
    required String motoristaId,
    required String avaliadorId,
    required int nota,
    required String comentario,
  }) async {
    await _db.push().set({
      "motoristaId": motoristaId,
      "avaliadorId": avaliadorId,
      "nota": nota,
      "comentario": comentario,
      "data": DateTime.now().toIso8601String(),
    });
  }
}