import 'package:flutter/cupertino.dart';

class SizeConfig {
  static late MediaQueryData _mediaQueryData;

  static late double screenWidth;
  static late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late Orientation orientation;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  static late double safeBlockHorizontal;
  static late double safeBlockVertical;
  static late double textMultiplier;
  static late double imageSizeMultiplier;
  static late double heightMultiplier;
  static late double widthMultiplier;

  static bool isMobilePortrait = false;
  static bool isMobileLandscape = false;
  static bool isTablet = false;


  static void init(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    orientation = _mediaQueryData.orientation;

    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;

    _safeAreaHorizontal = _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical = _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;

    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;

    if (orientation == Orientation.portrait) {
      textMultiplier = blockSizeVertical;
      imageSizeMultiplier = blockSizeHorizontal;
      heightMultiplier = blockSizeVertical;
      widthMultiplier = blockSizeHorizontal;
      if (screenWidth < 450) {
        isMobilePortrait = true;
      } else if (screenWidth < 900) {
        isTablet = true;
      }
    } else {
      textMultiplier = blockSizeHorizontal;
      imageSizeMultiplier = blockSizeVertical;
      heightMultiplier = blockSizeVertical;
      widthMultiplier = blockSizeHorizontal;
      if (screenHeight < 450) {
        isMobileLandscape = true;
      } else if (screenHeight < 900) {
        isTablet = true;
      }
    }
  }

  static double getWidth(double percentage) {
    return screenWidth * (percentage / 100);
  }

  static double getHeight(double percentage) {
    return screenHeight * (percentage / 100);
  }

  static double getFontSize(double baseSize) {
    double responsiveSize = baseSize * (textMultiplier / 10);
    if (isTablet) {
      responsiveSize *= 1.2;
    } else if (isMobilePortrait || isMobileLandscape) {
    }
    return responsiveSize < 8.0 ? 8.0 : responsiveSize;
  }

  static double getHorizontalPadding(double percentage) {
    return screenWidth * (percentage / 100);
  }

  static double getVerticalPadding(double percentage) {
    return screenHeight * (percentage / 100);
  }
}

extension ResponsiveNum<T extends num> on T {
  double get h => this * SizeConfig.heightMultiplier / 100 * this;
  double get w => this * SizeConfig.widthMultiplier / 100 * this;
  double get sp => SizeConfig.getFontSize(this.toDouble());
  double get ph => SizeConfig.getHeight(this.toDouble());
  double get pw => SizeConfig.getWidth(this.toDouble());
}
