import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_skeleton/constants/db_collections.dart';
import 'package:my_skeleton/domain/models/my_user.dart';

class MyUserService {
  /// The "users" collection in Firebase.
  static final CollectionReference usersCol =
      FirebaseFirestore.instance.collection(DBCollections.col1);

  /// Creates a new user, and adds them to Firebase.
  static Future<MyUser> createUserDoc(MyUser myUser) async {
    /// The bundle of documents that will be sent to Firebase to be created.
    WriteBatch batch = FirebaseFirestore.instance.batch();

    // The documents being sent to Firebase.
    DocumentReference userDoc = usersCol.doc(myUser.id);
    // TODO create other docs that should be sent with user creation

    // Prep the docs to go to Firebase.
    batch.set(userDoc, myUser.toJson());
    // TODO add other docs that should be sent with user creation

    // Write the new docs to Firebase.
    await batch.commit();

    return myUser;
  }

  /// Fetches the user from Firebase.
  ///
  /// Returns `null` if the user does not exist.
  static Future<MyUser?> fetchUser(String userId) async {
    /// Fetch the user document from Firebase.
    final DocumentSnapshot<Object?> userDoc = await usersCol.doc(userId).get();

    /// If the document does not exist, return null.
    if (userDoc.data() == null) return null;

    /// If the data is corrupt, return null.
    if (userDoc.data is! Map<String, dynamic>) return null;

    Map<String, dynamic> dataMap = userDoc.data() as Map<String, dynamic>;

    return MyUser.fromJson(userDoc.id, dataMap);
  }
}
