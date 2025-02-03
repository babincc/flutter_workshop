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

/// This method generates and returns a random integer from `min` to `max`
/// (inclusive), excluding `exclude`.
///
/// If `min`, `max`, and `exclude` are all the same number, an exception is
/// thrown.
int randIntExcluding(int min, int max, int exclude) {
  // If `min`, `max`, and `exclude` are all the same number, throw an
  // exception.
  if (min == max && max == exclude) {
    throw Exception('min, max, and exclude cannot all be the same number.');
  }

  // If `min` and `max` are the same number, just return that number.
  if (min == max) {
    return min;
  }

  // If `min` is greater than `max`, swap their values.
  if (min > max) {
    final int temp = min;
    min = max;
    max = temp;
  }

  // If `exclude` is less than `min` or greater than `max`, just return a
  // random number in the range.
  if (exclude < min || exclude > max) {
    return randInt(min, max);
  }

  // If `exclude` is equal to `min` or `max`, return a random number in the
  // range, excluding `exclude`.
  if (exclude == min) {
    return randInt(min + 1, max);
  } else if (exclude == max) {
    return randInt(min, max - 1);
  }

  // Random numbers on both sides of `exclude`.
  List<int> randNums = [];

  // Generate a random number in the range, excluding `exclude`.
  randNums.add(randInt(min, exclude - 1));
  randNums.add(randInt(exclude + 1, max));

  return randNums[randInt(0, 1)];
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
