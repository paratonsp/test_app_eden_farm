// ignore_for_file: prefer_const_literals_to_create_immutables, ignore_for_file: override_on_non_overriding_member, use_key_in_widget_constructors, prefer_const_constructors, avoid_print, unrelated_type_equality_checks, file_names, must_be_immutable

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_app_eden_farm/view/widget/datePicker.dart';

class WeightFormWidget extends StatefulWidget {
  WeightFormWidget(this.isEdit, this.id);
  ValueKey isEdit;
  String id;
  @override
  State<WeightFormWidget> createState() => _WeightFormWidgetState();
}

class _WeightFormWidgetState extends State<WeightFormWidget> {
  TextEditingController weightController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  DateTime dateCreated = DateTime.now();

  getData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('weight-list')
        .doc(widget.id)
        .get()
        .then((value) {
      setState(() {
        weightController.text = value.data()?["weight"];

        var timestamp = value.data()?["date"];
        var date = DateTime.parse(timestamp.toDate().toString());
        dateCreated = date;
        dateController.text = DateFormat('d MMMM yyyy').format(date);
      });
    });
  }

  deleteData() {
    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('weight-list')
        .doc(widget.id)
        .delete()
        .whenComplete(() => Navigator.pop(context));
  }

  @override
  void initState() {
    (widget.isEdit.value) ? getData() : print("");
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
          onPressed: (() => Navigator.pop(context)),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Container(
                  padding: EdgeInsets.all(20),
                  width: 300,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Theme.of(context).scaffoldBackgroundColor),
                  child: Column(
                    children: [
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: CupertinoTextField(
                          keyboardType: TextInputType.number,
                          controller: weightController,
                          placeholder: "Weight (Kg)",
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 40,
                        child: CupertinoTextField(
                          readOnly: true,
                          showCursor: false,
                          onTap: () {
                            navigateDatePicker();
                          },
                          controller: dateController,
                          placeholder: "Date",
                        ),
                      ),
                      SizedBox(height: 20),
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: CupertinoButton(
                          color: Colors.blueAccent,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text((widget.isEdit.value == true)
                                  ? "Update"
                                  : "Submit"),
                            ],
                          ),
                          onPressed: () {
                            FirebaseFirestore.instance
                                .collection('users')
                                .doc(FirebaseAuth.instance.currentUser!.uid)
                                .collection("weight-list")
                                .doc((widget.isEdit.value == true)
                                    ? widget.id
                                    : null)
                                .set({
                              "weight": weightController.text,
                              "date": dateCreated
                            }).whenComplete(() => Navigator.pop(context));
                          },
                        ),
                      ),
                      SizedBox(height: (widget.isEdit.value == true) ? 20 : 0),
                      (widget.isEdit.value == true)
                          ? SizedBox(
                              width: MediaQuery.of(context).size.width,
                              child: CupertinoButton(
                                color: Colors.redAccent,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text("Delete"),
                                  ],
                                ),
                                onPressed: () {
                                  deleteData();
                                },
                              ),
                            )
                          : SizedBox(),
                      SizedBox(height: 20),
                    ],
                  )),
            ),
          ],
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
        dateCreated = val;
        dateController.text = DateFormat('d MMMM yyyy').format(val);
      });
    }
  }
}
