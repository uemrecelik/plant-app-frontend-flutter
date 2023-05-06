class Plant {
  final int id;
  final String name;
  final int optimumTemp;
  final int optimumHum;
  final int sensorId;
  final String imageUrl;
  final int userId;
  final DateTime createdAt;
  final String description;
  final String position;
  bool isCritical;

  Plant({
    required this.id,
    required this.name,
    required this.optimumTemp,
    required this.optimumHum,
    required this.sensorId,
    required this.imageUrl,
    required this.userId,
    required this.createdAt,
    required this.description,
    required this.position,
    this.isCritical = false,
  });

  factory Plant.fromJson(Map<String, dynamic> json) {
    return Plant(
        id: json['id'],
        name: json['name'],
        optimumTemp: json['optimum_temp'],
        optimumHum: json['optimum_hum'],
        sensorId: json['sensorId'],
        imageUrl: json['imageUrl'],
        userId: json['userId'],
        createdAt: DateTime.parse(json['created_at']),
        description: json['description'],
        position: json['position']);
  }
}
