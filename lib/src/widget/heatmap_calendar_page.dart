import 'package:flutter/material.dart';
import './heatmap_calendar_row.dart';
import '../util/date_util.dart';
import '../util/datasets_util.dart';
import '../data/heatmap_color_mode.dart';

class HeatMapCalendarPage extends StatelessWidget {
  /// The DateTime value which contains the current calendar's date value.
  final DateTime baseDate;

  /// The list value of the map value that contains
  /// separated start and end of every weeks on month.
  ///
  /// Separate [datasets] using [DateUtil.separatedMonth].
  final List<Map<DateTime, DateTime>> separatedDate;

  /// The margin value for every block.
  final EdgeInsets? margin;

  /// Make block size flexible if value is true.
  final bool? flexible;

  /// The double value of every block's width and height.
  final double? size;

  /// The double value of every block's fontSize.
  final double? fontSize;

  /// The datasets which fill blocks based on its value.
  final Map<DateTime, int>? datasets;

  /// The default background color value of every blocks
  final Color? defaultColor;

  /// The text color value of every blocks
  final Color? textColor;

  /// ColorMode changes the color mode of blocks.
  ///
  /// [ColorMode.opacity] requires just one colorsets value and changes color
  /// dynamically based on hightest value of [datasets].
  /// [ColorMode.color] changes colors based on [colorsets] thresholds key value.
  final ColorMode colorMode;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  final Map<int, Color>? colorsets;

  /// The double value of every block's borderRadius
  final double? borderRadius;

  /// The integer value of the maximum value for the [datasets].
  ///
  /// Filtering [datasets] with [baseDate] using [DatasetsUtil.filterMonth].
  /// And get highest key value of filtered datasets using [DatasetsUtil.getMaxValue].
  final int? maxValue;

  /// Function that will be called when a block is clicked.
  ///
  /// Paratmeter gives clicked [DateTime] value.
  final Function(DateTime)? onClick;

  HeatMapCalendarPage({
    Key? key,
    required this.baseDate,
    required this.colorMode,
    this.flexible,
    this.size,
    this.fontSize,
    this.defaultColor,
    this.textColor,
    this.margin,
    this.datasets,
    this.colorsets,
    this.borderRadius,
    this.onClick,
  })  : separatedDate = DateUtil.separatedMonth(baseDate),
        maxValue = DatasetsUtil.getMaxValue(
            DatasetsUtil.filterMonth(datasets, baseDate)),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (var date in separatedDate)
          HeatMapCalendarRow(
            startDate: date.keys.first,
            endDate: date.values.first,
            colorMode: colorMode,
            size: size,
            fontSize: fontSize,
            defaultColor: defaultColor,
            colorsets: colorsets,
            textColor: textColor,
            borderRadius: borderRadius,
            flexible: flexible,
            margin: margin,
            maxValue: maxValue,
            onClick: onClick,
            datasets: Map.from(datasets ?? {})
              ..removeWhere(
                (key, value) => !(key.isAfter(date.keys.first) &&
                        key.isBefore(date.values.first) ||
                    key == date.keys.first ||
                    key == date.values.first),
              ),
          ),
      ],
    );
  }
}
