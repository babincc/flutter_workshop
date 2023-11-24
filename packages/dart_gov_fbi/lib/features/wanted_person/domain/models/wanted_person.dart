import 'package:collection/collection.dart';
import 'package:dart_gov_fbi/constants/api_fields.dart';
import 'package:dart_gov_fbi/domain/models/fbi_image.dart';
import 'package:dart_gov_fbi/features/wanted_person/domain/models/wanted_person_coordinates.dart';
import 'package:dart_gov_fbi/features/wanted_person/domain/models/wanted_person_file.dart';
import 'package:dart_gov_fbi/utils/equality_tool.dart';

/// Represents a wanted person.
class WantedPerson {
  /// Creates a [WantedPerson] object.
  const WantedPerson({
    this.id,
    this.uid,
    this.title,
    this.aliases,
    this.description,
    this.images,
    this.files,
    this.warningMessage,
    this.remarks,
    this.details,
    this.additionalInfo,
    this.caution,
    this.rewardText,
    this.rewardMin,
    this.rewardMax,
    this.datesOfBirthUsed,
    this.placeOfBirth,
    this.locations,
    this.coordinates,
    this.fieldOffices,
    this.legatNames,
    this.status,
    this.personClassification,
    this.posterClassification,
    this.subjects,
    this.ncic,
    this.ageText,
    this.ageMin,
    this.ageMax,
    this.weightLbsText,
    this.weightLbsMin,
    this.weightLbsMax,
    this.heightInchesMin,
    this.heightInchesMax,
    this.eyeColor,
    this.eyesRaw,
    this.hairColor,
    this.hairRaw,
    this.build,
    this.sex,
    this.race,
    this.raceRaw,
    this.nationality,
    this.complexion,
    this.scarsAndMarks,
    this.occupations,
    this.possibleCountries,
    this.possibleStates,
    this.modified,
    this.publication,
    this.path,
    this.languages,
    this.suspects,
  });

