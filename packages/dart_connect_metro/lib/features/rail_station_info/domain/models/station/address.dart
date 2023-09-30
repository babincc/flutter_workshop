import 'package:dart_connect_metro/constants/api_fields.dart';

/// Represents the address of a station.
class Address {
  /// Creates a new [Address] instance.
  const Address({
    required this.city,
    required this.state,
    required this.street,
    required this.zip,
  });

  /// Creates a new [Address] instance from a JSON object.
  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      city: json[ApiFields.city] ?? '',
      state: json[ApiFields.state] ?? '',
      street: json[ApiFields.street] ?? '',
      zip: json[ApiFields.zip] ?? '',
    );
  }

  /// Creates an empty [Address] instance.
  Address.empty()
      : city = '',
        state = '',
        street = '',
        zip = '';

  /// Whether or not this [Address] instance is empty.
  bool get isEmpty =>
      city.isEmpty && state.isEmpty && street.isEmpty && zip.isEmpty;

  /// Whether or not this [Address] instance is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The city name.
  final String city;

  /// The state name (abbreviated).
  final String state;

  /// The street name and number.
  final String street;

  /// The zip code.
  final String zip;

  /// Returns a JSON representation of this [Address] instance.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.city: city,
      ApiFields.state: state,
      ApiFields.street: street,
      ApiFields.zip: zip,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is Address &&
        other.city == city &&
        other.state == state &&
        other.street == street &&
        other.zip == zip;
  }

  @override
  int get hashCode => Object.hash(
        city,
        state,
        street,
        zip,
      );

  @override
  String toString() => "Instance of 'Address' ${toJson().toString()}";
}
