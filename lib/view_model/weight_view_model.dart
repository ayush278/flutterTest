import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../model/weight_entry_model.dart';
import '../helpers/service/auth_service.dart';
import '../helpers/service/firestore_service.dart';

class WeightViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();
  User? _user;
  List<WeightEntry> _weightEntries = [];
  User? get user => _user;
  List<WeightEntry> get weightEntries => _weightEntries;
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  //signin function
  Future<void> signInAnonymously() async {
    _isLoading = true;

    _user = await _authService.signInAnonymously();
    _isLoading = false;
    notifyListeners();

    _loadWeightEntries();
  }

//sign out function
  Future<void> signOut() async {
    _isLoading = true;
    await _authService.signOut();
    _isLoading = false;

    _user = null;
    _weightEntries.clear();
    notifyListeners();
  }

  //Adding weight entry
  Future<void> addWeightEntry(double weight) async {
    _isLoading = true;
    await _firestoreService.addWeightEntry(weight, _user!);
    _isLoading = false;
    notifyListeners();
  }

  //Getting weight entries
  Stream<List<WeightEntry>> getWeightEntriesStream() {
    if (_user != null) {
      return _firestoreService.getWeightEntries(_user!);
    } else {
      return Stream.value(
          []); // Return an empty stream if the user is not signed in.
    }
  }

  //Update weight entry
  Future<void> updateWeightEntry(String id, double weight) async {
    _isLoading = true;

    await _firestoreService.updateWeightEntry(id, weight);
    _isLoading = false;
    notifyListeners();
  }

  //Delete weight entry
  Future<void> deleteWeightEntry(String id) async {
    _isLoading = true;

    await _firestoreService.deleteWeightEntry(id);
    _isLoading = false;
    notifyListeners();
  }

  void _loadWeightEntries() {
    if (_user != null) {
      _isLoading = true;

      _firestoreService.getWeightEntries(_user!).listen((entries) {
        _weightEntries = entries;
        _isLoading = false;

        notifyListeners();
      });
    }
  }
}