  /// Creates a [WantedPerson] object from a JSON object.
  factory WantedPerson.fromJson(Map<String, dynamic> json) {
    String? id = json[ApiFields.id];

    if (id != null) {
      id = id.replaceAll('https://api.fbi.gov/@wanted-person/', '');
    }

    return WantedPerson(
      id: id,
      uid: json[ApiFields.uid],
      title: json[ApiFields.title],
      aliases: (json[ApiFields.aliases] as List?)
          ?.map((alias) => alias.toString())
          .toList(),
      description: json[ApiFields.description],
      images: (json[ApiFields.images] as List?)
          ?.map((wantedPerson) => FbiImage.fromJson(wantedPerson))
          .toList(),
      files: (json[ApiFields.files] as List?)
          ?.map((file) => WantedPersonFile.fromJson(file))
          .toList(),
      warningMessage: json[ApiFields.warningMessage],
      remarks: json[ApiFields.remarks],
      details: json[ApiFields.details],
      additionalInfo: json[ApiFields.additionalInfo],
      caution: json[ApiFields.caution],
      rewardText: json[ApiFields.rewardText],
      rewardMin: ((json[ApiFields.rewardMin]) as num?)?.toInt(),
      rewardMax: ((json[ApiFields.rewardMax]) as num?)?.toInt(),
      datesOfBirthUsed: (json[ApiFields.datesOfBirthUsed] as List?)
          ?.map((date) => date.toString())
          .toList(),
      placeOfBirth: json[ApiFields.placeOfBirth],
      locations: (json[ApiFields.locations] as List?)
          ?.map((location) => location.toString())
          .toList(),
      coordinates: (json[ApiFields.coordinates] as List?)
          ?.map((coordinate) => WantedPersonCoordinates.fromJson(coordinate))
          .toList(),
      fieldOffices: (json[ApiFields.fieldOffices] as List?)
          ?.map((office) => office.toString())
          .toList(),
      legatNames: (json[ApiFields.legatNames] as List?)
          ?.map((legat) => legat.toString())
          .toList(),
      status: json[ApiFields.status] == null
          ? null
          : WantedPersonStatus.fromString(json[ApiFields.status]),
      personClassification: json[ApiFields.personClassification] == null
          ? null
          : WantedPersonClassification.fromString(
              json[ApiFields.personClassification]),
      posterClassification: json[ApiFields.posterClassification] == null
          ? null
          : WantedPosterClassification.fromString(
              json[ApiFields.posterClassification]),
      subjects: (json[ApiFields.subjects] as List?)
          ?.map((subject) => subject.toString())
          .toList(),
      ncic: json[ApiFields.ncic],
      ageText: json[ApiFields.ageText],
      ageMin: ((json[ApiFields.ageMin]) as num?)?.toInt(),
      ageMax: ((json[ApiFields.ageMax]) as num?)?.toInt(),
      weightLbsText: json[ApiFields.weight],
      weightLbsMin: ((json[ApiFields.weightMin]) as num?)?.toInt(),
      weightLbsMax: ((json[ApiFields.weightMax]) as num?)?.toInt(),
      heightInchesMin: ((json[ApiFields.heightMin]) as num?)?.toInt(),
      heightInchesMax: ((json[ApiFields.heightMax]) as num?)?.toInt(),
      eyeColor: json[ApiFields.eyes],
      eyesRaw: json[ApiFields.eyesRaw],
      hairColor: json[ApiFields.hair],
      hairRaw: json[ApiFields.hairRaw],
      build: json[ApiFields.build],
      sex: json[ApiFields.sex],
      race: json[ApiFields.race],
      raceRaw: json[ApiFields.raceRaw],
      nationality: json[ApiFields.nationality],
      complexion: json[ApiFields.complexion],
      scarsAndMarks: json[ApiFields.scarsAndMarks],
      occupations: (json[ApiFields.occupations] as List?)
          ?.map((occupation) => occupation.toString())
          .toList(),
      possibleCountries: (json[ApiFields.possibleCountries] as List?)
          ?.map((country) => country.toString())
          .toList(),
      possibleStates: (json[ApiFields.possibleStates] as List?)
          ?.map((state) => state.toString())
          .toList(),
      modified: json[ApiFields.modified],
      publication: json[ApiFields.publication],
      path: json[ApiFields.path],
      languages: (json[ApiFields.languages] as List?)
          ?.map((language) => language.toString())
          .toList(),
      suspects: json[ApiFields.suspects],
    );
  }

  /// Creates an empty [WantedPerson] object.
  WantedPerson.empty()
      : id = null,
        uid = null,
        title = null,
        aliases = null,
        description = null,
        images = null,
        files = null,
        warningMessage = null,
        remarks = null,
        details = null,
        additionalInfo = null,
        caution = null,
        rewardText = null,
        rewardMin = null,
        rewardMax = null,
        datesOfBirthUsed = null,
        placeOfBirth = null,
        locations = null,
        coordinates = null,
        fieldOffices = null,
        legatNames = null,
        status = null,
        personClassification = null,
        posterClassification = null,
        subjects = null,
        ncic = null,
        ageText = null,
        ageMin = null,
        ageMax = null,
        weightLbsText = null,
        weightLbsMin = null,
        weightLbsMax = null,
        heightInchesMin = null,
        heightInchesMax = null,
        eyeColor = null,
        eyesRaw = null,
        hairColor = null,
        hairRaw = null,
        build = null,
        sex = null,
        race = null,
        raceRaw = null,
        nationality = null,
        complexion = null,
        scarsAndMarks = null,
        occupations = null,
        possibleCountries = null,
        possibleStates = null,
        modified = null,
        publication = null,
        path = null,
        languages = null,
        suspects = null;

