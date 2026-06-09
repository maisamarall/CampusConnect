import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../services/chat_service.dart';
import '../../utils/colors.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String titulo;

  const ChatScreen({
    super.key,
    this.chatId = 'geral',
    this.titulo = 'Chat',
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _service = ChatService();

  ChatUser get _usuarioAtual {
    final user = FirebaseAuth.instance.currentUser;
    return ChatUser(
      id: user?.uid ?? 'anonimo',
      firstName: user?.displayName ?? user?.email ?? 'Usuario',
    );
  }

  ChatMessage _toChatMessage(Map<String, dynamic> data) {
    final createdAt = DateTime.tryParse(data['createdAt']?.toString() ?? '');
    return ChatMessage(
      user: ChatUser(
        id: data['senderId']?.toString() ?? '',
        firstName: data['senderName']?.toString() ?? 'Usuario',
      ),
      text: data['text']?.toString() ?? '',
      createdAt: createdAt ?? DateTime.now(),
    );
  }

  Future<void> _enviar(ChatMessage message) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null || message.text.trim().isEmpty) return;

    await _service.enviarMensagem(
      chatId: widget.chatId,
      remetenteId: user.uid,
      remetenteNome: user.displayName ?? user.email ?? 'Usuario',
      texto: message.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          widget.titulo.isEmpty ? "Chat" : widget.titulo,
          style: const TextStyle(color: AppColors.primary),
        ),
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _service.mensagens(widget.chatId),
        builder: (context, snapshot) {
          final mensagens = (snapshot.data ?? [])
              .map(_toChatMessage)
              .toList()
              .reversed
              .toList();

          return DashChat(
            currentUser: _usuarioAtual,
            onSend: _enviar,
            messages: mensagens,
            inputOptions: const InputOptions(
              inputDecoration: InputDecoration(
                hintText: "Digite sua mensagem",
                border: OutlineInputBorder(),
              ),
            ),
            messageOptions: const MessageOptions(
              currentUserContainerColor: AppColors.secondary,
              containerColor: AppColors.white,
              textColor: AppColors.primary,
            ),
          );
        },
      ),
    );
  }
}
