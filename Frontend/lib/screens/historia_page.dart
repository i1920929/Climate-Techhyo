import 'package:flutter/material.dart';
import '../services/story_service.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'history_display_screen.dart'; // Importar la nueva pantalla
import '../models/historia.dart';

class StoryScreen extends StatefulWidget {
  @override
  _StoryScreenState createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen> {
  final StoryService _storyService = StoryService();
  String nombres = '';
  String apellidoPaterno = '';
  String apellidoMaterno = '';
  String edad = '';
  String ocupacion = '';
  String idioma = 'es'; // Idioma predeterminado
  String pais = 'ES'; // País predeterminado
  bool isLoading = false;

  Future<void> _generarHistoria() async {
    setState(() {
      isLoading = true;
    });

    try {
      Historia historia =
          await _storyService.generarHistoria(edad, ocupacion, idioma, pais);

      // Navegar a la pantalla de visualización de historia con los datos generados
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              HistoryDisplayScreen(historiaTexto: historia.texto),
        ),
      );
    } catch (e) {
      _showErrorDialog('Error al generar la historia. Inténtalo de nuevo.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

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
      backgroundColor: Colors.grey[200], // Matching background color
      appBar: AppBar(
        title: Text('NASA CLIMATE TECHHYO'),
        backgroundColor: Colors.greenAccent, // Top green bar
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Top Green Section (replicating the registration design)
              Container(
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                padding: EdgeInsets.symmetric(vertical: 30),
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 30,
                      child: Icon(Icons.nature, size: 30, color: Colors.green),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tell Us a climate Story',
                      style: TextStyle(
                        fontSize: 28,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Form Section for input fields
              Expanded(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      TextField(
                        onChanged: (value) => nombres = value,
                        decoration: InputDecoration(
                          labelText: 'Nombres',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) => apellidoPaterno = value,
                        decoration: InputDecoration(
                          labelText: 'Apellido Paterno',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) => apellidoMaterno = value,
                        decoration: InputDecoration(
                          labelText: 'Apellido Materno',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) => edad = value,
                        decoration: InputDecoration(
                          labelText: 'Edad',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                      SizedBox(height: 20),
                      TextField(
                        onChanged: (value) => ocupacion = value,
                        decoration: InputDecoration(
                          labelText: 'Ocupación',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) => idioma = value,
                              decoration: InputDecoration(
                                labelText: 'Idioma',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              onChanged: (value) => pais = value,
                              decoration: InputDecoration(
                                labelText: 'País',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),

                      // Generate Story Button
                      ElevatedButton(
                        onPressed: isLoading ? null : _generarHistoria,
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          backgroundColor: Colors.greenAccent,
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          isLoading ? 'Generando...' : 'Generar Historia',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
