import 'package:firebase_database/firebase_database.dart';

class CaronaService {

  final DatabaseReference _db =
      FirebaseDatabase.instance.ref();

  Future<void> criarCarona({
    required String motoristaId,
    required String motoristaNome,
    required String origem,
    required String destino,
    required String data,
    required String horario,
    required int vagas,
  }) async {

    await _db.child("caronas").push().set({
      "motoristaId": motoristaId,
      'motoristaNome': motoristaNome,
      "origem": origem,
      "destino": destino,
      "data": data,
      "horario": horario,
      "vagas": vagas,
      "criadoEm": DateTime.now().toIso8601String(),
    });
  }
}