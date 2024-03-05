import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Constant {
  static const String signUpApi =
      "http://192.168.29.54:8080/api/v1/user/signup";

  static const String signInApi =
      "http://192.168.29.54:8080/api/v1/user/signin";

  static const String fetchdataApi =
      "http://192.168.29.54:8080/api/v1/user/userinfo";

  static const String getAlluserApi =
      "http://192.168.29.54:8080/api/v1/user/allUser";
  static showMessage(String message, BuildContext context) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: message.text.make()));
  }
}
