import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:paytm/models/user_model.dart';
import 'package:velocity_x/velocity_x.dart';

Row profileRow(UserModel user, BuildContext context, Function sheetOpen) {
  return Row(
    children: [
      Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            image: const DecorationImage(
              image: NetworkImage(
                  "https://img.freepik.com/premium-vector/woman-profile-cartoon_18591-58477.jpg"),
            ),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.white)),
      ),
      20.widthBox,
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Good Moring",
            style: TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            user.username,
            style: const TextStyle(color: Colors.white, fontSize: 15),
          ),
        ],
      ),
      const Spacer(),
      IconButton(
          onPressed: () {
            sheetOpen(context);
          },
          icon: const Icon(
            CupertinoIcons.settings,
            size: 27,
            color: Vx.blue900,
          )).pOnly(right: 30),
    ],
  );
}
