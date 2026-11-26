import 'dart:math';

import 'package:material_ui/material_ui.dart';

/// Normalizes [radians] to the interval (0, 2π].
double normalizeAngle(double radians) {
  var normalized = atan2(sin(radians), cos(radians));
  normalized = normalized > 0 ? normalized : 2 * pi + normalized;
  return normalized;
}

/// Converts [time] to a 24-hour clock angle with [offsetRad] rotation.
double timeToAngle(TimeOfDay time, double offsetRad) {
  int min = time.hour * 60 + time.minute;
  double angle = min * pi * 2 / 60 / 24;
  return normalizeAngle(angle + pi / 2 + offsetRad);
}

//

/// Returns the signed difference between two angles in radians.
double signedAngle(double startAngle, double targetAngle) {
  //return (startAngle - targetAngle).abs() % 360;
  return atan2(sin(startAngle - targetAngle), cos(startAngle - targetAngle));
}

/// Converts [duration] to a signed angle on a 24-hour clock.
double durationToAngle(Duration duration) {
  var min = duration.inMinutes;
  var time = TimeOfDay(hour: min ~/ 60, minute: min % 60);

  return signedAngle(timeToAngle(time, 0), pi / 2);
}

/// The endpoint currently being edited on the clock.
enum ActiveTime {
  /// The start of the selected range.
  Start,

  /// The end of the selected range.
  End,
}

/// A pair of daily times defining a selected or disabled range.
class TimeRange {
  /// The starting time of the range.
  TimeOfDay startTime;

  /// The ending time of the range.
  TimeOfDay endTime;

  /// Creates a range with the given start and end times.
  TimeRange({required this.startTime, required this.endTime});

  String toString() {
    return "Start: ${startTime.toString()} to ${endTime.toString()}";
  }
}

/// A text label positioned at an angle around the clock.
class ClockLabel {
  /// The label position in radians, before the clock rotation is applied.
  double angle;

  /// The text displayed on the clock.
  String text;

  /// Creates a label at [angle], measured in radians.
  ClockLabel({required this.angle, required this.text});

  /// Creates a label at [deg] degrees, converted to radians.
  factory ClockLabel.fromDegree({required double deg, required String text}) {
    return ClockLabel(angle: deg * pi / 180, text: text);
  }

  /// Creates a label at [time] on the 24-hour clock.
  factory ClockLabel.fromTime({required TimeOfDay time, required String text}) {
    double angle = timeToAngle(time, 0);

    return ClockLabel(angle: angle, text: text);
  }

  /// Creates one of [length] evenly spaced labels at zero-based [idx].
  ///
  /// Index zero starts at π/2 radians; [length] must be greater than zero.
  factory ClockLabel.fromIndex({
    required int idx,
    required int length,
    required String text,
  }) {
    double angle = (2 * pi / length) * idx + pi / 2;

    return ClockLabel(angle: angle, text: text);
  }
}
