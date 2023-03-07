class Plant {
  int? id;
  String? name;
  int? optimumTemp;
  int? optimumHum;
  int? sensorId;
  int? userId;
  String? createdAt;

  Plant(
      {this.id,
      this.name,
      this.optimumTemp,
      this.optimumHum,
      this.sensorId,
      this.userId,
      this.createdAt});

  Plant.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    optimumTemp = json['optimum_temp'];
    optimumHum = json['optimum_hum'];
    sensorId = json['sensorId'];
    userId = json['userId'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['optimum_temp'] = this.optimumTemp;
    data['optimum_hum'] = this.optimumHum;
    data['sensorId'] = this.sensorId;
    data['userId'] = this.userId;
    data['created_at'] = this.createdAt;
    return data;
  }
}