  /// Whether or not this object is empty.
  bool get isEmpty =>
      id == null &&
      uid == null &&
      title == null &&
      aliases == null &&
      description == null &&
      images == null &&
      files == null &&
      warningMessage == null &&
      remarks == null &&
      details == null &&
      additionalInfo == null &&
      caution == null &&
      rewardText == null &&
      rewardMin == null &&
      rewardMax == null &&
      datesOfBirthUsed == null &&
      placeOfBirth == null &&
      locations == null &&
      coordinates == null &&
      fieldOffices == null &&
      legatNames == null &&
      status == null &&
      personClassification == null &&
      posterClassification == null &&
      subjects == null &&
      ncic == null &&
      ageText == null &&
      ageMin == null &&
      ageMax == null &&
      weightLbsText == null &&
      weightLbsMin == null &&
      weightLbsMax == null &&
      heightInchesMin == null &&
      heightInchesMax == null &&
      eyeColor == null &&
      eyesRaw == null &&
      hairColor == null &&
      hairRaw == null &&
      build == null &&
      sex == null &&
      race == null &&
      raceRaw == null &&
      nationality == null &&
      complexion == null &&
      scarsAndMarks == null &&
      occupations == null &&
      possibleCountries == null &&
      possibleStates == null &&
      modified == null &&
      publication == null &&
      path == null &&
      languages == null &&
      suspects == null;

  /// Whether or not this object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// The ID of the wanted person case.
  ///
  /// Usually the same as [uid].
  final String? id;

  /// The ID of the wanted person case.
  ///
  /// Usually the same as [id].
  final String? uid;

  /// The title of the this wanted person case.
  ///
  /// Usually the wanted person's name.
  final String? title;

  /// Aliases or nicknames of the wanted person.
  final List<String>? aliases;

  /// A description of this wanted person case.
  ///
  /// Usually just keywords and highlights.
  ///
  /// See [details] for more detailed information.
  final String? description;

  /// Images of the wanted person and possibly other related individuals.
  final List<FbiImage>? images;

  /// The case files of this wanted person case.
  final List<WantedPersonFile>? files;

  /// Warnings about this wanted person.
  ///
  /// Examples: "SHOULD BE CONSIDERED ARMED AND DANGEROUS" and "SHOULD BE
  /// CONSIDERED AN ESCAPE RISK"
  final String? warningMessage;

  /// Like [additionalInfo], but more dynamic.
  ///
  /// This might include something like last known location.
  final String? remarks;

  /// The details of this wanted person case.
  ///
  /// Usually more detailed than [description].
  final String? details;

  /// Additional notes about this wanted person case.
  final String? additionalInfo;

  /// Additional details that are considered very important.
  final String? caution;

  /// A written out explanation of the reward being offered for this wanted
  /// person.
  final String? rewardText;

  /// The minimum reward amount for this wanted person.
  final int? rewardMin;

  /// The maximum reward amount for this wanted person.
  final int? rewardMax;

  /// All of the possible dates of birth for the wanted person.
  ///
  /// This could be a known date of birth or any number of dates of birth they
  /// may have used for an alias.
  final List<String>? datesOfBirthUsed;

  /// The place of birth of the wanted person.
  final String? placeOfBirth;

  /// Locations where the wanted person has been known to live or frequent.
  final List<String>? locations;

  /// Coordinates of where the wanted person is believed to be.
  final List<WantedPersonCoordinates>? coordinates;

  /// The field offices involved in this wanted person case.
  final List<String>? fieldOffices;

  /// The legats involved in this wanted person case.
  ///
  /// A Legal Attaché, or Legat, is an FBI agent who heads an international
  /// office.
  final List<String>? legatNames;

  /// The status of this wanted person case.
  final WantedPersonStatus? status;

  /// The person's roll in this wanted person case.
  ///
  /// Examples: "Main", "Victim", "Accomplice"
  final WantedPersonClassification? personClassification;

  /// The classification of this wanter person case on an FBI wanted poster.
  ///
  /// This is similar to [subjects].
  final WantedPosterClassification? posterClassification;

  /// A list of the subjects of this wanted person case.
  ///
  /// This is very similar to [posterClassification].
  final List<String>? subjects;

  /// The ID of this wanted person case in the National Crime Information
  /// Center.
  final String? ncic;

  /// A written out explanation of the age range of the wanted person.
  final String? ageText;

  /// The minimum estimated age of the wanted person.
  final int? ageMin;

  /// The maximum estimated age of the wanted person.
  final int? ageMax;

  /// A written out explanation of the weight range of the wanted person.
  final String? weightLbsText;

  /// The minimum estimated weight (in pounds) of the wanted person.
  final int? weightLbsMin;

  /// The maximum estimated weight (in pounds) of the wanted person.
  final int? weightLbsMax;

