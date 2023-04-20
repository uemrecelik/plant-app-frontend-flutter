class GraphData {
  final double? temperature;
  final double? humidity;
  final String date;

  GraphData({
    this.temperature,
    this.humidity,
    required this.date,
  });

  factory GraphData.fromJson(Map<String, dynamic> json) {
    return GraphData(
      temperature: (json['temperature'] ?? 0).toDouble(),
      humidity: (json['humidity'] ?? 0).toDouble(),
      date: json['date'],
    );
  }
}
