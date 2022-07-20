// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app_eden_farm/view/homepage.dart';
import 'package:test_app_eden_farm/view/widget/datePicker.dart';
import 'package:intl/intl.dart';
import 'package:test_app_eden_farm/view/widget/ganderPicker.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController birthController = TextEditingController();
  TextEditingController genderController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  DateTime birthDateTime = DateTime.now();

  profile() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      'name': nameController.text,
      'gender': genderController.text,
      'birth': birthDateTime,
      'height': heightController.text,
    });
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomepageScreen()),
    );
  }

  @override
  void dispose() {
    FirebaseFirestore.instance.terminate();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(left: 20, right: 20, top: 100),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Profile",
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
              SizedBox(height: 20),
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: CupertinoButton.filled(
                  child: Text("Next"),
                  onPressed: () {
                    // Navigator.pop(context);
                    profile();
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
