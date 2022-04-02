import 'package:fleet_management/screens/trackScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/color.dart';
import '../controller/transporterIdController.dart';
import '../firebase_auth.dart';
import '../models/gpsDataModel.dart';
import 'navigation_drawer_screen/myTrucksScreen.dart';

class TrackingPage extends StatefulWidget{
  final GpsDataModel gpsData;
  final List gpsDataHistory;
  final List gpsStoppageHistory;
  final List routeHistory;
  final String? TruckNo;
  final int? deviceId;
  // final String? driverNum;
  // final String? driverName;
  // final String? truckId;
  var totalDistance;
  var imei;
  var status;
  var lastupdated;
  TrackingPage(
      {required this.gpsData,
        required this.gpsDataHistory,
        required this.gpsStoppageHistory,
        required this.routeHistory,
        // required this.position,
        required this.TruckNo,
        //   this.driverName,
        //  this.driverNum,
        required this.deviceId,
        //  required this.truckId,
        required this.totalDistance,
        this.imei,
        required this.status,
        required this.lastupdated,
      });

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {

  TransporterIdController transporterIdController = Get.find<TransporterIdController>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
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

        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children:[
            Flexible(
                child: Container(
                  child: MyTrucks(),
                  width: MediaQuery.of(context).size.width / 4,
                )),
            SizedBox(
              width: MediaQuery.of(context).size.width/1.35,
              child: TrackScreen(
                deviceId: widget.gpsData.deviceId,
                gpsData: widget.gpsData,
                // position: position,
                TruckNo: widget.TruckNo,
                //   driverName: widget.truckData.driverName,
                //  driverNum: widget.truckData.driverNum,
                gpsDataHistory: widget.gpsDataHistory,
                gpsStoppageHistory: widget.gpsStoppageHistory,
                routeHistory: widget.routeHistory,
                //    truckId: widget.truckData.truckId,
                totalDistance: widget.totalDistance,
                imei: widget.imei, status: widget.status, lastupdated: widget.lastupdated,
              ),
            ),
          ]


        ),
      ),
    );
  }
}