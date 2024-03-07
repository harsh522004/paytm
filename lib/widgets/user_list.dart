import 'package:flutter/material.dart';
import 'package:paytm/models/user_model.dart';
import 'package:paytm/widgets/transfer_amount_dailog.dart';
import 'package:velocity_x/velocity_x.dart';

ListView userList(
    List<UserModel> usersList, AccountModel account, Function transferAmount) {
  return ListView.builder(
      itemCount: usersList.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(),
          title: Text(
            usersList[index].username,
            style: const TextStyle(fontSize: 18),
          ),
          trailing: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Vx.blue600),
              onPressed: () {
                transferDailog(context, (double amount) {
                  transferAmount(usersList[index].id, amount, account.balance);
                });
                // transferAmount(usersList[index].id, 100,
                //     account.balance);
              },
              child: const Text(
                "Transfer",
                style: TextStyle(color: Colors.white),
              )).w(100).h(40),
        ).pOnly(top: 10);
      });
}
