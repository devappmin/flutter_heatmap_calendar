import 'dart:collection';

import 'package:flutter/material.dart';
import '../data/heatmap_color_mode.dart';
import '../data/heatmap_color.dart';

class HeatMapColorTip extends StatelessWidget {
  /// Default length of [containerCount].
  final int _defaultLength = 7;

  /// The colorsets which give the color value for its thresholds key value.
  ///
  /// Be aware that first Color is the maximum value if [ColorMode] is [ColorMode.opacity].
  final Map<int, Color>? colorsets;

  /// ColorMode changes the color mode of blocks.
  ///
  /// [ColorMode.opacity] requires just one colorsets value and changes color
  /// [ColorMode.color] changes colors based on [colorsets] thresholds key value.
  final ColorMode colorMode;

  /// The widget which shows left side of [HeatMapColorTip].
  ///
  /// If the value is null then show default 'less' [Text].
  final Widget? leftWidget;

  /// The widget which shows right side of [HeatMapColorTip].
  ///
  /// If the value is null then show default 'more' [Text].
  final Widget? rightWidget;

  /// The integer value of color tip containers count.
  final int? containerCount;

  /// The double value of tip container's size.
  final double? size;

  const HeatMapColorTip({
    Key? key,
    required this.colorMode,
    this.colorsets,
    this.leftWidget,
    this.rightWidget,
    this.containerCount,
    this.size,
  }) : super(key: key);

  /// It returns the List of tip container.
  ///
  /// If [ColorMode.color], call [_heatmapListColor]
  /// If [ColorMode.opacity], call [_heatmapListOpacity]
  List<Widget> _heatmapList() => colorMode == ColorMode.color
      ? _heatmapListColor()
      : _heatmapListOpacity();

  /// Evenly show every colors from lowest to highest.
  List<Widget> _heatmapListColor() {
    List<Widget> children = [];
    SplayTreeMap sortedColorset =
        SplayTreeMap.from(colorsets ?? {}, (a, b) => a > b ? 1 : -1);

    for (int i = 0; i < (containerCount ?? _defaultLength); i++) {
      children.add(_tipContainer(sortedColorset.values.elementAt(
          (sortedColorset.length / (containerCount ?? _defaultLength) * i)
              .floor())));
    }

    return children;
  }

  /// Evenly show every colors from transparent to non-transparent.
  List<Widget> _heatmapListOpacity() {
    List<Widget> children = [];

    for (int i = 0; i < (containerCount ?? _defaultLength); i++) {
      children.add(_tipContainer(colorsets?.values.first
              .withOpacity(i / (containerCount ?? _defaultLength)) ??
          Colors.white));
    }
    return children;
  }

  /// Container which is colored by [color].
  Widget _tipContainer(Color color) {
    return Container(
      color: HeatMapColor.defaultColor,
      child: Container(
        width: size ?? 10,
        height: size ?? 10,
        color: color,
      ),
    );
  }

  /// Default text widget.
  Widget _defaultText(String text) {
    return Text(
      text,
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: size ?? 10),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          leftWidget ?? _defaultText('less'),
          ..._heatmapList(),
          rightWidget ?? _defaultText('more'),
        ],
      ),
    );
  }
}
