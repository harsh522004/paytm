import 'package:flutter/material.dart';
import 'package:paytm/models/user_model.dart';
import 'package:velocity_x/velocity_x.dart';

Container bankCard(BuildContext context, AccountModel account) {
  return Container(
    height: context.screenHeight * 0.25,
    width: context.screenWidth * 0.80,
    decoration: const BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(
        Radius.circular(16),
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "INR BALANCE",
              style: TextStyle(color: Vx.gray400),
            ),
            Text(
              "ICICIbank",
              style: TextStyle(fontWeight: FontWeight.bold, color: Vx.blue800),
            ),
          ],
        ),
        Text(
          "₹${account.balance.toStringAsFixed(2)}",
          style: const TextStyle(
              color: Colors.black, fontSize: 30, fontWeight: FontWeight.w500),
        ),
        10.heightBox,
        const Text(
          "****     ****     ****     5132",
          style: TextStyle(fontSize: 20, color: Vx.gray600),
        ),
        Image.network(
          "https://www.freepnglogos.com/uploads/mastercard-png/mastercard-logo-mastercard-logo-png-vector-download-19.png",
          scale: 1,
        ).h(70).w(100),
      ],
    ).p(14),
  );
}
