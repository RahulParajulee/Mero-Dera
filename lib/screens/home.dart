import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:merodera/widget/loggedin.dart';
import 'package:merodera/widget/signup.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              return timeline();
            } else if (snapshot.hasError) {
              return Center(child: Text('Something Went Wrong'));
            } else {
              return SignUpWidget();
            }
          },
        ),
      );
}
