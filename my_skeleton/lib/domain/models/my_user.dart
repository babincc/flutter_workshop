import 'package:my_skeleton/constants/db_fields.dart';

/// This model represents the user of the app.
class MyUser {
  /// Creates a [MyUser] object.
  MyUser({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  /// Creates a [MyUser] object from the data map obtained from Firebase.
  factory MyUser.fromJson(String id, Map<String, dynamic> dataMap) {
    return MyUser(
      id: id,
      firstName: dataMap[DBFields.placeholder_1],
      lastName: dataMap[DBFields.placeholder_2],
    );
  }

  /// Creates an empty [MyUser] object.
  ///
  /// This is used as a placeholder to prevent `null` errors.
  factory MyUser.empty() {
    return MyUser(
      id: "",
      firstName: "",
      lastName: "",
    );
  }

  /// This user's document ID in Firebase.
  final String id;

  /// The user's first name.
  final String firstName;

  /// The user's last name.
  final String lastName;

  /// Returns a data map that represents all of the information in this model.
  ///
  /// This is useful for sending information to Firebase.
  Map<String, dynamic> toJson() {
    return {
      DBFields.placeholder_1: firstName,
      DBFields.placeholder_2: lastName,
    };
  }

  /// Whether or not this user object has any values.
  bool get isEmpty => id.isEmpty && firstName.isEmpty && lastName.isEmpty;

  /// Whether or not this user object has any values.
  bool get isNotEmpty => !isEmpty;
}
