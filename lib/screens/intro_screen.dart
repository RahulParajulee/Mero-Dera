import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:merodera/screens/home.dart';

class IntroScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              title: 'Welcome to MeroDera',
              body: '',
              image: buildImage('assets/images/Logo2.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Signin',
              body: 'Create free account in MeroDera',
              image: buildImage('assets/images/1.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Search',
              body: 'Find your preferable rooms/flats',
              image: buildImage('assets/images/2.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Post',
              body:
                  'Post details and photos of rooms/flats of your house you want to give for rent',
              image: buildImage('assets/images/6.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Chat',
              body:
                  'Chat with the owner or renter without any middleman/broker',
              image: buildImage('assets/images/3.png'),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              title: 'Live',
              body: 'Find your preferable home in any city and live your life',
              image: buildImage('assets/images/5.png'),
              decoration: getPageDecoration(),
            ),
          ],
          done: Text('Lets Go',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w600)),
          onDone: () => goToHome(context),
          showSkipButton: true,
          skip: Text(
            'Skip',
            style: TextStyle(
                color: Colors.black, fontSize: 20, fontWeight: FontWeight.w500),
          ),
          onSkip: () => goToHome(context),
          next: Icon(
            Icons.arrow_forward,
            color: Colors.black,
            size: 30,
          ),
          dotsDecorator: getDotDecoration(),
          onChange: (index) => print('Page $index selected'),
          // globalBackgroundColor: Theme.of(context).primaryColor,
          skipFlex: 0,
          nextFlex: 0,
          isProgressTap: false,
          // isProgress: false,
          // showNextButton: false,
          animationDuration: 200,
        ),
      );

  void goToHome(context) => Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => HomePage()),
      );

  Widget buildImage(String path) =>
      Center(child: Image.asset(path, width: 350));

  DotsDecorator getDotDecoration() => DotsDecorator(
        color: Color(0xFFBDBDBD),
        //activeColor: Colors.orange,
        size: Size(10, 10),
        activeSize: Size(25, 10),
        activeShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      );

  PageDecoration getPageDecoration() => PageDecoration(
        titleTextStyle: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
        bodyTextStyle: TextStyle(fontSize: 20),
        descriptionPadding: EdgeInsets.all(20).copyWith(bottom: 0),
        imagePadding: EdgeInsets.all(30),
        pageColor: Colors.white,
      );
}