  /// The minimum estimated height (in inches) of the wanted person.
  final int? heightInchesMin;

  /// The maximum estimated height (in inches) of the wanted person.
  final int? heightInchesMax;

  /// A written out explanation of the height range (in inches) of the wanted
  /// person.
  String? get heightInchesText {
    if (heightInchesMin == null && heightInchesMax == null) {
      return null;
    }

    StringBuffer heightBuffer = StringBuffer();

    if (heightInchesMin != null) {
      heightBuffer.write('$heightInchesMin"');
    }

    if (heightInchesMax != null && heightInchesMin != heightInchesMax) {
      if (heightBuffer.isNotEmpty) {
        heightBuffer.write(' to ');
      }
      heightBuffer.write('$heightInchesMax"');
    }

    return heightBuffer.toString();
  }

  /// A written out explanation of the height range (in feet and inches) of the
  /// wanted person.
  String? get heightFeetText {
    if (heightInchesMin == null && heightInchesMax == null) {
      return null;
    }

    StringBuffer heightBuffer = StringBuffer();

    if (heightInchesMin != null) {
      heightBuffer.write('${heightInchesMin! ~/ 12}\'');
      heightBuffer.write('${heightInchesMin! % 12}"');
    }

    if (heightInchesMax != null && heightInchesMin != heightInchesMax) {
      if (heightBuffer.isNotEmpty) {
        heightBuffer.write(' to ');
      }
      heightBuffer.write('${heightInchesMax! ~/ 12}\'');
      heightBuffer.write('${heightInchesMax! % 12}"');
    }

    return heightBuffer.toString();
  }

  /// The color of the wanted person's eyes.
  ///
  /// Usually the same as [eyesRaw].
  final String? eyeColor;

  /// The color of the wanted person's eyes.
  ///
  /// Usually the same as [eyeColor].
  final String? eyesRaw;

  /// The color of the wanted person's hair.
  final String? hairColor;

  /// A description of the wanted person's hair.
  ///
  /// This could include color, length, style, etc.
  final String? hairRaw;

  /// The body type/build of the wanted person.
  final String? build;

  /// The sex of the wanted person.
  final String? sex;

  /// The race of the wanted person.
  ///
  /// Usually the same as [raceRaw].
  final String? race;

  /// The race of the wanted person.
  ///
  /// Usually the same as [race].
  final String? raceRaw;

  /// The nationality of the wanted person.
  final String? nationality;

  /// The complexion of the wanted person.
  final String? complexion;

  /// Any scars and marks on the wanted person.
  ///
  /// This includes tattoos.
  final String? scarsAndMarks;

  /// The occupation(s) of the wanted person.
  final List<String>? occupations;

  /// The possible countries the wanted person may be in.
  final List<String>? possibleCountries;

  /// The possible states the wanted person may be in.
  final List<String>? possibleStates;

  /// The date and time when this wanted person case was last modified.
  final String? modified;

  /// The date and time of the publication of this wanted person case.
  final String? publication;

  /// The URL path of this wanted person case.
  ///
  /// This comes after "https://artcrimes.fbi.gov"
  final String? path;

  /// Languages the wanted person may speak.
  ///
  /// This might also include accents.
  final List<String>? languages;

