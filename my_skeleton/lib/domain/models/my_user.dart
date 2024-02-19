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
      firstName: dataMap[DBFields.firstName],
      lastName: dataMap[DBFields.lastName],
    );
  }

  /// Creates an empty [MyUser] object.
  MyUser.empty()
      : id = '',
        firstName = '',
        lastName = '';

  /// Whether or not this user object is empty.
  bool get isEmpty => id.isEmpty && firstName.isEmpty && lastName.isEmpty;

  /// Whether or not this user object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// This user's document ID in Firebase.
  final String id;

  /// The user's first name.
  final String firstName;

  /// The user's last name.
  final String lastName;

  /// Returns a copy of this object.
  MyUser copy() => copyWith();

  /// Returns a copy of this object with its field values replaced by the ones
  /// provided to this method.
  MyUser copyWith({
    String? id,
    String? firstName,
    String? lastName,
  }) {
    return MyUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
    );
  }

  /// Returns a data map that represents all of the information in this model.
  ///
  /// This is useful for sending information to Firebase.
  Map<String, dynamic> toJson() {
    return {
      DBFields.firstName: firstName,
      DBFields.lastName: lastName,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is MyUser &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName;
  }

  @override
  int get hashCode => Object.hash(
        id,
        firstName,
        lastName,
      );

  @override
  String toString() => 'Instance of MyUser: ${toJson()}';
}
