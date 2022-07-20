// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, avoid_print, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_this, prefer_collection_literals, unnecessary_new, unused_element, prefer_is_empty

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_app_eden_farm/model/weight.dart';
import 'package:test_app_eden_farm/view/updateProfile.dart';
import 'package:test_app_eden_farm/view/widget/lineChart.dart';
import 'package:test_app_eden_farm/view/widget/weightForm.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';

class HomepageScreen extends StatefulWidget {
  @override
  State<HomepageScreen> createState() => _HomepageScreenState();
}

class _HomepageScreenState extends State<HomepageScreen> {
  bool dataExist = false;

  List<Weight> listWeight = [];
  late List<FlSpot> listWeightFl;
  late List financialValues;
  late List financialDates;
  late List financialStatus;

  getData() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("weight-list")
        .get()
        .then((val) {
      if (val.size == 0) {
        setState(() {
          dataExist = false;
        });
      } else {
        List<Weight> temp = [];
        List<FlSpot> tempFl = [];
        for (var i = 0; i < val.size; i++) {
          temp.add(
            Weight(
              val.docs[i].id,
              val.docs[i].data()["weight"],
              val.docs[i].data()["date"],
            ),
          );
          var weight = val.docs[i].data()["weight"];
          var timestamp = val.docs[i].data()["date"];
          var date = DateTime.parse(timestamp.toDate().toString());
          var tempDate = DateFormat("d").format(date);
          double y = double.parse(tempDate);
          double x = double.parse(weight);
          tempFl.add(FlSpot(y, x));
        }
        setState(() {
          listWeight = temp;
          listWeight.sort((a, b) => b.date.compareTo(a.date));
          listWeightFl = tempFl;
          listWeightFl.sort((a, b) => b.x.compareTo(a.x));
          dataExist = true;
        });
      }
    });
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CupertinoNavigationBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        border: Border.all(
            width: 0, color: Theme.of(context).scaffoldBackgroundColor),
        trailing: GestureDetector(
          child: Icon(Icons.settings),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => UpdateProfile()),
            );
          },
        ),
      ),
      body: (!dataExist)
          ? SizedBox(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Center(
                child: CupertinoButton(
                  color: Colors.blueAccent,
                  child: Icon(Icons.add),
                  onPressed: () {
                    navigateWeightForm(ValueKey(false), "");
                  },
                ),
              ))
          : SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 10),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                          // color: Colors.white,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              right: 0.0, left: 0.0, top: 22, bottom: 15),
                          child: LineChart(
                            mainData(context, listWeightFl),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Weight History",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.blueAccent,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Icon(
                                Icons.add,
                                color: Colors.white,
                              )),
                          onTap: () {
                            navigateWeightForm(ValueKey(false), "");
                          },
                        )
                      ],
                    ),
                    SizedBox(height: 20),
                    ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: listWeight.length,
                      itemBuilder: (context, index) {
                        Weight data = listWeight[index];
                        return Card(
                          elevation: 0,
                          child: ListTile(
                            title: Text(
                              data.weight + " Kg",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(DateFormat('d MMMM yyyy').format(
                                DateTime.parse(data.date.toDate().toString()))),
                            trailing: GestureDetector(
                              child: Icon(Icons.more_vert),
                              onTap: () {
                                navigateWeightForm(ValueKey(true), data.id);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  navigateWeightForm(ValueKey isEdit, String id) async {
    await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (_, __, ___) => WeightFormWidget(isEdit, id),
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
        },
      ),
    );
    setState(() {
      getData();
    });
  }
}
