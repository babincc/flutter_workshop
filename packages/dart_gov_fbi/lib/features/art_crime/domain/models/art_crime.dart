import 'package:collection/collection.dart';
import 'package:dart_gov_fbi/constants/api_fields.dart';
import 'package:dart_gov_fbi/domain/models/fbi_image.dart';
import 'package:dart_gov_fbi/utils/equality_tool.dart';

/// Represents an art crime.
class ArtCrime {
  /// Creates an [ArtCrime] object.
  const ArtCrime({
    this.id,
    this.idInAgency,
    this.uid,
    this.title,
    this.description,
    this.images,
    this.crimeCategory,
    this.maker,
    this.materials,
    this.measurements,
    this.period,
    this.additionalData,
    this.modified,
    this.publication,
    this.path,
    this.referenceNumber,
    this.isStealth,
  });

  /// Creates an [ArtCrime] object from a JSON object.
  factory ArtCrime.fromJson(Map<String, dynamic> json) {
    String? id = json[ApiFields.id];

    if (id != null) {
      id = id.replaceAll('https://api.fbi.gov/@artcrimes/', '');
    }

    return ArtCrime(
      id: id,
      idInAgency: json[ApiFields.idInAgency],
      uid: json[ApiFields.uid],
      title: json[ApiFields.title],
      description: json[ApiFields.description],
      images: (json[ApiFields.images] as List?)
          ?.map((artCrime) => FbiImage.fromJson(artCrime))
          .toList(),
      crimeCategory: json[ApiFields.crimeCategory],
      maker: json[ApiFields.maker],
      materials: json[ApiFields.materials],
      measurements: json[ApiFields.measurements],
      period: json[ApiFields.period],
      additionalData: json[ApiFields.additionalData],
      modified: json[ApiFields.modified],
      publication: json[ApiFields.publication],
      path: json[ApiFields.path],
      referenceNumber: json[ApiFields.referenceNumber],
      isStealth: json[ApiFields.isStealth],
    );
  }

  /// Creates an empty [ArtCrime] object.
  ArtCrime.empty()
      : id = null,
        idInAgency = null,
        uid = null,
        title = null,
        description = null,
        images = null,
        crimeCategory = null,
        maker = null,
        materials = null,
        measurements = null,
        period = null,
        additionalData = null,
        modified = null,
        publication = null,
        path = null,
        referenceNumber = null,
        isStealth = null;

  /// Whether or not this object is empty.
  bool get isEmpty =>
      id == null &&
      idInAgency == null &&
      uid == null &&
      title == null &&
      description == null &&
      images == null &&
      crimeCategory == null &&
      maker == null &&
      materials == null &&
      measurements == null &&
      period == null &&
      additionalData == null &&
      modified == null &&
      publication == null &&
      path == null &&
      referenceNumber == null &&
      isStealth == null;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The ID of the art crime.
  ///
  /// Usually the same as [uid].
  final String? id;

  /// The ID of the art crime in the agency's database.
  ///
  /// Usually the same as [referenceNumber].
  final String? idInAgency;

  /// The ID of the art crime.
  ///
  /// Usually the same as [id].
  final String? uid;

  /// The title of the art piece involved in this crime.
  final String? title;

  /// A description of the art piece involved in this crime and/or the crime
  /// itself.
  final String? description;

  /// Images of the art piece involved in this crime.
  final List<FbiImage>? images;

  /// What category the art piece involved in this crime falls into.
  ///
  /// Examples: "paintings", "sculpture", "print", etc.
  final String? crimeCategory;

  /// The artist of the art piece involved in this crime.
  final String? maker;

  /// The materials used in the art piece involved in this crime.
  final String? materials;

  /// The dimensions of the art piece involved in this crime.
  final String? measurements;

  /// The historical period during which the art piece involved in this crime
  /// was created.
  final String? period;

  /// Additional notes about the art piece involved in this crime and/or the
  /// crime itself.
  final String? additionalData;

  /// The date and time when this art crime was last modified.
  final String? modified;

  /// The date and time of the publication of this art crime.
  final String? publication;

  /// The URL path of the case file for this art crime.
  ///
  /// This comes after "https://artcrimes.fbi.gov"
  final String? path;

  /// The reference number of the art crime.
  ///
  /// Usually the same as [idInAgency].
  final String? referenceNumber;

  final bool? isStealth;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.id: id,
      ApiFields.idInAgency: idInAgency,
      ApiFields.uid: uid,
      ApiFields.title: title,
      ApiFields.description: description,
      ApiFields.images: images?.map((image) => image.toJson()).toList(),
      ApiFields.crimeCategory: crimeCategory,
      ApiFields.maker: maker,
      ApiFields.materials: materials,
      ApiFields.measurements: measurements,
      ApiFields.period: period,
      ApiFields.additionalData: additionalData,
      ApiFields.modified: modified,
      ApiFields.publication: publication,
      ApiFields.path: path,
      ApiFields.referenceNumber: referenceNumber,
      ApiFields.isStealth: isStealth,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is ArtCrime &&
        other.id.equals(id) &&
        other.idInAgency.equals(idInAgency) &&
        other.uid.equals(uid) &&
        other.title.equals(title) &&
        other.description.equals(description) &&
        other.images.listEquals(images) &&
        other.crimeCategory.equals(crimeCategory) &&
        other.maker.equals(maker) &&
        other.materials.equals(materials) &&
        other.measurements.equals(measurements) &&
        other.period.equals(period) &&
        other.additionalData.equals(additionalData) &&
        other.modified.equals(modified) &&
        other.publication.equals(publication) &&
        other.path.equals(path) &&
        other.referenceNumber.equals(referenceNumber) &&
        other.isStealth.equals(isStealth);
  }

  @override
  int get hashCode => Object.hash(
        id,
        idInAgency,
        uid,
        title,
        description,
        const DeepCollectionEquality.unordered().hash(images),
        crimeCategory,
        maker,
        materials,
        measurements,
        period,
        additionalData,
        modified,
        publication,
        path,
        referenceNumber,
        isStealth,
      );

  @override
  String toString() => "Instance of 'ArtCrime' ${toJson().toString()}";
}
