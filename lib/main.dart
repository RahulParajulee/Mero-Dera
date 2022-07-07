import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:merodera/provider/google_signin.dart';
import 'package:merodera/screens/home.dart';
import 'package:merodera/screens/intro_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future main() async {
  runApp(const MyApp());

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => GoogleSignInProvider(),
          child: HomePage(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'MeoDera',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: IntroScreen(),
      ),
    );
  }
}
