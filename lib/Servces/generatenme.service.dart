import 'dart:convert';

import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> getRandomUserData() async {
  var request = http.Request('GET', Uri.parse('https://randomuser.me/api/'));

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    Map<String, dynamic> data =
        jsonDecode(await response.stream.bytesToString());
    data['isSuccess'] = true;
    return data;
  } else {
    return {
      'isSuccess': false,
      'message': 'Failed to fetch data from the server',
    };
  }
}
