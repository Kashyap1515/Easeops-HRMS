import 'package:easeops_web_hrms/app_export.dart';
import 'package:http/http.dart' as http;

class NetworkUtility {
  static Future<http.Response?> fetchUrl(
    Uri uri, {
    Map<String, String>? headers,
  }) async {
    try {
      final response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        return response;
      }
    } catch (e) {
      Logger.log(e.toString());
    }
    return null;
  }
}
