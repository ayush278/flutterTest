import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:testflutter/helpers/app_constants.dart';

import '../../model/weight_entry_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //Firestore add weight entry
  Future<void> addWeightEntry(double weight, User user) async {
    try {
      await _firestore.collection(AppConstants.firebaseCollectionName).add({
        AppConstants.firebaseWeightKey: weight,
        AppConstants.firebaseTimeStampKey:
            DateTime.timestamp(), //FieldValue.serverTimestamp(),
        AppConstants.firebaseUserIdKey: user.uid,
      });
    } catch (e) {
      log('Error adding weight entry: $e');
    }
  }

  //Firestore read weight entries
  Stream<List<WeightEntry>> getWeightEntries(User user) {
    return _firestore
        .collection(AppConstants.firebaseCollectionName)
        .where(AppConstants.firebaseUserIdKey, isEqualTo: user.uid)
        .orderBy(AppConstants.firebaseTimeStampKey, descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return WeightEntry(
          id: doc.id,
          weight: data[AppConstants.firebaseWeightKey].toDouble(),
          timestamp:
              (data[AppConstants.firebaseTimeStampKey] as Timestamp).toDate(),
        );
      }).toList();
    });
  }

  //Firestore update weight entry
  Future<void> updateWeightEntry(String id, double weight) async {
    try {
      await _firestore
          .collection(AppConstants.firebaseCollectionName)
          .doc(id)
          .update({
        AppConstants.firebaseWeightKey: weight,
      });
    } catch (e) {
      log('Error updating weight entry: $e');
    }
  }

  //Firestore delete weight entry
  Future<void> deleteWeightEntry(String id) async {
    try {
      await _firestore
          .collection(AppConstants.firebaseCollectionName)
          .doc(id)
          .delete();
    } catch (e) {
      log('Error deleting weight entry: $e');
    }
  }
}
