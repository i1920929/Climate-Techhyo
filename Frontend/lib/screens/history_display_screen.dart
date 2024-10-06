import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:http/http.dart' as http; // Para hacer solicitudes HTTP
import 'dart:convert'; // Para manejar respuestas JSON

class HistoryDisplayScreen extends StatefulWidget {
  final String historiaTexto;

  HistoryDisplayScreen({required this.historiaTexto});

  @override
  _HistoryDisplayScreenState createState() => _HistoryDisplayScreenState();
}

class _HistoryDisplayScreenState extends State<HistoryDisplayScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  String? _generatedImageUrl; // URL de la imagen generada
  bool _isGeneratingImage =
      false; // Para manejar el estado de carga de la imagen

  Future<void> _speak() async {
    if (widget.historiaTexto.isNotEmpty) {
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.speak(widget.historiaTexto);
    }
  }

  // Función para generar una imagen usando una API como Cohere
  Future<void> _generateImageFromAPI() async {
    setState(() {
      _isGeneratingImage = true;
    });

    // Aquí debes reemplazar con el endpoint y la clave de tu API de Cohere
    const String apiUrl = "https://api.cohere.ai/v1/generate_image";
    const String apiKey =
        "vM1ZK4IyymBbIgYA7YY2ZaFw3ENgoijS09uOLQjY"; // Inserta tu clave de API aquí

    // Estructura del cuerpo de la solicitudss
    final Map<String, dynamic> requestBody = {
      "prompt":
          widget.historiaTexto, // Usamos el texto de la historia como prompt
      "max_tokens": 50,
      "temperature": 0.5,
      // Otros parámetros según la API de Cohere
    };

    try {
      // Hacer la solicitud POST a la API de Cohere
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $apiKey",
          "Content-Type": "application/json",
        },
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _generatedImageUrl = data[
              'generated_image_url']; // Asume que la respuesta contiene esta clave
        });
      } else {
        _showErrorDialog('Error en la generación de la imagen');
      }
    } catch (e) {
      _showErrorDialog('Error de red al generar la imagen');
    } finally {
      setState(() {
        _isGeneratingImage = false;
      });
    }
  }

  // Mostrar diálogo de error
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Aceptar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Historia Generada'),
        backgroundColor: Colors.greenAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Mostrar el texto de la historia
                    Text(
                      widget.historiaTexto,
                      style: TextStyle(fontSize: 16),
                      textAlign: TextAlign.justify,
                    ),
                    SizedBox(height: 20),

                    // Mostrar imagen generada si existe
                    if (_generatedImageUrl != null)
                      Column(
                        children: [
                          Image.network(
                            _generatedImageUrl!,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Imagen generada para la historia',
                            style: TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    if (_isGeneratingImage)
                      CircularProgressIndicator(), // Indicador de carga mientras se genera la imagen
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Botón para generar una imagen
            ElevatedButton(
              onPressed: _isGeneratingImage ? null : _generateImageFromAPI,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
              ),
              child: Text(
                _isGeneratingImage ? 'Generando imagen...' : 'Generar Imagen',
                style: TextStyle(fontSize: 18),
              ),
            ),

            SizedBox(height: 20),

            // Botón para escuchar la historia
            ElevatedButton(
              onPressed: _speak,
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                backgroundColor: Colors.greenAccent,
                foregroundColor: Colors.white,
              ),
              child: Text(
                'Escuchar Historia',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
