import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import './heatmap_month_text.dart';
import './heatmap_column.dart';
import '../data/heatmap_color_mode.dart';
import '../util/datasets_util.dart';
import '../util/date_util.dart';
import './heatmap_week_text.dart';

class HeatMapPage extends StatelessWidget {
  /// List value of every sunday's month information.
  ///
  /// From 1: January to 12: December.
  final List<String> _firstDayInfos = [];

  /// The number of days between [startDate] and [endDate].
  final int _dateDifferent;

  /// The list of localized labels for week days.
  final List<String> _localizedWeekDayLabels = [];

  /// The Date value of start day of heatmap.
  ///
  /// HeatMap shows the start day of [startDate]'s week.
  ///
  /// Default value is 1 year before the [endDate].
  /// And if [endDate] is null, then set 1 year before the [DateTime.now]
  final DateTime startDate;

  /// The Date value of end day of heatmap.
  ///
  /// Default value is [DateTime.now]
  final DateTime endDate;

  /// The double value of every block's width and height.
  final double? size;

  /// The double value of every block's fontSize.
  final double? fontSize;

  /// The datasets which fill blocks based on its value.
  final Map<DateTime, int>? datasets;

  /// The margin value for every block.
  final EdgeInsets? margin;

  /// The default background color value of every blocks.
  final Color? defaultColor;

  /// The text color value of every blocks into the heatmap.
  final Color? textColor;

  /// The text color value for labels (months & week days).
  final Color? labelColor;

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

  /// The double value of every block's borderRadius.
  final double? borderRadius;

  /// The integer value of the maximum value for the [datasets].
  ///
  /// Get highest key value of filtered datasets using [DatasetsUtil.getMaxValue].
  final int? maxValue;

  /// Function that will be called when a block is clicked.
  ///
  /// Paratmeter gives clicked [DateTime] value.
  final Function(DateTime)? onClick;

  final bool? showText;

  /// Which day the week should start?
  /// weekStartsWith = 1 for Monday, ..., weekStartsWith = 7 for Sunday.
  /// Default to 7 (the week starts wih Sunday).
  final int weekStartsWith;

  HeatMapPage({
    Key? key,
    required this.colorMode,
    required this.startDate,
    required this.endDate,
    this.size,
    this.fontSize,
    this.datasets,
    this.defaultColor,
    this.textColor,
    this.labelColor,
    this.colorsets,
    this.borderRadius,
    this.onClick,
    this.margin,
    this.showText,
    this.weekStartsWith = 7,
  })  : _dateDifferent = endDate.difference(startDate).inDays,
        maxValue = DatasetsUtil.getMaxValue(datasets),
        super(key: key);

  /// Get [HeatMapColumn] from [startDate] to [endDate].
  List<Widget> _heatmapColumnList(BuildContext context) {
    // Create empty list.
    List<Widget> columns = [];

    // Set cursor(position) to first day of weeks
    // until cursor reaches the final week.
    for (int datePos = -((startDate.weekday - weekStartsWith) % 7);
        datePos <= _dateDifferent;
        datePos += 7) {
      // Get first day of week by adding cursor's value to startDate.
      DateTime firstDay = DateUtil.changeDay(startDate, datePos);

      if (_localizedWeekDayLabels.isEmpty) {
        // Add an empty string for the first row
        // which is used to show the 12 month labels.
        _localizedWeekDayLabels.add('');
        for (var i = 0; i < 7; i++) {
          _localizedWeekDayLabels.add(
              DateFormat.E(Localizations.localeOf(context).languageCode)
                  .format(DateUtil.changeDay(firstDay, i)));
        }
      }

      final numDays = min(endDate.difference(firstDay).inDays + 1, 7);
      if (numDays != 0) {
        columns.add(HeatMapColumn(
          // If last day is not saturday, week also includes future Date.
          // So we have to make future day on last column blanck.
          //
          // To make empty space to future day, we have to pass this HeatMapPage's
          // endDate to HeatMapColumn's endDate.
          startDate: firstDay,
          endDate: datePos <= _dateDifferent - 7
              ? DateUtil.changeDay(startDate, datePos + 6)
              : endDate,
          weekStartsWith: weekStartsWith,
          colorMode: colorMode,
          numDays: numDays,
          size: size,
          fontSize: fontSize,
          defaultColor: defaultColor,
          colorsets: colorsets,
          textColor: textColor,
          borderRadius: borderRadius,
          margin: margin,
          maxValue: maxValue,
          onClick: onClick,
          datasets: datasets,
          showText: showText,
        ));

        // also add first day's month information to _firstDayInfos list.
        _firstDayInfos.add(
            DateFormat.MMM(Localizations.localeOf(context).languageCode)
                .format(firstDay));
      }
    }

    return columns;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Show week labels to left side of heatmap.
        HeatMapWeekText(
          margin: margin,
          fontSize: fontSize,
          size: size,
          fontColor: labelColor,
          weekDayLabels: _localizedWeekDayLabels,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show month labels to top of heatmap.
            HeatMapMonthText(
              firstDayInfos: _firstDayInfos,
              margin: margin,
              fontSize: fontSize,
              fontColor: labelColor,
              size: size,
            ),

            // Heatmap itself.
            Row(
              children: <Widget>[..._heatmapColumnList(context)],
            ),
          ],
        ),
      ],
    );
  }
}
