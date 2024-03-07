import 'package:flutter/material.dart';
import 'package:paytm/models/user_model.dart';
import 'package:paytm/widgets/bank_card.dart';
import 'package:paytm/widgets/profile_row.dart';
import 'package:paytm/widgets/user_list.dart';
import 'package:velocity_x/velocity_x.dart';

SingleChildScrollView dashBoardContent(
    BuildContext context,
    UserModel user,
    AccountModel account,
    List<UserModel>? usersList,
    Function sheetOpen,
    Function transferAmount) {
  return SingleChildScrollView(
    child: Column(
      children: [
        // upper part
        Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36)),
            color: Vx.blue400,
          ),
          height: context.screenHeight * 0.48,
          width: context.screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // user Profile Row
              profileRow(user, context, sheetOpen),
              45.heightBox,

              // Credit Card
              bankCard(context, account),
            ],
          ).pOnly(left: 40, top: 30),
        ),

        // list of users
        SizedBox(
          height: context.screenHeight * 0.50,
          child: usersList!.isEmpty
              ? const Text("No User Data!")
              : userList(usersList, account, transferAmount),
        )
      ],
    ),
  );
}
