class User {
  final String nome;
  final String curso;
  final String ra;
  final String email;

  User({
    required this.nome,
    required this.curso,
    required this.ra,
    required this.email,
  });

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'curso': curso,
      'ra': ra,
      'email': email,
    };
  }
}