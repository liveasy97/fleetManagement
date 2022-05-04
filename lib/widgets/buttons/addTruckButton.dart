import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constants/color.dart';
import '../../constants/fontSize.dart';
import '../../constants/fontWeights.dart';
import '../../constants/spaces.dart';
import '../../providerClass/providerData.dart';
import '../../screens/add truck/truckNumberRegistration.dart';

class AddTruckButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ProviderData providerData = Provider.of<ProviderData>(context);
    providerData.updateIsAddTruckSrcDropDown(false);
    return Container(
      width: space_33,
      height: space_8,
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          )),
          backgroundColor: MaterialStateProperty.all<Color>(truckGreen),
        ),
        onPressed: () {
          Get.to(() => AddNewTruck());
        },
        child: Text(
          'addTruck'.tr,
          // AppLocalizations.of(context)!.addTruck,
          style: TextStyle(
            fontWeight: mediumBoldWeight,
            fontSize: size_9,
            color: white,
          ),
        ),
      ),
    );
  }
}
