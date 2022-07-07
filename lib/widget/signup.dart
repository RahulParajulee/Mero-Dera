import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:merodera/provider/google_signin.dart';
import 'package:provider/provider.dart';

class SignUpWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return DecoratedBox(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/room.jpeg"), fit: BoxFit.cover),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Spacer(
            flex: 2,
          ),
          Image.asset('assets/images/logo.png', width: 150, height: 150,),
          Align(
              alignment: Alignment.center,
              child: Text('MeroDera', textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.cyan.withOpacity(1),
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                          color: Colors.black.withOpacity(1),
                          offset: const Offset(0, 6),
                          blurRadius: 10),
                    ]

                ),
              )),
          Spacer(
            flex: 2,
          ),
          SizedBox(height: 8),
          Align(
            alignment: Alignment.center,
            child: Text(
              'By clicking "Sign In", you agree to MeroDera terms and conditions. \n', textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 237, 245, 6),
                fontSize: 18,
                  shadows: [
                    Shadow(
                        color: Colors.black.withOpacity(1),
                        offset: const Offset(0, 6),
                        blurRadius: 10),
                  ]
              ),
            ),
          ),

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: Colors.black,
              padding: EdgeInsets.fromLTRB(30,10,30,10),
              // minimumSize: Size(double.infinity, 50),
            ),
            icon: FaIcon(
              FontAwesomeIcons.google,
              color: Colors.blue,
            ),
            label: Text('SIGN IN WITH GOOGLE'),
            onPressed: () {
              final provider =
                  Provider.of<GoogleSignInProvider>(context, listen: false);
              provider.googleLogin();
            },
          ),
          Spacer(
            flex: 1,
          )
        ],
      ),
    );
  }
}
