import 'package:dart_connect_metro/constants/api_fields.dart';
import 'package:dart_connect_metro/features/train_positions/domain/models/service_type.dart';

/// Represents the position of a train.
class TrainPosition {
  /// Creates a new [TrainPosition] object.
  const TrainPosition({
    required this.numCars,
    required this.circuitId,
    this.destinationStationCode,
    required this.directionNum,
    this.lineCode,
    required this.secondsAtLocation,
    required this.serviceType,
    required this.trainId,
    required this.trainNumber,
  });

  /// Creates a new [TrainPosition] object from a JSON map.
  factory TrainPosition.fromJson(Map<String, dynamic> json) {
    return TrainPosition(
      numCars: ((json[ApiFields.carCount] ?? -1) as num).toInt(),
      circuitId: (json[ApiFields.circuitId] ?? -1).toString(),
      destinationStationCode: json[ApiFields.destinationStationCode],
      directionNum: ((json[ApiFields.directionNum] ?? -1) as num).toInt(),
      lineCode: json[ApiFields.lineCode],
      secondsAtLocation:
          ((json[ApiFields.secondsAtLocation] ?? -1) as num).toInt(),
      serviceType: ServiceType.fromString(
          json[ApiFields.serviceType] ?? ServiceType.unknown.value),
      trainId: json[ApiFields.trainId] ?? '',
      trainNumber: json[ApiFields.trainNumber] ?? '',
    );
  }

  /// Creates an empty [TrainPosition] object.
  const TrainPosition.empty()
      : numCars = -1,
        circuitId = '-1',
        destinationStationCode = null,
        directionNum = -1,
        lineCode = null,
        secondsAtLocation = -1,
        serviceType = ServiceType.unknown,
        trainId = '',
        trainNumber = '';

  /// Whether or not this [TrainPosition] object is empty.
  bool get isEmpty =>
      numCars == -1 &&
      circuitId == '-1' &&
      destinationStationCode == null &&
      directionNum == -1 &&
      lineCode == null &&
      secondsAtLocation == -1 &&
      identical(serviceType, ServiceType.unknown) &&
      trainId.isEmpty &&
      trainNumber.isEmpty;

  /// Whether or not this [TrainPosition] object is not empty.
  bool get isNotEmpty => !isEmpty;

  /// Number of cars.
  ///
  /// Can sometimes be `0` when there is no data available.
  final int numCars;

  /// The circuit identifier the train is currently on.
  final String circuitId;

  /// Destination station code.
  ///
  /// Can be `null` when there is no data available.
  final String? destinationStationCode;

  /// The direction of movement regardless of which track the train is on.
  ///
  /// Valid values are 1 or 2. Generally speaking, trains with direction 1 are
  /// northbound/eastbound, while trains with direction 2 are
  /// southbound/westbound.
  final int directionNum;

  /// Two-letter abbreviation for the line (e.g.: RD, BL, YL, OR, GR, or SV).
  ///
  /// May also be `null` in certain cases.
  final String? lineCode;

  /// Approximate "dwell time".
  ///
  /// This is not an exact value, but can be used to determine how long a train
  /// has been reported at the same track circuit.
  final int secondsAtLocation;

  /// Service type of the train.
  final ServiceType serviceType;

  /// Unique identifier for the train.
  final String trainId;

  /// Non-unique train identifier, often used by WMATA's Rail Scheduling and
  /// Operations Teams, as well as over open radio communication.
  final String trainNumber;

  /// Returns a JSON representation of this object.
  Map<String, dynamic> toJson() {
    return {
      ApiFields.carCount: numCars,
      ApiFields.circuitId: int.tryParse(circuitId) ?? -1,
      ApiFields.destinationStationCode: destinationStationCode,
      ApiFields.directionNum: directionNum,
      ApiFields.lineCode: lineCode,
      ApiFields.secondsAtLocation: secondsAtLocation,
      ApiFields.serviceType: serviceType.value,
      ApiFields.trainId: trainId,
      ApiFields.trainNumber: trainNumber,
    };
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is TrainPosition &&
        other.numCars == numCars &&
        other.circuitId == circuitId &&
        ((other.destinationStationCode == null &&
                destinationStationCode == null) ||
            ((other.destinationStationCode != null &&
                    destinationStationCode != null) &&
                (other.destinationStationCode == destinationStationCode))) &&
        other.directionNum == directionNum &&
        ((other.lineCode == null && lineCode == null) ||
            ((other.lineCode != null && lineCode != null) &&
                (other.lineCode == lineCode))) &&
        other.secondsAtLocation == secondsAtLocation &&
        other.serviceType == serviceType &&
        other.trainId == trainId &&
        other.trainNumber == trainNumber;
  }

  @override
  int get hashCode => Object.hash(
        numCars,
        circuitId,
        destinationStationCode,
        directionNum,
        lineCode,
        secondsAtLocation,
        serviceType,
        trainId,
        trainNumber,
      );

  @override
  String toString() => "Instance of 'TrainPosition' ${toJson().toString()}";
}
