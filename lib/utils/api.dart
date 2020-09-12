import 'dart:convert';

import 'package:http/http.dart' as http;
class ServerApi{

  static Future<String> getReq() async{

    var url="http://10.0.2.2:5000/status";
    http.Response response= await http.Client().get(url,headers: {
        'Content-Type': 'application/json',
      },);
    var res;
    if(response.statusCode==200)
      res=json.decode(response.body)['status'];

    print(res);

  }
}