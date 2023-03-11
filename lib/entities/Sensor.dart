class Sensor {
  final int id;
  final int plantId;
  final int temperature;
  final int humidity;
  final String createdAt;

  Sensor({
    required this.id,
    required this.plantId,
    required this.temperature,
    required this.humidity,
    required this.createdAt,
  });

  factory Sensor.fromJson(Map<String, dynamic> json) {
    return Sensor(
      id: json['id'],
      plantId: json['plantId'],
      temperature: json['temperature'],
      humidity: json['humidity'],
      createdAt: json['created_at'],
    );
  }
}
