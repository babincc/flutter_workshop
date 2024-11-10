import 'package:collection/collection.dart';
import 'package:my_skeleton/constants/database/db_fields.dart';
import 'package:my_skeleton/constants/defaults.dart';
import 'package:my_skeleton/domain/enums/user_role.dart';
import 'package:my_skeleton/utils/db_tools.dart';

/// This model represents the user of the app.
class MyUser {
  /// Creates a [MyUser] object.
  MyUser({
    required this.id,
    required this.role,
    required this.firstName,
    required this.lastName,
    required this.age,
    required this.ssn,
    required this.friendIds,
  });

  /// Creates a [MyUser] object from a JSON data map.
  MyUser.fromJson(this.id, Map<String, dynamic> data)
      : role = UserRole.fromString(data[DbFields.role] ?? ''),
        firstName = data[DbFields.firstName] ?? '',
        lastName = data[DbFields.lastName] ?? '',
        age = data[DbFields.age],
        ssn = DbTools.decryptOrNull(data[DbFields.ssn]) ?? '',
        friendIds = data[DbFields.friendIds] ?? [];

  /// Creates an empty [MyUser] object.
  MyUser.empty()
      : id = '',
        role = UserRole.other,
        firstName = '',
        lastName = '',
        age = null,
        ssn = '',
        friendIds = [];

  /// Whether or not this object is empty.
  bool get isEmpty =>
      id.isEmpty &&
      identical(role, UserRole.other) &&
      firstName.isEmpty &&
      lastName.isEmpty &&
      age == null &&
      ssn.isEmpty &&
      friendIds.isEmpty;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// This user's document ID in Firebase.
  final String id;

  /// The user's role.
  final UserRole role;

  /// The user's first name.
  final String firstName;

  /// The user's last name.
  final String lastName;

  /// The user's age.
  final int? age;

  /// The user's social security number.
  final String ssn;

  /// The IDs of this user's friends.
  final List<String> friendIds;

  /// Returns a copy of this object.
  MyUser copy() => copyWith();

  /// Returns a copy of this object with its field values replaced by the ones
  /// provided to this method.
  ///
  /// Since [age] is nullable, it is defaulted to an empty object in this
  /// method. If left as an empty object, its current value in this [MyUser]
  /// object will be used. This way, if it is `null`, the program will know that
  /// it is intentionally being set to `null`.
  MyUser copyWith({
    String? id,
    UserRole? role,
    String? firstName,
    String? lastName,
    Object? age = Defaults.sentinelValue,
    String? ssn,
    List<String>? friendIds,
  }) {
    if (!identical(age, Defaults.sentinelValue)) {
      assert(age is int?, '`age` must be an `int?` object');
    }

    return MyUser(
      id: id ?? this.id,
      role: role ?? this.role,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      age: identical(age, Defaults.sentinelValue) ? this.age : age as int?,
      ssn: ssn ?? this.ssn,
      friendIds: friendIds ?? List<String>.from(this.friendIds),
    );
  }

  /// Returns a JSON representation of the object.
  Map<String, dynamic> toJson() {
    return {
      DbFields.role: role.value,
      DbFields.firstName: firstName,
      DbFields.lastName: lastName,
      DbFields.age: age,
      DbFields.ssn: DbTools.encrypt(ssn),
      DbFields.friendIds: friendIds,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is MyUser &&
        other.id == id &&
        identical(other.role, role) &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        identical(other.age, age) &&
        other.ssn == ssn &&
        const DeepCollectionEquality.unordered()
            .equals(other.friendIds, friendIds);
  }

  @override
  int get hashCode => Object.hash(
        id,
        role,
        firstName,
        lastName,
        age,
        ssn,
        const DeepCollectionEquality.unordered().hash(friendIds),
      );

  @override
  String toString() => 'Instance of MyUser: $id - {'
      'role: ${role.value}, '
      'firstName: $firstName, '
      'lastName: $lastName, '
      'age: $age, '
      'ssn: $ssn, '
      'friendIds: $friendIds'
      '}';
}
