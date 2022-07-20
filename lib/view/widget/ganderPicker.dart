// ignore_for_file: prefer_const_literals_to_create_immutables, ignore_for_file: override_on_non_overriding_member, use_key_in_widget_constructors, prefer_const_constructors, avoid_print, file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GanderPickerWidgets extends StatefulWidget {
  @override
  State<GanderPickerWidgets> createState() => _GanderPickerWidgetsState();
}

class _GanderPickerWidgetsState extends State<GanderPickerWidgets> {
  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
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
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CupertinoButton(
                        color: Colors.blueAccent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.male),
                            SizedBox(width: 5),
                            Text("Male"),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context, "Male");
                        },
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: CupertinoButton(
                        color: Colors.pinkAccent,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.female),
                            SizedBox(width: 5),
                            Text("Female"),
                          ],
                        ),
                        onPressed: () {
                          Navigator.pop(context, "Female");
                        },
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
