import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:paytm/constant.dart';
import 'package:paytm/models/user_model.dart';
import 'package:paytm/providers/user_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:velocity_x/velocity_x.dart';

class DashBoardPage extends ConsumerStatefulWidget {
  const DashBoardPage({super.key});

  @override
  ConsumerState<DashBoardPage> createState() => _DashBoardPageState();
}

class _DashBoardPageState extends ConsumerState<DashBoardPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserData();
    fetchUserList();
  }

  void fetchUserData() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString("token");

      if (token != null) {
        final url = Uri.parse(Constant.fetchdataApi);
        http.Response res = await http.get(
          url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'authorization': "barrer $token"
          },
        );

        if (res.statusCode == 200) {
          final Map<String, dynamic> responseData = jsonDecode(res.body);

          final UserModel user = UserModel(
            id: responseData['userData']['_id'] ?? "",
            username: responseData['userData']['username'] ?? "",
            firstname: responseData['userData']['firstname'] ?? "",
            lastname: responseData['userData']['lastname'] ?? "",
            password: responseData['userData']['password'] ?? "",
          );

          final AccountModel account = AccountModel(
            id: responseData['accountData']['_id'] ?? "",
            userId: responseData['accountData']['userId'] ?? "",
            balance: responseData['accountData']['balance'] ??
                0.0, // or any default value you prefer
          );

          setState(() {
            ref.read(userDataProvider.notifier).state = user;
            ref.read(accountDataProvider.notifier).state = account;
          });
        } else {
          Constant.showMessage("Error during fetch", context);
        }
      }
    } catch (e) {
      print("error during fetching process : $e");
    }
  }

  void fetchUserList() async {
    try {
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');
      final url = Uri.parse(Constant.getAlluserApi);
      http.Response res = await http.get(url, headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'authorization': "barrer $token"
      });
      if (res.statusCode == 200) {
        // decode response
        final responseData = jsonDecode(res.body);
        final List<dynamic> userList = responseData['userlist'];

        final List<UserModel> usermodelList = userList
            .map((user) => UserModel.fromMap(user as Map<String, dynamic>))
            .toList();
        setState(() {
          ref.read(userListProvider.notifier).state = usermodelList;
        });
      } else {
        Constant.showMessage("Error during fetching", context);
      }
    } catch (e) {
      print("Error During fetching users list process : $e");
    }
  }

  Future<dynamic> sheetOpen(
    BuildContext context,
  ) {
    TextEditingController textcontrol = TextEditingController();

    // set dropDown value
    String dropdownValue = 'username';

    // botttom sheet
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return SizedBox(
              height: 400,
              width: MediaQuery.of(context).size.width,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(CupertinoIcons.settings),
                      20.widthBox,
                      const Text(
                        "Settings",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  10.heightBox,

                  // drop down container
                  Container(
                    decoration: BoxDecoration(
                        color: Vx.blue200,
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(10)),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        dropdownColor: Vx.blue100,
                        icon: const Icon(CupertinoIcons.chevron_down_circle)
                            .pOnly(top: 6),
                        iconSize: 22,
                        isDense: true,
                        isExpanded: true,
                        value: dropdownValue,
                        items: const [
                          DropdownMenuItem<String>(
                              value: "username",
                              child: Text(
                                "Username",
                              )),
                          DropdownMenuItem<String>(
                              value: "firstname",
                              child: Text(
                                "Firstname",
                              )),
                          DropdownMenuItem<String>(
                              value: "password",
                              child: Text(
                                "Password",
                              )),
                        ],
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue =
                                newValue!; // Update dropdownValue when the user selects a new value
                          });
                        },
                      ).pOnly(bottom: 15, top: 10, left: 10, right: 10),
                    ),
                  ),
                  10.heightBox,
                  TextFormField(
                    controller: textcontrol,
                    decoration: const InputDecoration(
                        enabledBorder: OutlineInputBorder(),
                        hintText: "Enter You Change"),
                  ),
                  10.heightBox,
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          elevation: 10,
                          backgroundColor: Vx.blue200,
                          shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)))),
                      onPressed: () {
                        updateData(dropdownValue, textcontrol.text, context,
                            ref, fetchUserData);
                      },
                      child: const Text(
                        "make change",
                        style: TextStyle(color: Colors.black),
                      ))
                ],
              ).p(24),
            );
          },
        );
      },
    );
  }

  void transferAmount(
      String userId, double amount, double currentAmount) async {
    try {
      if (amount <= currentAmount) {
        // get token from local
        SharedPreferences pref = await SharedPreferences.getInstance();
        String? token = pref.getString('token');

        // hit the endpoint
        final url = Uri.parse(Constant.transferAmountApi);
        final requestedBody = jsonEncode({"to": userId, "amount": amount});
        http.Response res = await http.post(url,
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'authorization': "barrer $token",
            },
            body: requestedBody);

        // success case
        if (res.statusCode == 200) {
          final AccountModel? currentAcountModel =
              ref.read(accountDataProvider.notifier).state;
          if (currentAcountModel != null) {
            final AccountModel newAcountModel = AccountModel(
                id: currentAcountModel.id,
                userId: currentAcountModel.userId,
                balance: currentAcountModel.balance - amount);
            setState(() {
              ref.read(accountDataProvider.notifier).state = newAcountModel;
            });

            Constant.showMessage("Transfer Succesfully", context);
          } else {
            print("Account Model Null");
          }
        }
      } else {
        Constant.showMessage("Not Enough Amount", context);
      }
    } catch (e) {
      Constant.showMessage("Server Error occur", context);
      print("Error getting from catch : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userDataProvider.notifier).state;
    final account = ref.watch(accountDataProvider.notifier).state;
    final usersList = ref.watch(userListProvider.notifier).state;

    return SafeArea(
      child: Scaffold(
        body: (user != null && account != null)
            ? SingleChildScrollView(
                child: Column(
                  children: [
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
                          Row(
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
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    user.username,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 15),
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
                          ),
                          45.heightBox,
                          Container(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "INR BALANCE",
                                      style: TextStyle(color: Vx.gray400),
                                    ),
                                    Text(
                                      "ICICIbank",
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Vx.blue800),
                                    ),
                                  ],
                                ),
                                Text(
                                  "₹${account.balance.toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w500),
                                ),
                                10.heightBox,
                                const Text(
                                  "****     ****     ****     5132",
                                  style: TextStyle(
                                      fontSize: 20, color: Vx.gray600),
                                ),
                                Image.network(
                                  "https://www.freepnglogos.com/uploads/mastercard-png/mastercard-logo-mastercard-logo-png-vector-download-19.png",
                                  scale: 1,
                                ).h(70).w(100),
                              ],
                            ).p(14),
                          ),
                        ],
                      ).pOnly(left: 40, top: 30),
                    ),
                    SizedBox(
                      height: context.screenHeight * 0.50,
                      child: usersList!.isEmpty
                          ? const Text("No User Data!")
                          : ListView.builder(
                              itemCount: usersList.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  leading: const CircleAvatar(),
                                  title: Text(
                                    usersList[index].username,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  trailing: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Vx.blue600),
                                      onPressed: () {
                                        transferDailog(context,
                                            (double amount) {
                                          transferAmount(usersList[index].id,
                                              amount, account.balance);
                                        });
                                        // transferAmount(usersList[index].id, 100,
                                        //     account.balance);
                                      },
                                      child: const Text(
                                        "Transfer",
                                        style: TextStyle(color: Colors.white),
                                      )).w(100).h(40),
                                ).pOnly(top: 10);
                              }),
                    )
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}

void updateData(String change, String newvalue, BuildContext context,
    WidgetRef ref, VoidCallback fetchUserData) async {
  print("Update : $change with new value $newvalue");
  var sendingBody = {};

  // set body according to change
  if (change == "password") {
    sendingBody = {"password": newvalue};
  } else if (change == "firstname") {
    sendingBody = {
      "firstname": newvalue,
    };
  } else {
    sendingBody = {
      "username": newvalue,
    };

    try {
      // get token
      SharedPreferences pref = await SharedPreferences.getInstance();
      String? token = pref.getString('token');

      // make final json body
      final finalBody = jsonEncode(sendingBody);
      final url = Uri.parse(Constant.updateDataApi);

      // hit point
      http.Response res = await http.put(url,
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'authorization': "barrer $token"
          },
          body: finalBody);

      // handle response
      if (res.statusCode == 200) {
        fetchUserData();
        Constant.showMessage("Update Data Successfully", context);
      } else {
        Constant.showMessage("Server Internal error", context);
      }
      Navigator.pop(context);
    } catch (e) {
      print("Error getting during catch : $e");
    }
  }
}

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
