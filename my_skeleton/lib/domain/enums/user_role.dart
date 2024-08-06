/// The role that a user can have.
enum UserRole {
  normal('Normal'),
  admin('Admin'),
  dev('Dev'),
  tester('Tester'),
  other('Other');

  const UserRole(this.value);

  /// The string representation of this [UserRole].
  final String value;

  /// Get a [UserRole] from a given string `value`.
  static UserRole fromString(String value) {
    return values.firstWhere(
      (role) => role.value == value,
      orElse: () => other,
    );
  }
}
