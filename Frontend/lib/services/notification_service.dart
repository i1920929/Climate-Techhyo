import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> setupFirebase() async {
    _firebaseMessaging.requestPermission();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        print('Notificación recibida: ${message.notification!.title}');
      }
    });
  }

  Future<void> enviarNotificacion(String token, String message) async {
    // Implementa la lógica para enviar notificaciones
  }
}
