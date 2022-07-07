import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_6.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatDetail extends StatefulWidget {
  final friendEmail;
  final friendName;
  const ChatDetail({Key? key, this.friendEmail, this.friendName})
      : super(key: key);

  @override
  _ChatDetailState createState() => _ChatDetailState(friendEmail, friendName);
}

class _ChatDetailState extends State<ChatDetail> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  final String friendEmail;
  final String friendName;
  final currentUserEmail = FirebaseAuth.instance.currentUser?.email;
  var chatDocId;
  var _textController = new TextEditingController();

  _ChatDetailState(this.friendEmail, this.friendName);
  @override
  void initState() {
    super.initState();
    checkUser();
  }

  void checkUser() async {
    await chats
        .where('users', isEqualTo: {friendEmail: null, currentUserEmail: null})
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });
            } else {
              await chats.add({
                'users': {currentUserEmail: null, friendEmail: null},
                'names': {
                  currentUserEmail:
                      FirebaseAuth.instance.currentUser?.displayName,
                  friendEmail: friendName
                }
              }).then((value) => {chatDocId = value});
            }
          },
        )
        .catchError((error) {});
  }

  void sendMessage(String msg) {
    if (msg == '') return;

    chats.doc(chatDocId).collection("message").add({
      'createdOn': FieldValue.serverTimestamp(),
      'email': currentUserEmail,
      'friendName': friendName,
      'msg': msg
    }).then((value) {
      _textController.text = '';
    });
  }

  bool isSender(String friend) {
    return friend == currentUserEmail;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserEmail) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  @override
  Widget build(BuildContext context) {
    // final user = FirebaseAuth.instance.currentUser!;
    // final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    // FirebaseFirestore.instance.collection('posts').where("email", isEqualTo: user.email).snapshots();
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('chats')
            .doc(chatDocId)
            .collection('message')
            .orderBy('createdOn', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text("Something went Wrong"),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SpinKitThreeInOut(
                size: 50,
                color: Colors.teal,
              ),
            );
          }
          if (snapshot.hasData) {
            var data;
            return Material(
              child: CupertinoPageScaffold(
                  navigationBar: CupertinoNavigationBar(
                    previousPageTitle: "Back",
                    middle: Text(friendName),
                    // trailing: CupertinoButton(
                    //   padding: EdgeInsets.zero,
                    //   onPressed: () {  },
                    //   child: Icon(CupertinoIcons.phone),
                    // ),
                  ),
                  child: SafeArea(
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            reverse: true,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot document) {
                              data = document.data()!;
                              print(document.toString());
                              print(data['msg']);
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: ChatBubble(
                                  clipper: ChatBubbleClipper6(
                                    nipSize: 0,
                                    radius: 0,
                                    type: isSender(data['email'].toString())
                                        ? BubbleType.sendBubble
                                        : BubbleType.receiverBubble,
                                  ),
                                  alignment:
                                      getAlignment(data['email'].toString()),
                                  margin: EdgeInsets.only(top: 20),
                                  backGroundColor:
                                      isSender(data["email"].toString())
                                          ? Colors.cyan
                                          : Colors.grey,
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width * 0.7,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(data["msg"],
                                                style: TextStyle(
                                                    fontSize: 20,
                                                    color: isSender(data["email"]
                                                            .toString())
                                                        ? Colors.white
                                                        : Colors.black),
                                                maxLines: 100,
                                                overflow: TextOverflow.ellipsis)
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              data["createdOn"] == null
                                                  ? DateTime.now().toString()
                                                  : data["createdOn"]
                                                      .toDate()
                                                      .toString(),
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  color: isSender(data["email"]
                                                          .toString())
                                                      ? Colors.white
                                                      : Colors.black),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Padding(
                            padding: const EdgeInsets.only(left: 18),
                                child: CupertinoTextField(
                                    controller: _textController,),
                              ),
                              ),
                            CupertinoButton(
                                child: Icon(Icons.send_sharp),
                                onPressed: () =>
                                    sendMessage(_textController.text))
                          ],
                        )
                      ],
                    ),
                  )),
            );
          }

          return Container();
        });
  }
}
