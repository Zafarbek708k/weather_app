import 'dart:convert';

Map<String, double> weatherFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, double>(k, v.toDouble()));
String weatherToJson(Map<String, double> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, v)));

 WeatherModel weatherModelFromJson(String str) => WeatherModel.fromJson(json.decode(str));
// String weatherModelToJson(WeatherModel data) => json.encode(data.toJson());


class WeatherModel {
  late double windSpeed;
  late int windDegrees;
  late int temp;
  late int humidity;
  late int sunset;
  late int minTemp;
  late int cloudPct;
  late int feelsLike;
  late int sunrise;
  late int maxTemp;

  WeatherModel({
    required this.windSpeed,
    required this.windDegrees,
    required this.temp,
    required this.humidity,
    required this.sunset,
    required this.minTemp,
    required this.cloudPct,
    required this.feelsLike,
    required this.sunrise,
    required this.maxTemp,
  });

  // Factory constructor to create a WeatherModel instance from a JSON object
  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      windSpeed: json['wind_speed'],
      windDegrees: json['wind_degrees'],
      temp: json['temp'],
      humidity: json['humidity'],
      sunset: json['sunset'],
      minTemp: json['min_temp'],
      cloudPct: json['cloud_pct'],
      feelsLike: json['feels_like'],
      sunrise: json['sunrise'],
      maxTemp: json['max_temp'],
    );
  }

  // Method to convert WeatherModel instance to a JSON object
  Map<String, dynamic> toJson() {
    return {
      'wind_speed': windSpeed,
      'wind_degrees': windDegrees,
      'temp': temp,
      'humidity': humidity,
      'sunset': sunset,
      'min_temp': minTemp,
      'cloud_pct': cloudPct,
      'feels_like': feelsLike,
      'sunrise': sunrise,
      'max_temp': maxTemp,
    };
  }
}