  /// Any information about possible suspects.
  final String? suspects;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.id: id,
      ApiFields.uid: uid,
      ApiFields.title: title,
      ApiFields.aliases: aliases,
      ApiFields.description: description,
      ApiFields.images: images?.map((image) => image.toJson()).toList(),
      ApiFields.files: files?.map((file) => file.toJson()).toList(),
      ApiFields.warningMessage: warningMessage,
      ApiFields.remarks: remarks,
      ApiFields.details: details,
      ApiFields.additionalInfo: additionalInfo,
      ApiFields.caution: caution,
      ApiFields.rewardText: rewardText,
      ApiFields.rewardMin: rewardMin,
      ApiFields.rewardMax: rewardMax,
      ApiFields.datesOfBirthUsed: datesOfBirthUsed,
      ApiFields.placeOfBirth: placeOfBirth,
      ApiFields.locations: locations,
      ApiFields.coordinates:
          coordinates?.map((coordinate) => coordinate.toJson()).toList(),
      ApiFields.fieldOffices: fieldOffices,
      ApiFields.legatNames: legatNames,
      ApiFields.status: status?.value,
      ApiFields.personClassification: personClassification?.value,
      ApiFields.posterClassification: posterClassification?.value,
      ApiFields.subjects: subjects,
      ApiFields.ncic: ncic,
      ApiFields.ageText: ageText,
      ApiFields.ageMin: ageMin,
      ApiFields.ageMax: ageMax,
      ApiFields.weight: weightLbsText,
      ApiFields.weightMin: weightLbsMin,
      ApiFields.weightMax: weightLbsMax,
      ApiFields.heightMin: heightInchesMin,
      ApiFields.heightMax: heightInchesMax,
      ApiFields.eyes: eyeColor,
      ApiFields.eyesRaw: eyesRaw,
      ApiFields.hair: hairColor,
      ApiFields.hairRaw: hairRaw,
      ApiFields.build: build,
      ApiFields.sex: sex,
      ApiFields.race: race,
      ApiFields.raceRaw: raceRaw,
      ApiFields.nationality: nationality,
      ApiFields.complexion: complexion,
      ApiFields.scarsAndMarks: scarsAndMarks,
      ApiFields.occupations: occupations,
      ApiFields.possibleCountries: possibleCountries,
      ApiFields.possibleStates: possibleStates,
      ApiFields.modified: modified,
      ApiFields.publication: publication,
      ApiFields.path: path,
      ApiFields.languages: languages,
      ApiFields.suspects: suspects,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is WantedPerson &&
        other.id.equals(id) &&
        other.uid.equals(uid) &&
        other.title.equals(title) &&
        other.aliases.listEquals(aliases) &&
        other.description.equals(description) &&
        other.images.listEquals(images) &&
        other.files.listEquals(files) &&
        other.warningMessage.equals(warningMessage) &&
        other.remarks.equals(remarks) &&
        other.details.equals(details) &&
        other.additionalInfo.equals(additionalInfo) &&
        other.caution.equals(caution) &&
        other.rewardText.equals(rewardText) &&
        other.rewardMin.equals(rewardMin) &&
        other.rewardMax.equals(rewardMax) &&
        other.datesOfBirthUsed.listEquals(datesOfBirthUsed) &&
        other.placeOfBirth.equals(placeOfBirth) &&
        other.locations.listEquals(locations) &&
        other.coordinates.listEquals(coordinates) &&
        other.fieldOffices.listEquals(fieldOffices) &&
        other.legatNames.listEquals(legatNames) &&
        other.status.equals(status) &&
        other.personClassification.equals(personClassification) &&
        other.posterClassification.equals(posterClassification) &&
        other.subjects.listEquals(subjects) &&
        other.ncic.equals(ncic) &&
        other.ageText.equals(ageText) &&
        other.ageMin.equals(ageMin) &&
        other.ageMax.equals(ageMax) &&
        other.weightLbsText.equals(weightLbsText) &&
        other.weightLbsMin.equals(weightLbsMin) &&
        other.weightLbsMax.equals(weightLbsMax) &&
        other.heightInchesMin.equals(heightInchesMin) &&
        other.heightInchesMax.equals(heightInchesMax) &&
        other.eyeColor.equals(eyeColor) &&
        other.eyesRaw.equals(eyesRaw) &&
        other.hairColor.equals(hairColor) &&
        other.hairRaw.equals(hairRaw) &&
        other.build.equals(build) &&
        other.sex.equals(sex) &&
        other.race.equals(race) &&
        other.raceRaw.equals(raceRaw) &&
        other.nationality.equals(nationality) &&
        other.complexion.equals(complexion) &&
        other.scarsAndMarks.equals(scarsAndMarks) &&
        other.occupations.listEquals(occupations) &&
        other.possibleCountries.listEquals(possibleCountries) &&
        other.possibleStates.listEquals(possibleStates) &&
        other.modified.equals(modified) &&
        other.publication.equals(publication) &&
        other.path.equals(path) &&
        other.languages.listEquals(languages) &&
        other.suspects.equals(suspects);
  }

  @override
  int get hashCode => Object.hash(
        Object.hash(
          id,
          uid,
          title,
          const DeepCollectionEquality.unordered().hash(aliases),
          description,
          const DeepCollectionEquality.unordered().hash(images),
          const DeepCollectionEquality.unordered().hash(files),
          warningMessage,
          remarks,
          details,
          additionalInfo,
          caution,
          rewardText,
          rewardMin,
          rewardMax,
          const DeepCollectionEquality.unordered().hash(datesOfBirthUsed),
          placeOfBirth,
          const DeepCollectionEquality.unordered().hash(locations),
          const DeepCollectionEquality.unordered().hash(coordinates),
          const DeepCollectionEquality.unordered().hash(fieldOffices),
        ),
        Object.hash(
          const DeepCollectionEquality.unordered().hash(legatNames),
          status,
          personClassification,
          posterClassification,
          const DeepCollectionEquality.unordered().hash(subjects),
          ncic,
          ageText,
          ageMin,
          ageMax,
          weightLbsText,
          weightLbsMin,
          weightLbsMax,
          heightInchesMin,
          heightInchesMax,
          eyeColor,
          eyesRaw,
          hairColor,
          hairRaw,
          build,
          sex,
        ),
        race,
        raceRaw,
        nationality,
        complexion,
        scarsAndMarks,
        const DeepCollectionEquality.unordered().hash(occupations),
        const DeepCollectionEquality.unordered().hash(possibleCountries),
        const DeepCollectionEquality.unordered().hash(possibleStates),
        modified,
        publication,
        path,
        const DeepCollectionEquality.unordered().hash(languages),
        suspects,
      );

  @override
  String toString() => "Instance of 'WantedPerson' ${toJson().toString()}";
}

