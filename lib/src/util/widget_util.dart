import 'package:flutter/material.dart';

class WidgetUtil {
  /// Make [HeatMapContainer] flexible size if [isFlexible] is true.
  static Widget flexibleContainer(
      bool isFlexible, bool isSquare, Widget child) {
    return isFlexible
        ? Expanded(
            child: isSquare
                ? AspectRatio(
                    aspectRatio: 1,
                    child: child,
                  )
                : child,
          )
        : child;
  }
}
