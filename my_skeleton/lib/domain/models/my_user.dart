import 'package:collection/collection.dart';
import 'package:my_skeleton/constants/db_fields.dart';

/// This model represents the user of the app.
class MyUser {
  /// Creates a [MyUser] object.
  MyUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.friendIds,
  });

  /// Creates a [MyUser] object from the data map obtained from Firebase.
  factory MyUser.fromJson(String id, Map<String, dynamic> dataMap) {
    return MyUser(
      id: id,
      firstName: dataMap[DBFields.firstName] ?? '',
      lastName: dataMap[DBFields.lastName] ?? '',
      age: dataMap[DBFields.age],
      friendIds: dataMap[DBFields.friendIds] ?? [],
    );
  }

  /// Creates an empty [MyUser] object.
  MyUser.empty()
      : id = '',
        firstName = '',
        lastName = '',
        age = null,
        friendIds = [];

  /// Whether or not this user object is empty.
  bool get isEmpty =>
      id.isEmpty &&
      firstName.isEmpty &&
      lastName.isEmpty &&
      age == null &&
      friendIds.isEmpty;

  /// Whether or not this user object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// This user's document ID in Firebase.
  final String id;

  /// The user's first name.
  final String firstName;

  /// The user's last name.
  final String lastName;

  /// The user's age.
  final int? age;

  /// The IDs of this user's friends.
  final List<String> friendIds;

  /// Returns a copy of this object.
  MyUser copy() => copyWith();

  /// Used in the [copyWith] method to check if nullable values are meant to be
  /// copied over.
  static const sentinelValue = Object();

  /// Returns a copy of this object with its field values replaced by the ones
  /// provided to this method.
  MyUser copyWith({
    String? id,
    String? firstName,
    String? lastName,
    Object? age = sentinelValue,
    List<String>? friendIds,
  }) {
    if (!identical(age, sentinelValue)) {
      assert(age is int?, "`age` must be an `int?` object");
    }

    return MyUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: identical(age, sentinelValue) ? this.age : age as int?,
      friendIds: friendIds ?? List<String>.from(this.friendIds),
    );
  }

  /// Returns a data map that represents all of the information in this model.
  ///
  /// This is useful for sending information to Firebase.
  Map<String, dynamic> toJson() {
    return {
      DBFields.firstName: firstName,
      DBFields.lastName: lastName,
      DBFields.age: age,
      DBFields.friendIds: friendIds,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is MyUser &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        ((other.age == null && age == null) ||
            ((other.age != null && age != null) &&
                identical(other.age, age))) &&
        const DeepCollectionEquality.unordered()
            .equals(other.friendIds, friendIds);
  }

  @override
  int get hashCode => Object.hash(
        id,
        firstName,
        lastName,
        age,
        const DeepCollectionEquality.unordered().hash(friendIds),
      );

  @override
  String toString() => 'Instance of MyUser: $id - ${toJson()}';
}
