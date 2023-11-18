import 'package:dart_gov_fbi/constants/api_fields.dart';
import 'package:dart_gov_fbi/features/art_crime/domain/models/art_crime.dart';
import 'package:dart_gov_fbi/features/art_crime/domain/models/art_crime_result_set.dart';
import 'package:dart_gov_fbi/features/art_crime/domain/services/art_crime_service.dart';

/// Fetches all art crimes.
///
/// !!! WARNING !!!
/// This method will trigger CloudFlare to block your IP address for a few
/// minutes. It makes too many requests too quickly.
/// !!! WARNING !!!
Future<List<ArtCrime>> fetchAllArtCrimes() async {
  final List<ArtCrime> artCrimes = [];

  // Fetch all art crimes by iterating through every page.
  for (int i = 1; i < double.infinity; i++) {
    final ArtCrimeResultSet artCrimesResultSet = await fetchArtCrimes(
      pageSize: 50,
      page: i,
    );

    // Once we reach the end of the art crimes, break out of the loop.
    if (artCrimesResultSet.total == null ||
        artCrimesResultSet.total! == 0 ||
        artCrimesResultSet.artCrimes == null ||
        artCrimesResultSet.artCrimes!.isEmpty) {
      break;
    }

    artCrimes.addAll(artCrimesResultSet.artCrimes!);
  }

  final List<ArtCrime> uniqueArtCrimes = [];

  // Remove duplicates.
  for (final ArtCrime artCrime in artCrimes) {
    if (!uniqueArtCrimes.contains(artCrime)) {
      uniqueArtCrimes.add(artCrime);
    }
  }

  return uniqueArtCrimes;
}

/// Fetches art crimes with the given parameters.
///
/// `pageSize` is the number of items to return per page. The FBI API does not
/// specify a maximum value, but it appears to be `50`.
///
/// `page` is the page number to return.
///
/// `sortOn` is the field to sort on. Note: The FBI API does not specify this,
/// but it appears [ArtCrimeSortOn.publication] is deprecated.
///
/// `sortDirection` is the direction to sort in.
///
/// `title` is the title of the art piece involved in the desired crimes.
///
/// `crimeCategory` is the category the art piece involved in the desired crimes
/// fall into.
///
/// `maker` is the maker of the art piece involved in the desired crimes.
///
/// `referenceNumber` is the reference number of the art piece involved in the
/// desired crimes.
Future<ArtCrimeResultSet> fetchArtCrimes({
  int pageSize = 50,
  int page = 1,
  ArtCrimeSortOn sortOn = ArtCrimeSortOn.modified,
  ArtCrimeSortDirection sortDirection = ArtCrimeSortDirection.descending,
  String? title,
  String? crimeCategory,
  String? maker,
  String? referenceNumber,
}) async {
  return await ArtCrimeService.fetchArtCrimes(
    pageSize: pageSize,
    page: page,
    sortOn: sortOn.value,
    sortOrder: sortDirection.value,
    title: title,
    crimeCategory: crimeCategory,
    maker: maker,
    referenceNumber: referenceNumber,
  );
}

/// Fetches an art crime with the given `id`.
Future<ArtCrime> fetchArtCrime(String id) async =>
    await ArtCrimeService.fetchArtCrime(id);

/// The field to sort an art crime query on.
enum ArtCrimeSortOn {
  modified(ApiFields.modified),
  publication(ApiFields.publication);

  const ArtCrimeSortOn(this.value);

  /// The string representation of this [ArtCrimeSortOn].
  final String value;

  /// Get an [ArtCrimeSortOn] from a given string `value`.
  static ArtCrimeSortOn fromString(String value) {
    return values.firstWhere(
      (field) => field.value == value,
      orElse: () => modified,
    );
  }
}

/// The direction to sort an art crime query in.
enum ArtCrimeSortDirection {
  ascending('asc'),
  descending('desc');

  const ArtCrimeSortDirection(this.value);

  /// The string representation of this [ArtCrimeSortDirection].
  final String value;

  /// Get an [ArtCrimeSortDirection] from a given string `value`.
  static ArtCrimeSortDirection fromString(String value) {
    return values.firstWhere(
      (direction) => direction.value == value,
      orElse: () => descending,
    );
  }
}
