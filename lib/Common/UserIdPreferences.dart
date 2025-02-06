import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

Future<String> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  String? userId = prefs.getString('userId');

  if (userId == null) {
    // Generate a new UUID and store it
    final uuid = Uuid();
    userId = uuid.v4();
    await prefs.setString('userId', userId);
  }

  return userId;
}
