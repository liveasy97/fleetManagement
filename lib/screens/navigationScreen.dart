import 'package:fleet_management/controller/transporterIdController.dart';
import 'package:fleet_management/firebase_auth.dart';
import 'package:fleet_management/screens/navigation_drawer_screen/first_page.dart';
import 'package:fleet_management/screens/navigation_drawer_screen/myTrucksScreen.dart';
import 'package:fleet_management/screens/navigation_drawer_screen/user_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color.dart';
import '../constants/screenSizeConfig.dart';


class NavigationScreen extends StatefulWidget{

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> with SingleTickerProviderStateMixin{

  TabController? tabController;
  int active = 0;

  var screens = [
    FirstPage(),
    UserScreens(),
  ];

  @override
  void initState() {
    super.initState();
    tabController = TabController(vsync: this, length: 2, initialIndex: 0)
      ..addListener(() {
        setState(() {
          active = tabController!.index;
        });
      });
  }

  @override
  void dispose() {
    tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    TransporterIdController transporterIdController = Get.find<TransporterIdController>();

    if (SizeConfig.mediaQueryData == null) {
      SizeConfig().init(context);
    }
    double height = SizeConfig.safeBlockVertical!;
    double width = SizeConfig.safeBlockHorizontal!;
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: white,
            title: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:  [
                Padding(
                  padding: EdgeInsets.only(left: 0.0),
                  child: Image(
                    image: AssetImage("assets/images/logoSplashScreen.png"),
                    width: 150,
                    height: 100,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0,right: 5),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 6.0),
                            child: Icon(Icons.account_circle_outlined),
                          ),
                          Text(
                            transporterIdController.name.string,
                            style: TextStyle(
                                fontSize: 20,
                                color: black
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0,right: 10),
                      child: Container(
                        padding: EdgeInsets.all(0),
                        width: 1.5,
                        height: 35,
                        color: const Color(0xFFC2C2C2),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 32.0),
                      child: GestureDetector(
                        onTap: (){
                          FirebaseAuthentication().signOut();
                        },
                        child: Text(
                          'Sign out',
                          style: TextStyle(
                            fontSize: 20,
                            color: black
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
          body: Center(
            child: Row(children: [
              Card(
                  elevation: 1.5,
                  shadowColor: black,
                  child: Container(
                    width: width * 75,
                    child: listDrawerItems(false),
                  )),
              tabController!.index == 0
                  ? SizedBox(width: width * 30)
                  : SizedBox(width: width * 15),
              Container(
                  width: tabController!.index == 0 ? width * 1323 : width * 1165,
                  height: height * 979,
                  child: TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: tabController!,
                      children: screens
                  ))
            ]),
          )
      ),
    );

  }

  Widget listDrawerItems(bool drawerStatus) {
    double height = SizeConfig.safeBlockVertical!;
    double width = SizeConfig.safeBlockHorizontal!;
    return ListView(physics: const NeverScrollableScrollPhysics(), children: <Widget>[
      // SizedBox(height: height * 30),
      Row(children: [
        SizedBox(width: width * 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: height * 20,
              width: width * 20,
              child: FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset('assets/images/navBarHead.png'))),
        ),
        SizedBox(width: width * 10),
      ]),
      SizedBox(height: height * 3),
      // Divider(color: greyColor.withOpacity(0.10)),
      SizedBox(height: height * 10),
      TextButton(
          style: TextButton.styleFrom(
              fixedSize: Size(width * 35, height * 35),
              backgroundColor: tabController!.index == 1
                  ? tabSelection.withOpacity(0.20)
                  : white),
          onPressed: () {
            tabController!.animateTo(0);
          },
          child: Row(children: [
            SizedBox(width: width * 20),
            Container(
                width: width * 20,
                height: height * 20,
                child: FittedBox(
                    fit: BoxFit.cover,
                    child: Image.asset('assets/images/truck.png'))),
            SizedBox(width: height * 10),
          ])),
      SizedBox(height: height * 10),
      TextButton(
          style: TextButton.styleFrom(
              fixedSize: Size(width * 35, height * 35),
              backgroundColor: tabController!.index == 2
                  ? tabSelection.withOpacity(0.20)
                  : white),
          onPressed: () {
            tabController!.animateTo(1);
          },
          child: Container(
              width: width * 120,
              child: Row(children: [
                SizedBox(width: width * 20),
                SizedBox(
                    height: height * 20,
                    width: width * 20,
                    child: FittedBox(
                        fit: BoxFit.cover,
                        child: Image.asset('assets/images/user.png'))),
                SizedBox(width: height * 10),
              ]))),
      SizedBox(height: height * 10),
    ]);
  }

}