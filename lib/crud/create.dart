// ignore_for_file: unused_field, unused_local_variable, must_be_immutable
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:merodera/widget/loggedin.dart';
import 'package:merodera/crud/database.dart';


class create extends StatefulWidget {

  @override
  State<create> createState() => _createState();
  final controller = TextEditingController();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
}
class _createState extends State<create> {

  File? _image;
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();

  final locationController = new TextEditingController();
  final typeController = new TextEditingController();
  final facilitiesController = new TextEditingController();
  final priceController = new TextEditingController();
  final contactController = new TextEditingController();
  final nameController = new TextEditingController();
  final imagePicker = ImagePicker();
  String? downloadURL, location, type, facilities, price, contact, name;
  late bool _isLoading;
  String dropdownvalue = 'Room';
  var items = [
    'Room',
    'Flat',
  ];



  Future imagePickerMethod() async {
    //picking the image
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        print('No files selected');
        // showSnackBar("No file selected", Duration(milliseconds: 600));
      }
    });
  }

  //uploading image to firebase storage
  Future uploadPost(File _image) async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    final user = FirebaseAuth.instance.currentUser!;
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child("${widget}/images")
        .child("posts_$postID");
    await ref.putFile(_image);
    downloadURL = await ref.getDownloadURL();
//cloud firestore


    DatabaseModel databaseModel = DatabaseModel(name: user.displayName, location: '', contact: '', facilities: '', imageUrl: '', price: '', type: '', email: user.email, dp: user.photoURL);


    databaseModel.type = dropdownvalue;
    databaseModel.location = locationController.text;
    databaseModel.facilities = facilitiesController.text;
    databaseModel.price = priceController.text ;
    databaseModel.contact = contactController.text ;
    databaseModel.imageUrl = downloadURL;


    await firebaseFirestore.collection("posts").doc().set(databaseModel.toMap());

    Fluttertoast.showToast(msg: "Uploaded successfully :)");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => timeline()),
            (route) => false);
  }

  Widget build(BuildContext context) {
    return Scaffold(

      body: Center(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          //for rounded rectangular clip
          child: ClipRRect(
            child: ListView(
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.merge_type,
                      color: Colors.deepOrangeAccent,
                    ),
                    Spacer(),
                    SizedBox(
                      height: 20,
                    ),
                    DropdownButton(
                      underline: SizedBox(),
                      value: dropdownvalue,
                      items: items.map((String items) {
                        return DropdownMenuItem(
                          child: Text(items),
                          value: items,
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          dropdownvalue = newValue!;
                        });
                      }),
                    Spacer(
                      flex: 10,
                    ),
          ],
                ),
                Form(
                    key: _formkey,
                    child: Column(
                      children: [


                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: locationController,
                          decoration: const InputDecoration(
                              icon: const Icon(Icons.location_on_rounded, color: Colors.blue,),
                              border: OutlineInputBorder(),
                              hintText: "Location"),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Location";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            location = value;
                          },
                        ),

                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: facilitiesController,
                          decoration: const InputDecoration(
                            icon: const Icon(Icons.design_services_rounded, color: Colors.amber,),
                              border: OutlineInputBorder(),
                              hintText: "Facilities"),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Facilities";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            facilities = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: priceController,
                          decoration: const InputDecoration(
                              icon: const Icon(Icons.price_check, color: Colors.green,),
                              border: OutlineInputBorder(),
                              hintText: "Monthly Fare"),
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Fare";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            price = value;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          controller: contactController,
                          decoration: const InputDecoration(
                              icon: const Icon(Icons.contact_phone_rounded, color: Colors.cyan,),
                              border: OutlineInputBorder(),
                              hintText: "Contact"),
                          keyboardType: TextInputType.phone,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please Enter Your Contact Number";
                            }
                            return null;
                          },
                          onSaved: (value) {
                            contact = value;
                          },
                        ),

                        SizedBox(
                          height: 20,
                        ),
                      ],
                    )),
                const SizedBox(
                  height: 10,
                ),
                Expanded(
                  // flex: 4,
                    child: Container(
                      height: 300,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.teal),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: _image == null
                                    ? const Center(
                                  child: Text("No image selected"),
                                )
                                    : Image.file(_image!)),
                            ElevatedButton(
                                style:
                                ElevatedButton.styleFrom(primary: Colors.teal),
                                onPressed: () {
                                  imagePickerMethod();
                                },
                                child: Text(
                                  "Select Image",
                                )),
                          ],
                        ),
                      ),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.teal),
                    onPressed: () {
                      Navigator.pop(context);
                      if (_formkey.currentState!.validate()) {
                        showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) => const Center(
                                child: SpinKitThreeInOut(
                                  size: 50,
                                  color: Colors.teal,
                                )));
                        uploadPost(_image!);
                      }else{

                      }
                      Navigator.pop(context);
                    },
                    child: Text("Post")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Cancel")),
              ],
            ),
          ),
        ),
      ),
    );
    // ));
  }
}

