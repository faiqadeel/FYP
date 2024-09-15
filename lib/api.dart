import 'dart:convert';

import 'package:http/http.dart' as http;

const String baseUrl =
    'https://api.openrouteservice.org/v2/directions/driving-car';
const String apiKey =
    '5b3ce3597851110001cf624815b2c01bbff44a0ca627b05c9f7cb013';

getRouteUrl(String startPoint, String endPoint) {
  return Uri.parse("$baseUrl?api_key=$apiKey&start=$startPoint&end=$endPoint");
}

Future<double> getDistance(
    double startLat, double startLng, double endLat, double endLng) async {
  final String url =
      'https://api.openrouteservice.org/v2/directions/driving-car';
  final Map<String, String> queryParams = {
    'api_key': apiKey,
    'start': '$startLng,$startLat',
    'end': '$endLng,$endLat',
  };

  final uri = Uri.parse(url).replace(queryParameters: queryParams);
  final response = await http.get(uri);

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    final distance = data['routes'][0]['summary']['distance'];
    return distance / 1000.0; // Convert meters to kilometers
  } else {
    throw Exception('Failed to load distance: ${response.reasonPhrase}');
  }
}
