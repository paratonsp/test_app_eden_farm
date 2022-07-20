// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_print, file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app_eden_farm/view/login.dart';
import 'package:test_app_eden_farm/view/widget/datePicker.dart';
import 'package:intl/intl.dart';
import 'package:test_app_eden_farm/view/widget/ganderPicker.dart';

class UpdateProfile extends StatefulWidget {
  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  DateTime birthDateTime = DateTime.now();

  getProfile() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      setState(() {
        nameController.text = value.data()?["name"];
        genderController.text = value.data()?["gender"];
        heightController.text = value.data()?["height"];

        var timestamp = value.data()?["birth"];
        var date = DateTime.parse(timestamp.toDate().toString());
        birthDateTime = date;
        birthController.text = DateFormat('d MMMM yyyy').format(date);
      });
    });
  }

  updateProfile() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'name': nameController.text,
      'gender': genderController.text,
      'birth': birthDateTime,
      'height': heightController.text,
    }).whenComplete(
      () => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Update Completed!"),
        ),
      ),
    );
  }

  @override
  void initState() {
    getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
            width: 0, color: Theme.of(context).scaffoldBackgroundColor),
        leading: CupertinoNavigationBarBackButton(
          onPressed: (() {
            Navigator.pop(context);
          }),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Settings",
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20),
              Text("Name"),
              SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: CupertinoTextField(
                  controller: nameController,
                  placeholder: "Name",
                ),
              ),
              SizedBox(height: 20),
              Text("Gender"),
              SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: CupertinoTextField(
                  readOnly: true,
                  showCursor: false,
                  onTap: () {
                    navigateGanderPicker();
                  },
                  controller: genderController,
                  placeholder: "Gender",
                ),
              ),
              SizedBox(height: 20),
              Text("Date Of Birth"),
              SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: CupertinoTextField(
                  readOnly: true,
                  showCursor: false,
                  onTap: () {
                    navigateDatePicker();
                  },
                  controller: birthController,
                  placeholder: "Date Of Birth",
                ),
              ),
              SizedBox(height: 20),
              Text("Height"),
              SizedBox(height: 5),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: 40,
                child: CupertinoTextField(
                  controller: heightController,
                  keyboardType: TextInputType.number,
                  placeholder: "Height",
                ),
              ),
              SizedBox(height: 40),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CupertinoButton.filled(
                  child: Text("Update"),
                  onPressed: () {
                    updateProfile();
                  },
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Divider(
                      thickness: 1,
                      color: Colors.grey[300],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CupertinoButton.filled(
                  child: Text("Sign Out"),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut().whenComplete(() {
                      FirebaseFirestore.instance.terminate();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => LoginScreen()),
                          (Route<dynamic> route) => false);
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  navigateDatePicker() async {
    var val = await Navigator.of(context).push(
      PageRouteBuilder(
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 300),
          opaque: false,
          pageBuilder: (_, __, ___) => DateTimePickerWidget(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          }),
    );
    if (val != null) {
      setState(() {
        birthDateTime = val;
        birthController.text = DateFormat('d MMMM yyyy').format(val);
      });
    }
  }

  navigateGanderPicker() async {
    var val = await Navigator.of(context).push(
      PageRouteBuilder(
          barrierDismissible: true,
          barrierColor: Colors.black.withOpacity(0.5),
          transitionDuration: Duration(milliseconds: 300),
          opaque: false,
          pageBuilder: (_, __, ___) => GanderPickerWidgets(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.ease;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return SlideTransition(
              position: tween.animate(curvedAnimation),
              child: child,
            );
          }),
    );
    if (val != null) {
      setState(() {
        genderController.text = val;
      });
    }
  }
}
