import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseRepository {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  BaseRepository({FirebaseFirestore? firestore, FirebaseAuth? auth})
    : firestore = firestore ?? FirebaseFirestore.instance,
      auth = auth ?? FirebaseAuth.instance;

  String get userId {
    final user = auth.currentUser;
    if (user == null) throw Exception('Usuário não logado');
    return user.uid;
  }
}
