import 'package:fleet_management/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:location_permissions/location_permissions.dart';
import 'package:provider/provider.dart';

import '../../constants/color.dart';
import '../../constants/fontSize.dart';
import '../../constants/fontWeights.dart';
import '../../constants/radius.dart';
import '../../constants/spaces.dart';
import '../../controller/hudController.dart';
import '../../providerClass/providerData.dart';
import '../../widgets/truckScreenBarButton.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  HudController hudController = Get.put(HudController());
  TextEditingController phoneNumber = TextEditingController();
  TextEditingController otp = TextEditingController();
  bool canShow = false;
  var temp;

  void initState() {
    super.initState();
    hudController.updateHud(
        false); // so that if user press the back button in between verification verifying stop
    getLocationPermission();
  }

  PermissionStatus? permission1;
  Position? userPosition;

  getLocationPermission() async {
    await LocationPermissions().requestPermissions();
    permission1 = await LocationPermissions().checkPermissionStatus();
    // userPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    // final coordinates = new Coordinates(userPosition!.latitude, userPosition!.longitude);
    // var addresses =
    //     await Geocoder.local.findAddressesFromCoordinates(coordinates);
    // var first = addresses.first;
    // print(first.addressLine);
  }

  final GlobalKey _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    if (permission1 == PermissionStatus.denied ||
        permission1 == PermissionStatus.restricted) {
      //return LocationDisabledScreen();
    }
    ProviderData providerData = Provider.of<ProviderData>(context);
    PageController pageController =
    PageController(initialPage: providerData.upperNavigatorIndex);
    return SafeArea(
      child: Scaffold(
          body: Stack(children: [
        Positioned(
          bottom: 385,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: space_0, bottom: space_12),
                child: Container(
                  width: 500,
                  height: 350,
                  child: Image(
                    image: AssetImage("assets/images/signupasset1.png"),
                    width: 400,
                    height: 50,
                    alignment: Alignment.topLeft,
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
            child: SizedBox(
              width: 300,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  child: Image(
          image: AssetImage("assets/images/logoSplashScreen.png"),
                  width: 200,
                  height: 70,
                  alignment: Alignment.topLeft,
                )
                ),
              ),
              Container(
                child: Text(
                  "Making transport business easy.",
                  style: TextStyle(
                    color: darkBlueColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 20
                  ),
                  textAlign: TextAlign.center,
                )
              ),
              Container(
                //    height: 26,
                //    width: 200,
                padding: EdgeInsets.only(top:50,),

                //    margin: EdgeInsets.symmetric(horizontal: space_2),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TruckScreenBarButton(
                        text: 'Sign up',
                        // 'All',
                        value: 0,
                        pageController: pageController),
                    Container(
                      padding: EdgeInsets.all(0),
                      width: 1,
                      height: 15,
                      color: const Color(0xFFC2C2C2),
                    ),
                    TruckScreenBarButton(
                        text: 'Sign in',
                        // 'Running'
                        value: 1,
                        pageController: pageController),
                  ],
                ),
              ),
              Expanded(
                child: Stack(children: [
                  Container(
                       padding: EdgeInsets.only(top:20),
                    child: PageView(
                        controller: pageController,
                        onPageChanged: (value) {
                          setState(() {
                            providerData.updateUpperNavigatorIndex(value);
                          });
                        },
                        children: [
                          Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  'Phone Number',
                                  style: TextStyle(
                                    color: grey
                                  ),
                                ),
                              ),
                              Container(child: buildTextField('Phone Number', phoneNumber, Icons.phone, context)),
                              canShow?
                              Column(
                                children: [
                                  Container(
                                    child: Text(
                                      'OTP',
                                      style: TextStyle(
                                        color: grey
                                      ),
                                    ),
                                  ),
                                  Container(child: buildTextField('OTP', otp, Icons.password, context)),

                                ],
                              ):SizedBox(),
                              !canShow?buildSendOTPBtn('Send OTP'):buildSubmitBtn("Sign Up")
                            ],
                          ),
                          Column(
                            crossAxisAlignment:CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                child: Text(
                                  'Phone Number',
                                  style: TextStyle(
                                    color: grey
                                  ),
                                ),
                              ),
                              Container(child: buildTextField('Phone Number', phoneNumber, Icons.phone, context)),
                              canShow?
                              Column(
                                children: [
                                  Container(
                                    child: Text(
                                      'OTP',
                                      style: TextStyle(
                                        color: grey
                                      ),
                                    ),
                                  ),
                                  Container(child: buildTextField('OTP', otp, Icons.password, context)),

                                ],
                              ):SizedBox(),
                              !canShow?buildSendOTPBtn('Send OTP'):buildSubmitBtn("Sign In")
                            ],
                          ),
                        ]),
                  ),
                  // Positioned(
                  //   top: MediaQuery.of(context).size.height -
                  //       kBottomNavigationBarHeight -
                  //       230 -
                  //       2 * space_6 -
                  //       30,
                  //   left: (MediaQuery.of(context).size.width - 2 * space_6) / 2 -
                  //       60,
                  //   child: Container(
                  //     //     margin: EdgeInsets.only(bottom: space_2),
                  //       child: AddTruckButton()),
                  // ),
                ]),
              ),


            ],
          ),
        )),
        Positioned(
          bottom: 0,
          left: 1000,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: EdgeInsets.only(left: space_6, bottom: space_0),
                child: Container(
                  width: 500,
                  height: 350,
                  child: Image(
                    image: AssetImage("assets/images/signupasset2.png"),
                    width: 400,
                    height: 50,
                    alignment: Alignment.bottomLeft,
                  ),
                ),
              ),
            ],
          ),
        )
      ])),
    );
  }

  Widget buildTextField(
      String labelText,
      TextEditingController textEditingController,
      IconData prefixIcons,
      BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(8.00),
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 40,
          child: TextFormField(
            obscureText: labelText == "OTP" ? true : false,
            controller: textEditingController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: darkBlueColor),
                borderRadius: BorderRadius.circular(5.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: darkBlueColor),
                borderRadius: BorderRadius.circular(5.5),
              ),
            ),
          ),
        ),
      );

  Widget buildSendOTPBtn(String text) => Padding(
    padding: const EdgeInsets.all(18.0),
    child: ElevatedButton(
      style:  ElevatedButton.styleFrom(
          primary: darkBlueColor,
          padding: EdgeInsets.symmetric(horizontal: 110, vertical: 20),
          textStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal)),
      onPressed: () async {
        setState(() {
          canShow = !canShow;
        });
        temp = await FirebaseAuthentication().sendOtp(phoneNumber.text);
      },
      child: Text(text),
    ),
  );

  Widget buildSubmitBtn(String text) => Padding(
    padding: const EdgeInsets.all(18.0),
    child: ElevatedButton(
      style:  ElevatedButton.styleFrom(
          primary: darkBlueColor,
          padding: EdgeInsets.symmetric(horizontal: 110, vertical: 20),
          textStyle: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.normal)),
      onPressed: () {
        FirebaseAuthentication().authenticate(temp, otp.text,phoneNumber.text);
      },
      child: Text(text),
    ),
  );
}
