import 'package:collection/collection.dart';
import 'package:my_skeleton/constants/database/db_columns.dart';
import 'package:my_skeleton/constants/defaults.dart';
import 'package:my_skeleton/domain/enums/user_role.dart';

/// This model represents the user of the app.
class MyUser implements Comparable<MyUser> {
  /// Creates a [MyUser] object.
  MyUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.birthday,
    required this.rank,
    required this.friendIds,
  });

  /// Creates a [MyUser] object from a JSON data map.
  MyUser.fromJson(Map<String, dynamic> data)
    : id = (data[DbColumns.userId] as String?) ?? '',
      firstName = (data[DbColumns.nameFirst] as String?) ?? '',
      lastName = (data[DbColumns.nameLast] as String?) ?? '',
      role = UserRole.fromString(data[DbColumns.role] as String? ?? ''),
      birthday =
          DateTime.tryParse(data[DbColumns.birthday] as String? ?? '') ??
          Defaults.dateTime,
      rank = data[DbColumns.rank] as int?,
      friendIds =
          (data[DbColumns.friendIds] as List?)?.whereType<String>().toList() ??
          [];

  /// Creates an empty [MyUser] object.
  MyUser.empty()
    : id = '',
      firstName = '',
      lastName = '',
      role = UserRole.fromString(''),
      birthday = Defaults.dateTime,
      rank = null,
      friendIds = [];

  /// Whether or not this object is empty.
  bool get isEmpty =>
      id.isEmpty &&
      firstName.isEmpty &&
      lastName.isEmpty &&
      role == UserRole.fromString('') &&
      birthday == Defaults.dateTime &&
      rank == null &&
      friendIds.isEmpty;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// This user's ID in Supabase.
  final String id;

  /// The user's first name.
  String firstName;

  /// The user's last name.
  String lastName;

  /// The user's role in the app.
  UserRole role;

  /// The user's birthday.
  DateTime birthday;

  /// The user's rank in the app.
  int? rank;

  /// The IDs of the user's friends in the app.
  List<String> friendIds;

  /// The full name of the user.
  ///
  /// If the user does not have a first or last name, then an empty string is
  /// returned.
  String get name {
    // Check for the existence of first or last name values.
    if (firstName.isNotEmpty || lastName.isNotEmpty) {
      // Return firstName, lastName, or firstName lastName
      return [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
    }

    // If no name values exist, return empty string.
    return '';
  }

  /// The initials of the user.
  ///
  /// If the user does not have a first or last name, then an empty string is
  /// returned.
  String get initials {
    final String firstInitial = firstName.isNotEmpty ? firstName[0] : '';
    final String lastInitial = lastName.isNotEmpty ? lastName[0] : '';

    return '$firstInitial$lastInitial';
  }

  /// Returns a copy of this object.
  MyUser copy() => copyWith();

  /// Returns a copy of this object with its field values replaced by the ones
  /// provided to this method.
  ///
  /// Since [rank] is nullable, it is defaulted to an empty object in this
  /// method. If left as an empty object, its current value in this [MyUser]
  /// object will be used. This way, if it is `null`, the program will know that
  /// it is intentionally being set to `null`.
  MyUser copyWith({
    String? id,
    String? firstName,
    String? lastName,
    UserRole? role,
    DateTime? birthday,
    Object? rank = Defaults.sentinelValue,
    List<String>? friendIds,
  }) {
    if (!identical(rank, Defaults.sentinelValue)) {
      assert(rank is int?, '`rank` must be a `int?` object');
    }

    return MyUser(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      role: role ?? this.role,
      birthday: birthday ?? this.birthday.copyWith(),
      rank: identical(rank, Defaults.sentinelValue) ? this.rank : rank as int?,
      friendIds: friendIds ?? List<String>.from(this.friendIds),
    );
  }

  /// Returns a JSON representation of the object.
  Map<String, dynamic> toJson() {
    return {
      DbColumns.userId: id,
      DbColumns.nameFirst: firstName,
      DbColumns.nameLast: lastName,
      DbColumns.role: role.value,
      DbColumns.birthday: birthday.toIso8601String(),
      DbColumns.rank: rank,
      DbColumns.friendIds: friendIds,
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
        other.role == role &&
        other.birthday == birthday &&
        other.rank == rank &&
        const DeepCollectionEquality.unordered().equals(
          other.friendIds,
          friendIds,
        );
  }

  @override
  int get hashCode => Object.hash(
    id,
    firstName,
    lastName,
    role,
    birthday,
    rank,
    const DeepCollectionEquality.unordered().hash(friendIds),
  );

  @override
  String toString() =>
      'Instance of MyUser: $id - {'
      'firstName: $firstName, '
      'lastName: $lastName, '
      'role: ${role.value}, '
      'birthday: ${birthday.toIso8601String()}, '
      'rank: $rank, '
      'friendIds: $friendIds'
      '}';

  @override
  int compareTo(MyUser other) {
    // Compare ranks, putting null ranks last.
    if (rank != null && other.rank != null) {
      final int compareRanks = rank!.compareTo(other.rank!);

      if (compareRanks != 0) return compareRanks;
    } else if (rank != null) {
      return -1;
    } else if (other.rank != null) {
      return 1;
    }

    // Compare last names.
    final int compareLastNames = lastName.toLowerCase().compareTo(
      other.lastName.toLowerCase(),
    );

    if (compareLastNames != 0) return compareLastNames;

    // Compare first names.
    final int compareFirstNames = firstName.toLowerCase().compareTo(
      other.firstName.toLowerCase(),
    );

    if (compareFirstNames != 0) return compareFirstNames;

    // Compare IDs.
    return id.compareTo(other.id);
  }
}
