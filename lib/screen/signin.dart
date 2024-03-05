import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paytm/screen/signup.dart';
import 'package:paytm/services/auth_services.dart';
import 'package:velocity_x/velocity_x.dart';

final mainColor = Vx.hexToColor("#1f319d");

class SignInPage extends ConsumerWidget {
  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passController = TextEditingController();
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
                    "Welcome Back,",
                    style: TextStyle(fontSize: 35),
                  ),
                ],
              ),

              // heading text
              const Text(
                "Login to your Account",
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

              // textform
              TextFormField(
                controller: passController,
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
                onPressed: () => AuthServices.signinService(
                    usernameController.text, passController.text, context, ref),
                child: const Text(
                  "Sign in",
                  style: TextStyle(color: Colors.white),
                ).pSymmetric(v: 15),
              ).w(context.screenWidth),

              Row(
                children: [
                  const Text("Create account from here: "),
                  TextButton(
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return const SignUpPage();
                      }));
                    },
                    child: Text(
                      "signup",
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
          ).pSymmetric(v: 170, h: 30),
        ),
      ),
    );
  }
}
