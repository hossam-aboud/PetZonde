import 'dart:convert';

import 'package:http/http.dart' as http;
class Mail{

  Future sendEmail({
    required String subject,
    required String message,
    required String name,
    required String email,
  }) async{
    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(url,
        headers: {
      'origin': 'http://localhost',
      'Content-Type': 'application/json'},
     body: json.encode({
       "user_id": "user_DTBTUCPvyQaEiGjLbbwna",
       "service_id": "service_3b84cs9",
       "template_id": "template_z26bjd2",
       "template_params": {
         'subject': subject,
         'message': message,
         'to_name': name,
         'to_email': email
       }
     })

    );

    print(response.body);
  }


}