import 'dart:math';

/// This method generates and returns a random integer from `min` to `max`
/// (inclusive).
int randInt(int min, int max) {
  // If `min` and `max` are the same number, just return that number.
  if (min == max) {
    return min;
  }

  // If `min` is greater than `max`, swap their values.
  if (min > max) {
    int temp = min;
    min = max;
    max = temp;
  }

  // Find the random number in the range, and return it.
  return Random().nextInt((max + 1) - min) + min;
}

/// This method generates and returns a random double from `min` to `max`
/// (inclusive).
double randDouble(double min, double max) {
  // If `min` and `max` are the same number, just return that number.
  if (min == max) {
    return min;
  }

  // If `min` is greater than `max`, swap their values.
  if (min > max) {
    double temp = min;
    min = max;
    max = temp;
  }

  // Find the random number in the range.
  return (Random().nextDouble() * (max - min)) + min;
}

/// This method converts degrees to radians.
double deg2Rad(num deg) => deg * (pi / 180.0);

/// This method converts radians to degrees.
double rad2Deg(num rad) => rad * (180.0 / pi);
