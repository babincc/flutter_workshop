import 'package:collection/collection.dart';
import 'package:dart_gov_fbi/constants/api_fields.dart';
import 'package:dart_gov_fbi/features/wanted_person/domain/models/wanted_person.dart';
import 'package:dart_gov_fbi/utils/equality_tool.dart';

/// Represents a set of wanted persons from a query of the FBI's database.
class WantedPersonResultSet {
  /// Creates an [WantedPersonResultSet] object.
  const WantedPersonResultSet({
    this.total,
    this.page,
    this.wantedPersons,
  });

  /// Creates a [WantedPersonResultSet] object from a JSON object.
  factory WantedPersonResultSet.fromJson(Map<String, dynamic> json) {
    final List? wantedPersons = json[ApiFields.wantedPersons] as List?;

    return WantedPersonResultSet(
      total: json[ApiFields.total],
      page: json[ApiFields.page],
      wantedPersons: wantedPersons
          ?.map((wantedPerson) => WantedPerson.fromJson(wantedPerson))
          .toList(),
    );
  }

  /// Creates an empty [WantedPersonResultSet] object.
  WantedPersonResultSet.empty()
      : total = null,
        page = null,
        wantedPersons = null;

  /// Whether or not this [WantedPersonResultSet] is empty.
  bool get isEmpty => total == null && page == null && wantedPersons == null;

  /// Whether or not this [WantedPersonResultSet] is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The total number of wanted persons in the FBI's database that matched the
  /// query parameters.
  final int? total;

  /// The current page of wanted persons from the FBI's database.
  ///
  /// This is a chunk of wanted persons from 1 to 50 in length.
  final int? page;

  /// The list of wanted persons.
  final List<WantedPerson>? wantedPersons;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.total: total,
      ApiFields.page: page,
      ApiFields.wantedPersons:
          wantedPersons?.map((wantedPerson) => wantedPerson.toJson()),
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is WantedPersonResultSet &&
        other.total.equals(total) &&
        other.page.equals(page) &&
        other.wantedPersons.listEquals(wantedPersons);
  }

  @override
  int get hashCode => Object.hash(
        total,
        page,
        const DeepCollectionEquality.unordered().hash(wantedPersons),
      );

  @override
  String toString() =>
      "Instance of 'WantedPersonResultSet' ${toJson().toString()}";
}
