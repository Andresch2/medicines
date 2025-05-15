class Medication {
  final String id;
  final String name;
  final String dosage;
  final DateTime time;
  final String userId;
  String status;

  Medication({
    required this.id,
    required this.name,
    required this.dosage,
    required this.time,
    required this.userId,
    this.status = 'pendiente',
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'dosage': dosage,
      'time': time.toIso8601String(),
      'userId': userId,
      'status': status,
    };
  }

  factory Medication.fromJson(Map<String, dynamic> json) {
    return Medication(
      id: json['\$id'],
      name: json['name'],
      dosage: json['dosage'],
      time: DateTime.parse(json['time']),
      userId: json['userId'],
      status: json['status'] ?? 'pendiente',
    );
  }
}
