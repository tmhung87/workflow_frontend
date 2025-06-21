import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:workflow/models/place.dart';

class PlaceApiService {
  static final String _apiUrl =
      'http://146.196.64.84/api/api';


  static Future<String?> _getToken() async {
    final storage = await SharedPreferences.getInstance();
    return storage.getString( 'token');
  }

  static Future<Map<String, dynamic>> getPlaces() async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_apiUrl/place'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> getPlaceById(String id) async {
    final token = await _getToken();
    final response = await http.get(
      Uri.parse('$_apiUrl/place/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> createPlace({
    required Place place,
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$_apiUrl/place'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(place.toJson()),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> updatePlace(Place place) async {
    final token = await _getToken();
    final response = await http.put(
      Uri.parse('$_apiUrl/place/${place.id}'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(place.toJson()),
    );
    return jsonDecode(response.body);
  }

  static Future<Map<String, dynamic>> deletePlace(int id) async {
    final token = await _getToken();
    final response = await http.delete(
      Uri.parse('$_apiUrl/place/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    return jsonDecode(response.body);
  }

  static Future<List<Place>> findPlace({
    String? division,
    String? department,
  }) async {
    final token = await _getToken();
    final response = await http.post(
      Uri.parse('$_apiUrl/place/find'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({'division': division, 'department': department}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      List<dynamic> list = data['places'] ?? data['result'] ?? data;
      print(list);

      return list.map((e) => Place.fromJson(e)).toList();
    } else {
      throw Exception("Failed to find places");
    }
  }
}
