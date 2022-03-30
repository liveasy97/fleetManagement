import 'package:flutter/widgets.dart';

class SizeConfig {
  static MediaQueryData? mediaQueryData;
  static double? screenWidth;
  static double? screenHeight;

  static double? _safeAreaHorizontal;
  static double? _safeAreaVertical;
  static double? safeBlockHorizontal;
  static double? safeBlockVertical;

  void init(BuildContext context) {
    mediaQueryData = MediaQuery.of(context);
    screenWidth = mediaQueryData!.size.width;
    screenHeight = mediaQueryData!.size.height;

    _safeAreaHorizontal =
        mediaQueryData!.padding.left + mediaQueryData!.padding.right;
    _safeAreaVertical =
        mediaQueryData!.padding.top + mediaQueryData!.padding.bottom;
    safeBlockHorizontal = (screenWidth! - _safeAreaHorizontal!) / 1440;
    safeBlockVertical = (screenHeight! - _safeAreaVertical!) / 1020;
  }
}
