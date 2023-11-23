import 'package:dart_gov_fbi/constants/api_fields.dart';
import 'package:dart_gov_fbi/features/wanted_person/domain/models/wanted_person.dart';
import 'package:dart_gov_fbi/features/wanted_person/domain/models/wanted_person_result_set.dart';
import 'package:dart_gov_fbi/features/wanted_person/domain/services/wanted_person_service.dart';

/// Fetches all wanted persons.
///
/// !!! WARNING !!!
/// This method will trigger CloudFlare to block your IP address for a few
/// minutes. It makes too many requests too quickly.
/// !!! WARNING !!!
Future<List<WantedPerson>> fetchAllWantedPersons() async {
  final List<WantedPerson> wantedPersons = [];

  // Fetch all wanted persons by iterating through every page.
  for (int i = 1; i < double.infinity; i++) {
    final WantedPersonResultSet wantedPersonResultSet =
        await fetchWantedPersons(
      pageSize: 50,
      page: i,
    );

    // Once we reach the end of the wanted persons, break out of the loop.
    if (wantedPersonResultSet.total == null ||
        wantedPersonResultSet.total! == 0 ||
        wantedPersonResultSet.wantedPersons == null ||
        wantedPersonResultSet.wantedPersons!.isEmpty) {
      break;
    }

    wantedPersons.addAll(wantedPersonResultSet.wantedPersons!);
  }

  final List<WantedPerson> uniqueWantedPersons = [];

  // Remove duplicates.
  for (final WantedPerson artCrime in wantedPersons) {
    if (!uniqueWantedPersons.contains(artCrime)) {
      uniqueWantedPersons.add(artCrime);
    }
  }

  return uniqueWantedPersons;
}

/// Fetches wanted persons with the given parameters.
///
/// `pageSize` is the number of items to return per page. The FBI API does not
/// specify a maximum value, but it appears to be `50`.
///
/// `page` is the page number to return.
///
/// `sortOn` is the field to sort on. Note: The FBI API does not specify this,
/// but it appears [WantedPersonSortOn.publication] is deprecated.
///
/// `sortDirection` is the direction to sort in.
///
/// `title` is the title of the wanted person.
///
/// `fieldOffices` is the field offices involved in the case.
///
/// `personClassification` is the roll of the wanted person (suspect, victim,
/// etc.).
///
/// `posterClassification` is the type of wanted person (individual, group, etc.).
Future<WantedPersonResultSet> fetchWantedPersons({
  int pageSize = 50,
  int page = 1,
  WantedPersonSortOn sortOn = WantedPersonSortOn.modified,
  WantedPersonSortDirection sortDirection =
      WantedPersonSortDirection.descending,
  String? title,
  List<String>? fieldOffices,
  WantedPersonClassification? personClassification,
  WantedPosterClassification? posterClassification,
  WantedPersonStatus? status,
}) async {
  final StringBuffer fieldOfficesBuffer = StringBuffer();

  String? fieldOfficesString;

  if (fieldOffices != null && fieldOffices.isNotEmpty) {
    fieldOfficesBuffer.writeAll(fieldOffices, ',');
    fieldOfficesString = fieldOfficesBuffer.toString();
  }

  return await WantedPersonService.fetchWantedPersons(
    pageSize: pageSize,
    page: page,
    sortOn: sortOn.value,
    sortOrder: sortDirection.value,
    title: title,
    fieldOffices: fieldOfficesString,
    personClassification: personClassification?.value,
    posterClassification: posterClassification?.value,
    status: status?.value,
  );
}

/// Fetches a wanted person with the given `id`.
Future<WantedPerson> fetchWantedPerson(String id) async =>
    await WantedPersonService.fetchWantedPerson(id);

/// The field to sort a wanted person query on.
enum WantedPersonSortOn {
  modified(ApiFields.modified),
  publication(ApiFields.publication);

  const WantedPersonSortOn(this.value);

  /// The string representation of this [WantedPersonSortOn].
  final String value;

  /// Get an [WantedPersonSortOn] from a given string `value`.
  static WantedPersonSortOn fromString(String value) {
    return values.firstWhere(
      (field) => field.value == value,
      orElse: () => modified,
    );
  }
}

/// The direction to sort an art crime query in.
enum WantedPersonSortDirection {
  ascending('asc'),
  descending('desc');

  const WantedPersonSortDirection(this.value);

  /// The string representation of this [WantedPersonSortDirection].
  final String value;

  /// Get an [WantedPersonSortDirection] from a given string `value`.
  static WantedPersonSortDirection fromString(String value) {
    return values.firstWhere(
      (direction) => direction.value == value,
      orElse: () => descending,
    );
  }
}
