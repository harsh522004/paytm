import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import "package:http/http.dart" as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../constant.dart';

class AuthServices {
  static void signupService(String username, String firstname, String lastname,
      String password, BuildContext context) async {
    try {
      final url = Uri.parse(Constant.signUpApi);

      String requestBody = jsonEncode({
        'username': username,
        'firstname': firstname,
        'lastname': lastname,
        'password': password,
      });

      http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestBody);

      if (response.statusCode == 200) {
        print("User Created Succesfully");
      } else {
        print("Something Wrong at Server side");
      }
    } catch (e) {
      print("Error During SignUp : $e");
    }
  }

  static void signinService(String username, String password,
      BuildContext context, WidgetRef ref) async {
    try {
      final requestedBody = jsonEncode({
        'username': username,
        'password': password,
      });

      final url = Uri.parse(Constant.signInApi);

      http.Response response = await http.post(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: requestedBody);

      final jsonBody = response.body;
      final decodedData = jsonDecode(jsonBody);
      final String? token = decodedData['token'];

      if (token != null) {
        SharedPreferences pref = await SharedPreferences.getInstance();
        pref.setString("token", token);

        Navigator.pushNamed(context, '/dashboard');
      } else {
        print('Token is null or not found in response');
      }
    } catch (e) {
      print("Error During signin process $e");
    }
  }
}
