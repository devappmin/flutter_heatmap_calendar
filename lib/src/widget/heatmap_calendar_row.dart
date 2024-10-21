import 'package:flutter/material.dart';
import '../util/datasets_util.dart';
import './heatmap_container.dart';
import '../data/heatmap_color_mode.dart';
import '../util/date_util.dart';
import '../util/widget_util.dart';

class HeatMapCalendarRow extends StatelessWidget {
  /// The integer value of beginning date of the week.
  final DateTime startDate;

  /// The integer value of end date of the week
  final DateTime endDate;

  /// Which day the week should start?
  /// weekStartsWith = 1 for Monday, ..., weekStartsWith = 7 for Sunday.
  /// Default to 7 (the week starts wih Sunday).
  final int weekStartsWith;

  /// The double value of every [HeatMapContainer]'s width and height.
  final double? size;

  /// The double value of every [HeatMapContainer]'s fontSize.
  final double? fontSize;

  /// The List of row items.
  ///
  /// It includes every days of the week and
  /// if one week doesn't have 7 days, it will be filled with [SizedBox].
  final List<Widget> dayContainers;

  /// The default background color value of [HeatMapContainer]
  final Color? defaultColor;

  /// The text color value of [HeatMapContainer]
  final Color? textColor;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  final Map<int, Color>? colorsets;

  /// The double value of [HeatMapContainer]'s borderRadius
  final double? borderRadius;

  /// Make block size flexible if value is true.
  final bool? flexible;

  /// The margin value for every block.
  final EdgeInsets? margin;

  /// The datasets which fill blocks based on its value.
  ///
  /// datasets keys have to greater or equal to [startDate] and
  /// smaller or equal to [endDate].
  final Map<DateTime, int>? datasets;

  /// ColorMode changes the color mode of blocks.
  ///
  /// [ColorMode.opacity] requires just one colorsets value and changes color
  /// dynamically based on hightest value of [datasets].
  /// [ColorMode.color] changes colors based on [colorsets] thresholdsc key value.
  final ColorMode colorMode;

  /// The integer value of the maximum value for the highest value of the month.
  final int? maxValue;

  /// Function that will be called when a block is clicked.
  ///
  /// Paratmeter gives clicked [DateTime] value.
  final Function(DateTime)? onClick;

  final bool? showText;

  HeatMapCalendarRow({
    Key? key,
    required this.startDate,
    required this.endDate,
    required this.weekStartsWith,
    required this.colorMode,
    this.size,
    this.fontSize,
    this.defaultColor,
    this.colorsets,
    this.textColor,
    this.borderRadius,
    this.flexible,
    this.margin,
    this.datasets,
    this.maxValue,
    this.onClick,
    this.showText,
  })  : dayContainers = List<Widget>.generate(
          7,
          // If current week has first day of the month and
          // the first day is not a sunday, it must have extra space on it.
          // Then fill it with empty Container for extra space.
          //
          // Do same works if current week has last day of the month and
          // the last day is not a saturday.
          (i) => (startDate == DateUtil.startDayOfMonth(startDate) &&
                      endDate.day - startDate.day != 7 &&
                      i < ((startDate.weekday - weekStartsWith) % 7)) ||
                  (endDate == DateUtil.endDayOfMonth(endDate) &&
                      endDate.day - startDate.day != 7 &&
                      i > ((endDate.weekday - weekStartsWith) % 7))
              ? Container(
                  width: size ?? 42,
                  height: size ?? 42,
                  margin: margin ?? const EdgeInsets.all(2),
                )
              // If the day is not a empty one then create HeatMapContainer.
              : HeatMapContainer(
                  // Given information about the week is that
                  // start day of week value and end day of week.
                  //
                  // So we have to give every day information to each HeatMapContainer.
                  date: DateTime(startDate.year, startDate.month,
                      startDate.day - (startDate.weekday - weekStartsWith) % 7 + i),
                  showText: showText,
                  backgroundColor: defaultColor,
                  size: size,
                  fontSize: fontSize,
                  textColor: textColor,
                  borderRadius: borderRadius,
                  margin: margin,
                  onClick: onClick,
                  // If datasets has DateTime key which is equal to this HeatMapContainer's date,
                  // we have to color the matched HeatMapContainer.
                  //
                  // If datasets is null or doesn't contains the equal DateTime value, send null.
                  selectedColor: datasets?.keys.contains(DateTime(startDate.year, startDate.month,
                              startDate.day - (startDate.weekday - weekStartsWith) % 7 + i)) ??
                          false
                      // If colorMode is ColorMode.opacity,
                      ? colorMode == ColorMode.opacity
                          // Color the container with first value of colorsets
                          // and set opacity value to current day's datasets key
                          // devided by maxValue which is the maximum value of the month.
                          ? colorsets?.values.first.withOpacity((datasets?[DateTime(
                                      startDate.year,
                                      startDate.month,
                                      startDate.day +
                                          i -
                                          ((startDate.weekday - weekStartsWith) % 7))] ??
                                  1) /
                              (maxValue ?? 1))
                          // Else if colorMode is ColorMode.Color.
                          //
                          // Get color value from colorsets which is filtered with DateTime value
                          // Using DatasetsUtil.getColor()
                          : DatasetsUtil.getColor(
                              colorsets,
                              datasets?[DateTime(startDate.year, startDate.month,
                                  startDate.day + i - ((startDate.weekday - 1) % 7))])
                      : null,
                ),
        ),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (Widget container in dayContainers)
          WidgetUtil.flexibleContainer(flexible ?? false, true, container),
      ],
    );
  }
}
