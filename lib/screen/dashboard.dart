import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:paytm/constant.dart';
import 'package:paytm/models/user_model.dart';
import 'package:paytm/providers/user_provider.dart';
import 'package:paytm/widgets/dashboard_content.dart';
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

  // access Current login User
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

  // fetch all users available on Paytm
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

  // open sheet for chnage data
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

  // transfer Amount
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

// update Data method
  void updateData(String change, String newvalue, BuildContext context,
      WidgetRef ref, VoidCallback fetchUserData) async {
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

  // method build Dashboard
  @override
  Widget build(BuildContext context) {
    // providers
    final user = ref.watch(userDataProvider.notifier).state;
    final account = ref.watch(accountDataProvider.notifier).state;
    final usersList = ref.watch(userListProvider.notifier).state;

    // main body
    return SafeArea(
      child: Scaffold(
        body: (user != null && account != null)
            ? dashBoardContent(
                context, user, account, usersList, sheetOpen, transferAmount)
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
