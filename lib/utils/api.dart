import 'dart:convert';
import 'dart:io' show Platform;

import 'package:http/http.dart' as http;

class ServerApi {
  static Future<bool> getReq() async {
    var osUrl="localhost";
    if (Platform.isAndroid) {
      osUrl="10.0.2.2";
    } else if (Platform.isIOS) {
      osUrl="127.0.0.1";
    }

    var url = "http://$osUrl:5000/status";
    http.Response response = await http.Client().get(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
    );
    var res;
    if (response.statusCode == 200) res = json.decode(response.body)['status'];

    print("Server:$res");
    return res;
  }
}
