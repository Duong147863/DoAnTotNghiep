import 'package:http/http.dart' as http;

class AbsentsServices {
  Future<http.Response> getAbsentsList() {
    return http.get(Uri());
  }
}
