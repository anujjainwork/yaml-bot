import 'dart:convert';
import 'package:http/http.dart' as http;

class PubDevClient {
  Future<String?> getLatestVersion(String packageName) async {
    final url = Uri.parse('https://pub.dev/api/packages/$packageName');

    final response = await http.get(url);

    if (response.statusCode != 200) {
      return null;
    }

    final json = jsonDecode(response.body);
    return json['latest']['version'] as String?;
  }
}