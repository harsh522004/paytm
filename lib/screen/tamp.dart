import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class Tamp extends StatefulWidget {
  const Tamp({super.key});

  @override
  State<Tamp> createState() => _TampState();
}

class _TampState extends State<Tamp> {
  @override
  Widget build(BuildContext context) {
    TextEditingController tamp = TextEditingController();
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () {},
          child: const Text("Press"),
        ),
      ),
    );
  }
}
