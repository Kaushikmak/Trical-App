import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initializeNotifications() async {
    try {
      // Request permission first
      NotificationSettings settings =
          await _firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        // Get the token - add await here
        final fcmToken = await _firebaseMessaging.getToken();
      } else {
        print("Notification permission denied");
      }
    } catch (e) {
      print("Error getting FCM token: $e");
    }
  }
}
