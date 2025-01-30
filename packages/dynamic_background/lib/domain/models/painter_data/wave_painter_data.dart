import 'package:collection/collection.dart';
import 'package:dynamic_background/domain/models/painter/painter.dart';
import 'package:dynamic_background/domain/models/painter/wave_painter.dart';
import 'package:dynamic_background/domain/models/painter_data/painter_data.dart';
import 'package:dynamic_background/domain/models/wave.dart';
import 'package:flutter/material.dart';

/// The data needed to paint a wave background.
///
/// A wave background is a background that has gently flowing sine waves that
/// move across the screen in a certain direction.
class WavePainterData extends PainterData {
  /// Creates a new [WavePainterData] object.
  ///
  /// A wave background is a background that has gently flowing sine waves that
  /// move across the screen in a certain direction.
  const WavePainterData({
    required List<Wave> waves,
  }) : _waves = waves;

  /// The waves that will be moving across the screen.
  final List<Wave> _waves;

  /// The waves that will be moving across the screen.
  ///
  /// This list is not directly modifiable. Call the add, insert, and remove
  /// methods to modify the list.
  List<Wave> get waves => List<Wave>.unmodifiable(_waves);

  /// Adds a `wave` to the end of the list of [waves].
  ///
  /// ```dart
  /// List<Wave> waves = [wave1, wave2];
  /// addWave(wave3); // [wave1, wave2, wave3]
  /// ```
  void addWave(Wave wave) => _waves.add(wave);

  /// Adds a list of `waves` to the end of the list of [waves].
  ///
  /// ```dart
  /// List<Wave> waves = [wave1, wave2];
  /// addAllWaves([wave3, wave4]); // [wave1, wave2, wave3, wave4]
  /// ```
  void addAllWaves(List<Wave> waves) => _waves.addAll(waves);

  /// Adds a `wave` at the given `index` in the list of [waves].
  ///
  /// Throws a [RangeError] if the `index` is out of bounds.
  ///
  /// ```dart
  /// List<Wave> waves = [wave1, wave2, wave3];
  /// insertWave(1, wave4); // [wave1, wave4, wave2, wave3]
  /// ```
  void insertWave(int index, Wave wave) {
    if (index < 0 || index > _waves.length) {
      throw RangeError.range(index, 0, _waves.length);
    }

    _waves.insert(index, wave);
  }

  /// Adds a list of `waves` at the given `index` in the list of [waves].
  ///
  /// Throws a [RangeError] if the `index` is out of bounds.
  ///
  /// ```dart
  /// List<Wave> waves = [wave1, wave2, wave3];
  /// insertAllWaves(1, [wave4, wave5]); // [wave1, wave4, wave5, wave2, wave3]
  /// ```
  void insertAllWaves(int index, List<Wave> waves) {
    if (index < 0 || index > _waves.length) {
      throw RangeError.range(index, 0, _waves.length);
    }

    _waves.insertAll(index, waves);
  }

  /// Removes the first occurrence of the given `wave` from the list of
  /// [waves].
  ///
  /// Returns `true` if the `wave` was in the list, `false` otherwise.
  ///
  /// If the list of [waves] has only one wave, this method will return `false`
  /// and the `wave` will not be removed. The list must never be empty.
  ///
  /// ```dart
  /// List<Wave> waves = [wave1, wave2, wave3];
  ///
  /// bool removed = removeWave(wave4); // false
  /// print(waves); // [wave1, wave2, wave3]
  ///
  /// removed = removeWave(wave2); // true
  /// print(waves); // [wave1, wave3]
  ///
  /// removed = removeWave(wave1); // true
  /// print(waves); // [wave3]
  ///
  /// removed = removeWave(wave3); // false
  /// print(waves); // [wave3]
  /// ```
  bool removeWave(Wave wave) {
    if (_waves.length == 1) return false;

    return _waves.remove(wave);
  }

  /// Removes the `wave` at the given `index` from the list of [waves].
  ///
  /// Throws a [RangeError] if the `index` is out of bounds.
  ///
  /// If the list of [waves] has only one wave, this method will return `null`
  /// and the wave will not be removed. The list must never be empty.
  ///
  /// ```dart
  /// List<Wave> waves = [wave1, wave2, wave3];
  /// Wave? removed = removeWaveAt(1); // wave2
  /// print(waves); // [wave1, wave3]
  ///
  /// removed = removeWaveAt(1); // wave3
  /// print(waves); // [wave1]
  ///
  /// removed = removeWaveAt(0); // null
  /// print(waves); // [wave1]
  /// ```
  Wave? removeWaveAt(int index) {
    if (index < 0 || index >= _waves.length) {
      throw RangeError.range(index, 0, _waves.length - 1);
    }

    if (_waves.length == 1) return null;

    return _waves.removeAt(index);
  }

  /// Removes all occurrences of the given `wave` from the list of [waves].
  ///
  /// Returns `true` if the `wave` was in the list, `false` otherwise.
  ///
  /// Example:
  ///
  /// ```dart
  /// List<Wave> waves = [wave1, wave1, wave2, wave1, wave3];
  /// bool removed = removeWaveCompletely(wave1); // true
  /// print(waves); // [wave2, wave3]
  /// ```
  ///
  /// If the list of [waves] has only one wave (this also goes for multiple
  /// instances of the one wave), this method will return `false` and the `wave`
  /// will be removed, expect for one instance of it. The list must never be
  /// empty.
  ///
  /// Example:
  ///
  /// ```dart
  /// List<Wave> waves = [wave1, wave1, wave1];
  /// bool removed = removeWaveCompletely(wave1); // false
  /// print(waves); // [wave1]
  /// ```
  bool removeWaveCompletely(Wave wave) {
    while (_waves.contains(wave)) {
      _waves.remove(wave);
    }

    if (_waves.isNotEmpty) return true;

    _waves.add(wave);

    return false;
  }

  @override
  Painter getPainter(Animation<double> animation) {
    return WavePainter(
      animation: animation,
      data: this,
    );
  }

  @override
  WavePainterData copy() => copyWith();

  @override
  WavePainterData copyWith({
    List<Wave>? waves,
  }) {
    return WavePainterData(
      waves: waves ?? _waves.map((wave) => wave.copy()).toList(),
    );
  }

  /// Note: The order of the elements in the [waves] list is important—if the
  /// two objects have the same waves but in a different order, they will not
  /// be considered equal.
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    if (other.runtimeType != runtimeType) return false;

    return other is WavePainterData &&
        const DeepCollectionEquality().equals(other._waves, _waves);
  }

  /// Note: The order of the elements in the [waves] list is important—if the
  /// two objects have the same waves but in a different order, they will not
  /// have the same hash code.
  @override
  int get hashCode => const DeepCollectionEquality().hash(_waves);

  @override
  String toString() => 'Instance of WavePainterData: {'
      'waves: $_waves'
      '}';
}
