import 'package:flutter/material.dart';
import './date_util.dart';

class DatasetsUtil {
  /// Filtering [datasets] where the key is on the same month of [referenceDate].
  static Map<DateTime, int> filterMonth(
      Map<DateTime, int>? datasets, DateTime referenceDate) {
    return Map.from(datasets ?? {})
      ..removeWhere(
        (date, value) =>
            !(date.isAfter(DateUtil.startDayOfMonth(referenceDate)) &&
                    date.isBefore(DateUtil.endDayOfMonth(referenceDate)) ||
                date == DateUtil.endDayOfMonth(referenceDate) ||
                date == DateUtil.startDayOfMonth(referenceDate)),
      );
  }

  /// Get maximum value of [datasets].
  static int getMaxValue(Map<DateTime, int>? datasets) {
    if (datasets == null || datasets.isEmpty) {
      return 0; // Return 0 for empty or null datasets
    }

    return datasets.values.reduce((max, value) => value > max ? value : max);
  }

  /// Get color from [colorsets] using [dataValue].
  static Color? getColor(Map<int, Color>? colorsets, int? dataValue) {
    int result = 0;

    colorsets?.forEach((key, value) {
      if (key <= (dataValue ?? 0)) result = key;
    });

    return colorsets?[result];
  }
}
