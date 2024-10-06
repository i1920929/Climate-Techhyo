import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/historia.dart';

class StoryService {
  final String apiUrl = "http://127.0.0.1:8000/api/generar-historia/";

  Future<Historia> generarHistoria(
      String edad, String ocupacion, String idioma, String pais) async {
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'edad': edad,
        'ocupacion': ocupacion,
        'idioma': idioma,
        'pais': pais
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Historia(
        texto: data['texto'],
        preguntas: List<String>.from(data['preguntas']),
      );
    } else {
      throw Exception('Error al generar historia');
    }
  }
}
