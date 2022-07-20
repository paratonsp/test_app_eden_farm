// ignore_for_file: override_on_non_overriding_member, use_key_in_widget_constructors, prefer_const_constructors, avoid_print, file_names

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class DateTimePickerWidget extends StatefulWidget {
  @override
  State<DateTimePickerWidget> createState() => _DateTimePickerWidgetState();
}

class _DateTimePickerWidgetState extends State<DateTimePickerWidget> {
  DateTime birthDate = DateTime.now();
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
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Theme.of(context).scaffoldBackgroundColor),
              child: SfDateRangePicker(
                onCancel: () => Navigator.pop(context),
                onSubmit: (val) => Navigator.pop(context, val),
                showActionButtons: true,
                initialSelectedDate: birthDate,
                selectionMode: DateRangePickerSelectionMode.single,
                initialSelectedRange: PickerDateRange(
                    DateTime.now().subtract(const Duration(days: 4)),
                    DateTime.now().add(const Duration(days: 3))),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
