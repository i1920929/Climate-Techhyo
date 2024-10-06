import 'package:flutter/material.dart';
import '../models/historia.dart';

class HistoriaCard extends StatelessWidget {
  final Historia historia;

  HistoriaCard({required this.historia});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(historia.texto, style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            ...historia.preguntas
                .map((pregunta) => Text('- $pregunta'))
                .toList(),
          ],
        ),
      ),
    );
  }
}
