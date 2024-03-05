import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paytm/screen/signin.dart';
import 'package:paytm/services/auth_services.dart';
import 'package:velocity_x/velocity_x.dart';

final mainColor = Vx.hexToColor("#1f319d");

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final usernameController = TextEditingController();
    final firstnameController = TextEditingController();
    final lastnameController = TextEditingController();
    final passwordController = TextEditingController();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // logo

              Row(
                children: [
                  Icon(
                    Icons.face_retouching_natural_sharp,
                    size: 40,
                    color: mainColor,
                  ),
                  10.widthBox,
                  const Text(
                    "Welcome",
                    style: TextStyle(fontSize: 35),
                  ),
                ],
              ),

              // heading text
              const Text(
                "Create your Account here",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Vx.gray400),
              ),

              // textform
              TextFormField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: 'Enter your username...',
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.account_circle_outlined,
                    color: mainColor,
                  ),
                ),
              ).py(10),

              //textfrom
              TextFormField(
                controller: firstnameController,
                decoration: InputDecoration(
                  hintText: 'Enter your firstname...',
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(),
                  prefixIcon: Icon(
                    CupertinoIcons.pencil,
                    color: mainColor,
                  ),
                ),
              ).py(10),

              // textform
              TextFormField(
                controller: lastnameController,
                decoration: InputDecoration(
                  hintText: 'Enter your lastname...',
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(),
                  prefixIcon: Icon(
                    CupertinoIcons.pencil,
                    color: mainColor,
                  ),
                ),
              ).py(10),

              // textform
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Enter your password...',
                  enabledBorder: const OutlineInputBorder(),
                  focusedBorder: const OutlineInputBorder(),
                  prefixIcon: Icon(
                    Icons.key,
                    color: mainColor,
                  ),
                ),
                obscureText: true,
              ).py(10),

              const SizedBox(
                height: 30,
              ),

              // elevated button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  backgroundColor: mainColor,
                ),
                onPressed: () => AuthServices.signupService(
                    usernameController.text,
                    firstnameController.text,
                    lastnameController.text,
                    passwordController.text,
                    context),
                child: const Text(
                  "Sign up",
                  style: TextStyle(color: Colors.white),
                ).pSymmetric(v: 15),
              ).w(context.screenWidth),
              Row(
                children: [
                  const Text("Already have an account?"),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SignInPage();
                      }));
                    },
                    child: Text(
                      "signin",
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: mainColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ).pSymmetric(h: 50),
            ],
          ).pSymmetric(v: 80, h: 30),
        ),
      ),
    );
  }
}
