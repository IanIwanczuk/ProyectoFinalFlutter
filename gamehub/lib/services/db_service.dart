import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gamehub/models/current_user.dart';
import '../models/user.dart';

const String collectionRef = "usuarios";

class DatabaseService {
  final _firestore = FirebaseFirestore.instance;

  late final CollectionReference _userRef;

  DatabaseService() {
    _userRef = _firestore.collection(collectionRef).withConverter<User>(
      fromFirestore: (snapshots, _) => User.fromJson(snapshots.data()!), 
      toFirestore: (user, _) => user.toJson());
  }

  Stream<QuerySnapshot> getUsers() {
    return _userRef.snapshots();
  }

  void addUser(User user) async {
    _userRef.add(user);
  }

  void updateUser(String userId, User usuario) {
    _userRef.doc(userId).update(usuario.toJson());
  }

  Future<User?> isUserValid(String user, String pwd) async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection(collectionRef)
          .where('user', isEqualTo: user)
          .where('pwd', isEqualTo: pwd)
          .get();

      if (snapshot.docs.isNotEmpty) {
        final userDoc = snapshot.docs.first;

        currentId = userDoc.id;
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
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection(collectionRef)
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
      QuerySnapshot<Map<String, dynamic>> snapshot = await _firestore.collection(collectionRef)
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