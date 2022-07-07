import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:merodera/screens/people.dart';

class userList extends StatefulWidget {
  userList({Key? key}) : super(key: key);

  var currentUser = FirebaseAuth.instance.currentUser?.uid;

  @override
  State<userList> createState() => _userListState();
}

class _userListState extends State<userList> {
  final user = FirebaseAuth.instance.currentUser!;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  void callChatDetailScreen(BuildContext context, String name, String email){
    Navigator.push(
        context,
        CupertinoPageRoute(builder: (context) => ChatDetail(
          // docId: chatDetailDocId,
          friendName: name,
          friendEmail: email,
        ))
    );
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    return Scaffold(
      appBar: AppBar(
        title:
        Text('Users List')
      ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection("users").where("email", isNotEqualTo: user.email).snapshots(),
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
                      snapshot.data!.docs.elementAt(index).get("username");
                      String pp =
                      snapshot.data!.docs.elementAt(index).get("dp");
                      String email =
                      snapshot.data!.docs.elementAt(index).get("email");

                      return Padding(
                        padding: const EdgeInsets.fromLTRB(10, 18.0, 8.0, 1),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.cyan, width: 3),
                              borderRadius: BorderRadius.circular(15),

                            ),
                            child: Column(
                              children: [
                                ListTile(
                                  onTap: () => callChatDetailScreen(context, name, email),
                                  leading:
                                      CircleAvatar(
                                        radius: 20,
                                        backgroundImage: NetworkImage(pp),
                                      ),
                                  title:
                                      Text(name,
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800)),
                                  subtitle: Text(email),

                                ),


                              ],
                            ),

                          ),
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text("No users available"));
                }
              } else {
                return const Center(
                    child: SpinKitThreeInOut(
                      duration: Duration(milliseconds: 1000),
                      size: 40,
                      color: Colors.green,
                    ));
              }
            }
        ),
    );
  }
}
