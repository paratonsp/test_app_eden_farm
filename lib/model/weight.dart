import 'package:cloud_firestore/cloud_firestore.dart';

class Weight {
  const Weight(
    this.id,
    this.weight,
    this.date,
  );
  final String id;
  final String weight;
  final Timestamp date;
}
