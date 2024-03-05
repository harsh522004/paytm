import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:paytm/screen/dashboard.dart';
import 'package:paytm/screen/signin.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SharedPreferences pref = await SharedPreferences.getInstance();
  String? token = pref.getString("token");
  runApp(ProviderScope(
    child: MyApp(
      initialRoute: token != null ? '/dashboard' : '/',
    ),
  ));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: initialRoute,
      routes: {
        '/': (context) => const SignInPage(),
        '/dashboard': (context) => const DashBoardPage()
      },
    );
  }
}
