import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gamehub/models/current_user.dart';
import '../models/user.dart';

const String collectionRef = "usuarios";

class DatabaseService {
  // Instancia del FireStore, la base de datos
  final _firestore = FirebaseFirestore.instance;

  // Referencia a la colección "Usuarios"
  late final CollectionReference _userRef;

  /// Constructor por defecto, hacemos referencia a "Usuarios" y determinamos que, todo
  /// lo que nos venga de la base de datos lo pasamos a un objeto tipo User.dart, y lo 
  /// que pasemos a la base de datos lo insertamos como Usuario (En Firebase)
  DatabaseService() {
    _userRef = _firestore.collection(collectionRef).withConverter<User>(
      fromFirestore: (snapshots, _) => User.fromJson(snapshots.data()!), 
      toFirestore: (user, _) => user.toJson());
  }

  /// Método que nos devuelve todos los usuarios
  Stream<QuerySnapshot> getUsers() {
    return _userRef.snapshots();
  }

  /// Método que añade un único usuario que pasamos como parámetro
  void addUser(User user) async {
    _userRef.add(user);
  }

  /// Actualizamos un usuario con la ID de Firebase recibida como parametro, y el objeto
  /// de User que tengamos como segundo parámetro
  void updateUser(String userId, User usuario) {
    _userRef.doc(userId).update(usuario.toJson());
  }

  /// Método que nos busca en la base de datos si existe un usuario con un usuario y contraseña
  /// en específico. Retorna un User si encuentra algo, o Null si no encuentra nada
  /// Lo utilizamos para loggear a los usuarios en la pantalla de Login
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

  /// Determinamos si el nombre de usuario que nos proporcionan por parámetro está en uso o está disponible
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

  /// Determinamos si el correo electrónico que nos proporcionan por parámetro está en uso o está disponible
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