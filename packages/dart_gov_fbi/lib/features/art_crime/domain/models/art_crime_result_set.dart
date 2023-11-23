import 'package:collection/collection.dart';
import 'package:dart_gov_fbi/constants/api_fields.dart';
import 'package:dart_gov_fbi/features/art_crime/domain/models/art_crime.dart';
import 'package:dart_gov_fbi/utils/equality_tool.dart';

/// Represents a set of art crimes from a query of the FBI's database.
class ArtCrimeResultSet {
  /// Creates an [ArtCrimeResultSet] object.
  const ArtCrimeResultSet({
    this.total,
    this.page,
    this.artCrimes,
  });

  /// Creates an [ArtCrimeResultSet] object from a JSON object.
  factory ArtCrimeResultSet.fromJson(Map<String, dynamic> json) {
    final List? artCrimes = json[ApiFields.artCrimes] as List?;

    return ArtCrimeResultSet(
      total: json[ApiFields.total],
      page: json[ApiFields.page],
      artCrimes:
          artCrimes?.map((artCrime) => ArtCrime.fromJson(artCrime)).toList(),
    );
  }

  /// Creates an empty [ArtCrimeResultSet] object.
  ArtCrimeResultSet.empty()
      : total = null,
        page = null,
        artCrimes = null;

  /// Whether or not this [ArtCrimeResultSet] is empty.
  bool get isEmpty => total == null && page == null && artCrimes == null;

  /// Whether or not this [ArtCrimeResultSet] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The total number of art crimes in the FBI's database that matched the
  /// query parameters.
  final int? total;

  /// The current page of art crimes from the FBI's database.
  ///
  /// This is a chunk of art crimes from 1 to 50 in length.
  final int? page;

  /// The list of art crimes.
  final List<ArtCrime>? artCrimes;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.total: total,
      ApiFields.page: page,
      ApiFields.artCrimes: artCrimes?.map((artCrime) => artCrime.toJson()),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ArtCrimeResultSet &&
        other.total.equals(total) &&
        other.page.equals(page) &&
        other.artCrimes.listEquals(artCrimes);
  }

  @override
  int get hashCode => Object.hash(
        total,
        page,
        const DeepCollectionEquality.unordered().hash(artCrimes),
      );

  @override
  String toString() => "Instance of 'ArtCrimeResultSet' ${toJson().toString()}";
}
