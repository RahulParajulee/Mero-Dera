import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchPage extends SearchDelegate {
  CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("posts");

  List<Widget> buildActions(BuildContext context) {
    return <Widget>[
      IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close, color: Colors.redAccent,))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: Icon(Icons.home_rounded, color: Colors.blue,));
  }

  @override
  Widget buildResults(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firebaseFirestore.snapshots().asBroadcastStream(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.data!.docs
                .where((QueryDocumentSnapshot<Object?> element) =>
                    element['location']
                        .toString()
                        .toLowerCase()
                        .contains(query.toLowerCase()))
                .isEmpty) {
              return Center(
                child: Text("              Sorry 🙃🙃 \nNo results for this location"),
              );
            } else {
              return ListView(
                children: [
                  ...snapshot.data!.docs
                      .where((QueryDocumentSnapshot<Object?> element) =>
                          element['location']
                              .toString()
                              .toLowerCase()
                              .contains(query.toLowerCase()))
                      .map((QueryDocumentSnapshot<Object?> data) {
                    final String location = data.get('location');
                    final String url = data['imageUrl'];
                    final String type = data['type'];
                    final String facilities = data['facilities'];
                    final String price = data['price'];
                    final String dp = data['dp'];
                    final String contact = data['contact'];
                    final String name = data['name'];

                    return SingleChildScrollView(
                      child:
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 18.0, 8.0, 15),
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
                                  Image.network(
                                    url,
                                    height: 210,
                                    fit: BoxFit.cover,
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
                        ),
                    );

                  })
                ],
              );
            }
          }
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Center(
      child: Text(
        '🏚️🏚️ Where do you wanna live ?😊😊'
      )
    );
  }
}
