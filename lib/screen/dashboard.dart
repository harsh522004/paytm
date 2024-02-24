import 'package:flutter/material.dart';
import 'package:velocity_x/velocity_x.dart';

class DashBoardPage extends StatelessWidget {
  const DashBoardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
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
                        const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Good Moring",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "Mittle clayton",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 15),
                            ),
                          ],
                        ),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          const Text(
                            "₹6668.80",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: 30,
                                fontWeight: FontWeight.w500),
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
                    ),
                  ],
                ).pOnly(left: 40, top: 30),
              ),
              SizedBox(
                height: context.screenHeight * 0.50,
                child: ListView.builder(
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const CircleAvatar(),
                        title: const Text(
                          "Username",
                          style: TextStyle(fontSize: 18),
                        ),
                        trailing: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Vx.blue600),
                            onPressed: () {},
                            child: const Text(
                              "Transfer",
                              style: TextStyle(color: Colors.white),
                            )).w(100).h(40),
                      ).pOnly(top: 10);
                    }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
