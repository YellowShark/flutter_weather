import 'dart:convert';
import 'package:http/http.dart' as http;

class FetchHelper {
  final String url;
  FetchHelper(this.url);

  Future<dynamic> getData() async {
    print('Request...');
    http.Response response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      print('Response:\n$body');
      return body;
    } else {
      print(response.statusCode);
    }
  }
}
