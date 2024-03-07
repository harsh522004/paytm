// Dailog box for Transfer Amount
import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

Future<dynamic> transferDailog(BuildContext context, Function tansferAmount) {
  TextEditingController balanceController = TextEditingController();
  return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Vx.blue50,
          title: const Text("Transfer Money"),
          content: TextField(
              controller: balanceController,
              decoration: const InputDecoration(hintText: "Enter Balance")),
          actions: <Widget>[
            ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Vx.blue400),
                onPressed: () {
                  double amount = double.tryParse(balanceController.text) ?? 0;
                  tansferAmount(amount);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Send",
                  style: TextStyle(color: Colors.white),
                )).w(100).h(40),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("cancel")),
          ],
        );
      });
}
