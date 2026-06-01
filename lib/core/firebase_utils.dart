import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FbUtils {
  static FirebaseFirestore get firestore => FirebaseFirestore.instance;
  static FirebaseAuth get auth => FirebaseAuth.instance;
  
  static FieldValue get serverTimestamp => FieldValue.serverTimestamp();
  static dynamic increment(num value) => FieldValue.increment(value);
  
  static SetOptions get setMerge => SetOptions(merge: true);
  
  static dynamic get documentIdField => FieldPath.documentId;

  static FieldValue arrayUnion(List<dynamic> elements) => FieldValue.arrayUnion(elements);
  static FieldValue arrayRemove(List<dynamic> elements) => FieldValue.arrayRemove(elements);
}
