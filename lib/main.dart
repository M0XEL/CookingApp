import 'package:CookingApp/screens/login/LandingPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/login/LoginPage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'CookingApp',
    theme: ThemeData(primarySwatch: Colors.orange),
    home: LandingPage(),
  );
}
