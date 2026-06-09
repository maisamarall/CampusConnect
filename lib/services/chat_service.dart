import 'package:firebase_database/firebase_database.dart';

class ChatService {
  final DatabaseReference _db = FirebaseDatabase.instance.ref();

  String chatId({
    required String caronaId,
    required String passageiroId,
  }) {
    return "${caronaId}_$passageiroId";
  }

  Stream<List<Map<String, dynamic>>> mensagens(String chatId) {
    return _db
        .child("chats")
        .child(chatId)
        .child("mensagens")
        .orderByChild("createdAt")
        .onValue
        .map((event) {
      final value = event.snapshot.value;
      if (value == null || value is! Map) return <Map<String, dynamic>>[];

      final mensagens = value.entries
          .where((entry) => entry.value is Map)
          .map((entry) {
            final data = Map<String, dynamic>.from(entry.value as Map);
            data["id"] = entry.key.toString();
            return data;
          })
          .toList();

      mensagens.sort(
        (a, b) => (a["createdAt"] ?? '').toString().compareTo(
          (b["createdAt"] ?? '').toString(),
        ),
      );
      return mensagens;
    });
  }

  Future<void> enviarMensagem({
    required String chatId,
    required String remetenteId,
    required String remetenteNome,
    required String texto,
  }) async {
    final agora = DateTime.now().toIso8601String();

    await _db.child("chats").child(chatId).update({
      "ultimaMensagem": texto,
      "atualizadoEm": agora,
    });

    await _db.child("chats").child(chatId).child("mensagens").push().set({
      "senderId": remetenteId,
      "senderName": remetenteNome,
      "text": texto,
      "createdAt": agora,
    });
  }
}
