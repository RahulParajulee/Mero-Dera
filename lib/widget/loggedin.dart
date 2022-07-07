import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:merodera/provider/google_signin.dart';
import 'package:merodera/screens/profile.dart';
import 'package:merodera/screens/search.dart';
import 'package:merodera/state/chat_state.dart';
import 'package:provider/provider.dart';
import 'package:merodera/crud/create.dart';
import 'package:url_launcher/url_launcher.dart';
import '../crud/create.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../screens/chats.dart';
import '../screens/user_list.dart';


class timeline extends StatelessWidget {
  timeline({Key? key}) : super(key: key);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return Scaffold(

        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("posts").where("email", isNotEqualTo: user.email).snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
              if (snapshot.hasData && snapshot.data != null) {
                if (snapshot.data!.docs.isNotEmpty) {
                  return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, int index) {
                      Map<String, dynamic> docData =
                          snapshot.data!.docs[index].data();

                      if (docData.isEmpty) {
                        return Text("Document is empty");
                      }
                      // var docid = snapshot.data!.docs;
                      String name =
                          snapshot.data!.docs.elementAt(index).get("name");
                      String type =
                          snapshot.data!.docs.elementAt(index).get("type");
                      String location =
                          snapshot.data!.docs.elementAt(index).get("location");
                      String facilities =
                      snapshot.data!.docs.elementAt(index).get("facilities");
                      String price =
                          snapshot.data!.docs.elementAt(index).get("price");
                      String contact =
                          snapshot.data!.docs.elementAt(index).get("contact");
                      String url =
                          snapshot.data!.docs.elementAt(index).get("imageUrl");
                      String dp =
                          snapshot.data!.docs.elementAt(index).get("dp");
                      String mail =
                      snapshot.data!.docs.elementAt(index).get("email");


                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 8.0, 1),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.teal, width: 2),
                              borderRadius: BorderRadius.circular(15),

                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  leading: Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(dp),
                                      ),
                                      Text(name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  title: Column(
                                    children: [
                                      Text(type,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800)),
                                      Text(location,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w600)),
                                    ],
                                  ),
                                  trailing: Column(
                                    children: [
                                      Text('NPR/month'),
                                      Text(
                                        price,
                                        style: TextStyle(color: Colors.green),
                                      ),
                                      Spacer()
                                    ],
                                  ),
                                  subtitle: Row(
                                    children: [
                                      Spacer(),
                                      IconButton(
                                          onPressed: () async {
                                            launch('tel://$contact');
                                          },
                                          icon: Icon(
                                            Icons.call,
                                            color: Colors.blue,
                                          )),

                                      Text(
                                        contact,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Spacer(),
                                    ],
                                  ),
                                ),
                                 Center(
                                   child:
                                   Image.network(
                                    url,
                                    height: 210,
                                    fit: BoxFit.cover,
                                   ),
                                 ),
                                Padding(
                                  padding: EdgeInsetsDirectional.only(
                                      start: 5,
                                      end: 5,
                                      bottom: 10,
                                      top: 10
                                  ),
                                  child: Center(
                                      child: Text(facilities,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              wordSpacing: 4))),
                                ),

                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("No document available"));
                }
              } else {
                return const Center(
                    child: SpinKitThreeInOut(
                  duration: Duration(milliseconds: 1000),
                  size: 40,
                  color: Colors.green,
                ));
              }
            }),
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) {
            if (value == 0) Navigator.of(context);
            if (value == 2)
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => userList()));
            if (value == 1)
              showSearch(context: context, delegate: SearchPage());
            // Navigator.of(context)
            //     .push(MaterialPageRoute(builder: (context) => SearchPage());
            // if (value == 3)
            //   Navigator.of(context).push(
            //       MaterialPageRoute(builder: (context) => Chats()));
            if (value == 3)
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => LoggedInWidget()));
          },
          items: [
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.home_rounded,
                  color: Colors.green,
                  size: 30,
                ),
                label: "",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(Icons.search_sharp, color: Colors.amber),
                label: "",
                backgroundColor: Colors.white),
            // BottomNavigationBarItem(
            //     icon: Icon(
            //       Icons.people_alt_rounded,
            //       color: Colors.red,
            //       size: 20,
            //     ),
            //     label: "",
            //     backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.chat_bubble_outline_rounded,
                  color: Colors.redAccent,
                  size: 20,
                ),
                label: "",
                backgroundColor: Colors.white),
            BottomNavigationBarItem(
                icon: CircleAvatar(
                  radius: 15,
                  backgroundImage: NetworkImage(user.photoURL!),
                ),
                label: "",
                backgroundColor: Colors.white),
          ],
        ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              left: 40,
              bottom: 0,
              child: FloatingActionButton(
                  child: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => create()),
                    );
                  }),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: new FloatingActionButton(
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logOut();
                    // Navigator.pop(context);
                  }),
            ),
          ],
        ));
  }
}

class LoggedInWidget extends StatelessWidget {
  LoggedInWidget({Key? key}) : super(key: key);
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return Scaffold(
      //Profile Page Popup
      body: Container(
          alignment: Alignment.center,
          color: Colors.blueGrey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Spacer(
                flex: 2,
              ),
              Image.asset(
                'assets/images/Logo2.png',
                width: 150,
                height: 150,
              ),
              Text(
                'Profile',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                        color: Colors.black12,
                        offset: Offset(-5, 9),
                        blurRadius: 10,
                      )
                    ],
                    color: Colors.amber),
              ),
              SizedBox(height: 32),
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.photoURL!),
              ),
              SizedBox(height: 8),
              Text(
                '' + user.displayName!,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(height: 8),
              Text(
                '' + user.email!,
                style: TextStyle(color: Colors.white, fontSize: 20),
              ),

              Spacer(),
              FloatingActionButton.extended(
                  label: Text('My Post'),
                  icon: Icon(
                    Icons.arrow_circle_right_rounded,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ProfilePage()));
                  }),
              Spacer(),
              FloatingActionButton.extended(
                  label: Text('Back to Home'),
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),

              Spacer(
                flex: 2,
              ),
            ],
          )),
    );
  }
}