/// The status of a wanted person case.
enum WantedPersonStatus {
  /// Not applicable
  na('na'),

  /// The individual has been apprehended or taken into custody by law
  /// enforcement.
  captured('captured'),

  /// The individual has been recovered.
  recovered('recovered'),

  /// The individual has been located, but not captured or recovered.
  located('located'),

  /// The wanted person has voluntarily turned themselves in to law enforcement.
  surrendered('surrendered'),

  /// The person in question has died.
  deceased('deceased'),

  unknown('Unknown');

  const WantedPersonStatus(this.value);

  /// The string representation of this [WantedPersonStatus].
  final String value;

  /// Get an [WantedPersonStatus] from a given string `value`.
  static WantedPersonStatus fromString(String value) {
    return values.firstWhere(
      (status) => status.value == value,
      orElse: () => unknown,
    );
  }
}

/// A person's roll in a wanted person case.
enum WantedPersonClassification {
  main('Main'),
  victim('Victim'),
  accomplice('Accomplice'),
  unknown('Unknown');

  const WantedPersonClassification(this.value);

  /// The string representation of this [WantedPersonClassification].
  final String value;

  /// Get an [WantedPersonClassification] from a given string `value`.
  static WantedPersonClassification fromString(String value) {
    return values.firstWhere(
      (roll) => roll.value == value,
      orElse: () => unknown,
    );
  }
}

/// The classification of a wanted poster.
enum WantedPosterClassification {
  /// Violent, cyber, white collar, criminal enterprise, etc
  standard('default'),

  /// Ten most wanted
  ten('ten'),

  /// Terrorist
  terrorist('terrorist'),

  /// Seeking information
  information('information'),

  /// Kidnapping
  kidnapping('kidnapping'),

  /// Missing persons
  missing('missing'),

  /// Most wanted
  most('most'),

  /// Crimes against children
  crimesAgainstChildren('crimes-against-children'),

  /// Endangered Child Alert Program
  ecap('ecap'),

  /// Law enforcement assistance
  lawEnforcementAssistance('law-enforcement-assistance'),

  unknown('Unknown');

  const WantedPosterClassification(this.value);

  /// The string representation of this [WantedPosterClassification].
  final String value;

  /// Get an [WantedPosterClassification] from a given string `value`.
  static WantedPosterClassification fromString(String value) {
    return values.firstWhere(
      (classification) => classification.value == value,
      orElse: () => unknown,
    );
  }
}
