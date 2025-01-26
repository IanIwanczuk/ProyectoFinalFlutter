import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user.dart';

const COLLECTION_REF = "usuarios";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _userRef;

  DatabaseService() {
    _userRef = _firestore.collection(COLLECTION_REF).withConverter<User>(
      fromFirestore: (snapshots, _) => User.fromJson(snapshots.data()!), 
      toFirestore: (user, _) => user.toJson());
  }

  Stream<QuerySnapshot> getUsers() {
    return _userRef.snapshots();
  }

  void addUser(User user) async {
    _userRef.add(user);
  }

  Future<User?> isUserValid(String user, String pwd) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection(COLLECTION_REF)
          .where('user', isEqualTo: user)
          .where('pwd', isEqualTo: pwd)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final userDoc = snapshot.docs.first;

        return User(
          email: userDoc['email'],
          user: userDoc['user'],
          pwd: userDoc['pwd'],
          sex: userDoc['sex'],
        );
      }

      return null;
    } catch (e) {
      return null;
    }
  }  

    Future<bool> isUserAvailable(String user) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection(COLLECTION_REF)
          .where('user', isEqualTo: user)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }  

  Future<bool> isEmailAvailable(String email) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection(COLLECTION_REF)
          .where('email', isEqualTo: email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return false;
      }

      return true;
    } catch (e) {
      return false;
    }
  }  
}