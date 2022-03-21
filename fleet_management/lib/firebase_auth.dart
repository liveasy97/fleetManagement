import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fleet_management/screens/LoginScreens/loginScreen.dart';
import 'package:fleet_management/screens/navigationScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import 'functions/trasnporterApis/runTransporterApiPost.dart';

// import 'apiCalls/runTransporterApiPost.dart';


class FirebaseAuthentication{
  String phoneNumber='';

  sendOtp(String phoneNumber) async{
    this.phoneNumber=phoneNumber;
    FirebaseAuth auth = FirebaseAuth.instance;

    ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber("+91 $phoneNumber");
    printMessage("OTP sent to +91 $phoneNumber");
    printMessage("$confirmationResult");
    // Get.to(NewOTPVerificationScreen(phoneNumber,confirmationResult));
    return confirmationResult;

  }

  authenticate(ConfirmationResult confirmationResult, String otp, String phoneNumber) async{
    printMessage(otp);
    await confirmationResult.confirm(otp);
    await runTransporterApiPost(mobileNum: phoneNumber);
    Get.off(NavigationScreen());


  }

  signOut() async {
    try {
      Get.off(() => LoginScreen());
      return FirebaseAuth.instance.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  printMessage(String msg){
    debugPrint(msg);
  }

}