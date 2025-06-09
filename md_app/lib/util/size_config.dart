import 'package:flutter/widgets.dart';

// class SizeConfig {
//   static double _screenWidth = 0;
//   static double _screenHeight = 0;
//   static double _blockWidth = 0;
//   static double _blockHeight = 0;

//   static double textMultiplier = 0;
//   static double imageSizeMultiplier = 0;
//   static double heightMultiplier = 0;
//   static double widthMultiplier = 0;
//   static bool isPortrait = true;
//   static bool isMobilePortrait = false;

//   void init(BoxConstraints constraints, Orientation orientation) {
//     if (orientation == Orientation.portrait) {
//       print("Orientation == 1");
//       _screenWidth = constraints.maxWidth;
//       _screenHeight = constraints.maxHeight;
//       isPortrait = true;
//       if (_screenWidth < 750) {
//         isMobilePortrait = true;
//       }
//     } else {
//       print("Orientation == 2");
//       _screenWidth = constraints.maxHeight;
//       _screenHeight = constraints.maxWidth;
//       isPortrait = false;
//       isMobilePortrait = false;
//     }
//     _screenWidth = constraints.maxWidth;
//     _screenHeight = constraints.maxHeight;

//     _blockWidth = _screenWidth / 100;
//     _blockHeight = _screenHeight / 100;

//     textMultiplier = _blockHeight;
//     imageSizeMultiplier = _blockWidth;
//     heightMultiplier = _blockHeight;
//     widthMultiplier = _blockWidth;

//     print("Orientation >>> == $orientation");
//     print("imageSizeMultiplier == $_screenWidth");
//     print("_screenWidth == $_screenWidth");
//     print("_screenHeight == $_screenHeight");
//     print("_blockWidth == $_blockWidth");
//     print("_blockHeight == $_blockHeight");
//     print("isPortrait == $isPortrait");
//     print("isMobilePortrait == $isMobilePortrait");
//   }
// }

// /*
// imageSizeMultiplier == 392.72727272727275
// I/flutter (16612): _screenWidth == 392.72727272727275
// I/flutter (16612): _screenHeight == 803.6363636363636
// I/flutter (16612): _blockWidth == 3.9272727272727277
// I/flutter (16612): _blockHeight == 8.036363636363637*/
// import 'package:flutter/widgets.dart';

// class SizeConfig {
//   static double screenWidth = 0;
//   static double screenHeight = 0;
//   static double blockWidth = 0;
//   static double blockHeight = 0;

//   static double textMultiplier = 0;
//   static double imageSizeMultiplier = 0;
//   static double heightMultiplier = 0;
//   static double widthMultiplier = 0;
//   static bool isPortrait = true;
//   static bool isMobilePortrait = false;

//   void init(BuildContext context) {
//     final mediaQuery = MediaQuery.of(context);
//     final constraints = mediaQuery.size;
//     final padding = mediaQuery.padding; // Get Safe Area Padding

//     screenWidth = constraints.width;
//     screenHeight = constraints.height -
//         padding.top -
//         padding.bottom; // Adjust for safe area

//     isPortrait = mediaQuery.orientation == Orientation.portrait;
//     isMobilePortrait = isPortrait && screenWidth < 750;

//     blockWidth = screenWidth / 100;
//     blockHeight = screenHeight / 100;

//     textMultiplier = blockHeight;
//     imageSizeMultiplier = blockWidth;
//     heightMultiplier = blockHeight;
//     widthMultiplier = blockWidth;

//     debugPrint("Orientation: ${isPortrait ? "Portrait" : "Landscape"}");
//     debugPrint("screenWidth: $screenWidth, screenHeight: $screenHeight");
//     debugPrint("blockWidth: $blockWidth, blockHeight: $blockHeight");
//   }
// }
import 'package:flutter/material.dart';

class SizeConfig {
  static double screenWidth = 0;
  static double screenHeight = 0;
  static double blockWidth = 0;
  static double blockHeight = 0;

  static double textMultiplier = 0;
  static double imageSizeMultiplier = 0;
  static double heightMultiplier = 0;
  static double widthMultiplier = 0;
  static bool isPortrait = true;
  static bool isMobilePortrait = false;

  // New initialization method for LayoutBuilder/OrientationBuilder
  static void initWithConstraints(
      BoxConstraints constraints, Orientation orientation) {
    screenWidth = constraints.maxWidth;
    screenHeight = constraints.maxHeight;

    isPortrait = orientation == Orientation.portrait;
    isMobilePortrait = isPortrait && screenWidth < 750;

    blockWidth = screenWidth / 100;
    blockHeight = screenHeight / 100;

    textMultiplier = blockHeight;
    imageSizeMultiplier = blockWidth;
    heightMultiplier = blockHeight;
    widthMultiplier = blockWidth;

    debugPrint('''
    SizeConfig Initialized:
    Screen: ${screenWidth.toStringAsFixed(1)} × ${screenHeight.toStringAsFixed(1)}
    Orientation: ${isPortrait ? 'Portrait' : 'Landscape'}
    Block Size: $blockWidth × $blockHeight
    ''');
  }

  // Original init method for direct context usage
  static void init(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    initWithConstraints(
      BoxConstraints(
        maxWidth: mediaQuery.size.width,
        maxHeight: mediaQuery.size.height,
      ),
      mediaQuery.orientation,
    );
  }
}
