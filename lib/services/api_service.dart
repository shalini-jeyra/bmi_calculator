
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class ApiService{


   Future getService(
  
  ) async {
  
    final response = await http.get(
      Uri.parse(
          'http://randomuser.me/api/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
       
      },
    );
  print(response.statusCode);
 if (response.statusCode == 200) {
 
 var jsonResponse =
          convert.jsonDecode(response.body) as Map<String, dynamic>;
          print(jsonResponse['results']);
          return jsonResponse['results'];
 }else{
print('Failed to load top albums');
 }
  }
}