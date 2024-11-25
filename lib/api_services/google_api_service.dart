import 'dart:convert';
import 'dart:io';
import 'package:googleapis/gmail/v1.dart' as gmail;
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart';

void main() async {
  // Thông tin Client ID và Secret lấy từ Google Cloud Console
  const _clientId = 'YOUR_CLIENT_ID.apps.googleusercontent.com';
  const _clientSecret = 'YOUR_CLIENT_SECRET';

  final clientId = ClientId(_clientId, _clientSecret);
  final scopes = [gmail.GmailApi.gmailReadonlyScope];

  await clientViaUserConsent(clientId, scopes, (url) {
    print('Hãy mở đường dẫn này trên trình duyệt: $url');
  }).then((authClient) async {
    var gmailApi = gmail.GmailApi(authClient);

    // Lấy danh sách email
    var messages = await gmailApi.users.messages.list('me');
    if (messages.messages != null) {
      for (var message in messages.messages!) {
        var email = await gmailApi.users.messages.get('me', message.id!);
        print(email.snippet);
      }
    }

    authClient.close();
  });
}

// Future<AuthClient> authenticateWithToken() async {
//   final prefs = await SharedPreferences.getInstance();
//   final storedToken = prefs.getString('oauth_token');
  
//   if (storedToken != null) {
//     final token = AccessCredentials.fromJson(jsonDecode(storedToken));
//     final clientId = ClientId('YOUR_CLIENT_ID', 'YOUR_CLIENT_SECRET');
//     return authenticatedClient(Client(), token);
//   } else {
//     final authClient = await authenticate();
//     final credentials = await authClient.credentials;
//     prefs.setString('oauth_token', jsonEncode(credentials.toJson()));
//     return authClient;
//   }
// }

Future<void> sendEmail(AuthClient authClient) async {
  final gmailApi = gmail.GmailApi(authClient);

  final message = Message()
    ..raw = base64UrlEncode(utf8.encode(
        'From: your_email@gmail.com\nTo: recipient@gmail.com\nSubject: Test Email\n\nHello from Flutter!'));

  await gmailApi.users.messages.send(message, 'me');
  print('Email đã được gửi.');
}
