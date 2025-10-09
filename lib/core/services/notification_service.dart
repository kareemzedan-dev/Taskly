import 'dart:convert';
import 'package:http/http.dart' as http;

class NotificationService {
  final String supabaseFunctionUrl =
      "https://bztszvzfcnbfmsxkhkhn.supabase.co/functions/v1/send-notification";

  final String supabaseServiceRoleKey="eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImJ6dHN6dnpmY25iZm1zeGtoa2huIiwicm9sZSI6InNlcnZpY2Vfcm9sZSIsImlhdCI6MTc1NjY2NzU3NywiZXhwIjoyMDcyMjQzNTc3fQ._POj9XngPVg8dL23pkfMVGVt3xdMIVYbSd1XOxFeH1I";


  /// Send notification to a user
  Future<void> sendNotification({
    required String receiverId,
    required String title,
    required String body,
  }) async {
    final url = Uri.parse(supabaseFunctionUrl);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $supabaseServiceRoleKey',
      },
      body: jsonEncode({
        'receiverId': receiverId,
        'title': title,
        'body': body,
      }),
    );

    if (response.statusCode == 200) {
      print('✅ Notification sent successfully: ${response.body}');
    } else {
      print('❌ Failed to send notification: ${response.body}');
    }
  }
}
