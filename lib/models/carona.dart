class Carona {
  final String id;
  final String motoristaId;
  final String motoristaNome;
  final String origem;
  final String destino;
  final String data;
  final String horario;
  final int vagas;
  final String observacoes;
  final String status;
  final String criadoEm;

  const Carona({
    required this.id,
    required this.motoristaId,
    required this.motoristaNome,
    required this.origem,
    required this.destino,
    required this.data,
    required this.horario,
    required this.vagas,
    required this.observacoes,
    required this.status,
    required this.criadoEm,
  });

  factory Carona.fromMap(String id, Map<dynamic, dynamic> map) {
    return Carona(
      id: id,
      motoristaId: map['motoristaId']?.toString() ?? '',
      motoristaNome: map['motoristaNome']?.toString() ?? 'Motorista',
      origem: map['origem']?.toString() ?? '',
      destino: map['destino']?.toString() ?? '',
      data: map['data']?.toString() ?? '',
      horario: map['horario']?.toString() ?? '',
      vagas: int.tryParse(map['vagas']?.toString() ?? '') ?? 0,
      observacoes: map['observacoes']?.toString() ?? '',
      status: map['status']?.toString() ?? 'disponivel',
      criadoEm: map['criadoEm']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'motoristaId': motoristaId,
      'motoristaNome': motoristaNome,
      'origem': origem,
      'destino': destino,
      'data': data,
      'horario': horario,
      'vagas': vagas,
      'observacoes': observacoes,
      'status': status,
      'criadoEm': criadoEm,
    };
  }
}
