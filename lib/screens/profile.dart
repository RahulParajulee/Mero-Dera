import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  delete(final dId) async {
    FirebaseFirestore.instance.collection("posts").snapshots();

    final _db = FirebaseFirestore.instance;
    await _db.collection("posts").doc(dId).delete();
  }
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection("posts").where("email", isEqualTo: user.email).snapshots(),
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
                    String cid = snapshot.data!.docs.elementAt(index).id;
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
                    String url =
                    snapshot.data!.docs.elementAt(index).get("imageUrl");
                    String dp =
                    snapshot.data!.docs.elementAt(index).get("dp");


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
                              IconButton(
                                  onPressed: (){delete(cid);},
                                  icon: Icon(
                                    Icons.delete_forever_outlined,
                                    color: Colors.blue,
                                  )),

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
          }
          ),
        floatingActionButton: Stack(
          children: [
            Positioned(
              left: 40,
              bottom: 0,
              child: FloatingActionButton(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ),

          ],
        )
    );
  }

}
