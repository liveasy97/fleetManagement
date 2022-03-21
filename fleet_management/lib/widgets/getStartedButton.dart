import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get.dart';

import '../constants/color.dart';
import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';
import '../constants/radius.dart';
import '../constants/spaces.dart';

class GetStartedButton extends StatefulWidget {
  Function? onTapNext;

  GetStartedButton({Key? key, required this.onTapNext}) : super(key: key);

  @override
  _GetStartedButtonState createState() => _GetStartedButtonState();
}

class _GetStartedButtonState extends State<GetStartedButton> {
  @override
  Widget build(BuildContext context) {
    return FlatButton(
        highlightColor: Colors.transparent,
        onPressed: () {
          widget.onTapNext!();
        },
        child: Container(
          height: space_8,
          decoration: BoxDecoration(
            color: darkBlueColor,
            borderRadius: BorderRadius.circular(radius_6),
          ),
          child: Center(
            child: Text(
              'getStarted'.tr,
              // "Get Started",
              style: TextStyle(
                  color: white, fontWeight: mediumBoldWeight, fontSize: size_8),
            ),
          ),
        ));
    //   GestureDetector(
    //   onTap: (){
    //     widget.onTapNext!();
    //   },
    //   child: Container(
    //     height: space_8,
    //     decoration: BoxDecoration(
    //         color: darkBlueColor,
    //         borderRadius: BorderRadius.circular(radius_6)),
    //     child: Center(
    //       child: Text(
    //         'getStarted'.tr,
    //         // "Get Started",
    //         style: TextStyle(
    //             color: white, fontWeight: mediumBoldWeight, fontSize: size_8),
    //       ),
    //     ),
    //   ),
    // );
  }
}
