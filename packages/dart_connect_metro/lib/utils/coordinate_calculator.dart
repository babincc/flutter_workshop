import 'dart:math';

/// Calculate distance between two coordinates in meters.
///
/// `lat1` and `lon1` are the Latitude and Longitude of first coordinate.
///
/// `lat2` and `lon2` are the Latitude and Longitude of second coordinate.
///
/// This is done with the Haversine formula.
double calculateDistance(
  double lat1,
  double lon1,
  double lat2,
  double lon2,
) {
  // Convert to radians.
  final double lat1Radians = _degreesToRadians(lat1);
  final double lon1Radians = _degreesToRadians(lon1);
  final double lat2Radians = _degreesToRadians(lat2);
  final double lon2Radians = _degreesToRadians(lon2);

  /// Radius of the earth in meters.
  const int R = 6371000;

  // Difference between latitudes and longitudes.
  final double dLat = lat2Radians - lat1Radians;
  final double dLon = lon2Radians - lon1Radians;

  // Haversine formula.
  final double a = pow(sin(dLat / 2), 2) +
      cos(lat1Radians) * cos(lat2Radians) * pow(sin(dLon / 2), 2);
  final double c = 2 * atan2(sqrt(a), sqrt(1 - a));

  // Calculate distance.
  return R * c;
}

/// Converts degrees to radians.
double _degreesToRadians(double degrees) => degrees * (pi / 180);
