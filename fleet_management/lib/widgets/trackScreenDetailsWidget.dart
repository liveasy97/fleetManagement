import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants/color.dart';
import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';
import '../constants/spaces.dart';
import '../controller/dynamicLink.dart';
import '../screens/nearbyPlacesScreen.dart';
import '../screens/playRouteHistoryScreen.dart';
import '../screens/truckAnalysisScreen.dart';
import '../screens/truckHistoryScreen.dart';

class TrackScreenDetails extends StatefulWidget {
  // final String? driverNum;
  final String? TruckNo;

//  final String? driverName;
  String? dateRange;
  var gpsData;
  var gpsTruckRoute;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var stops;
  var totalRunningTime;
  var totalStoppedTime;
  var deviceId;

  //var truckId;
  var totalDistance;
  var imei;
  var recentStops;
  var status;
  var lastupdated;

  TrackScreenDetails({
    required this.gpsData,
    required this.gpsTruckRoute,
    required this.gpsDataHistory,
    required this.gpsStoppageHistory,
    //  required this.driverNum,
    required this.dateRange,
    required this.TruckNo,
    //  required this.driverName,
    required this.stops,
    required this.totalRunningTime,
    required this.totalStoppedTime,
    required this.deviceId,
    //required this.truckId,
    required this.totalDistance,
    this.imei,
    this.recentStops,
    required this.status,
    required this.lastupdated,
  });

  @override
  _TrackScreenDetailsState createState() => _TrackScreenDetailsState();
}

class _TrackScreenDetailsState extends State<TrackScreenDetails> {
  var gpsData;
  var gpsTruckRoute;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var stops;
  var totalRunningTime;
  var totalStoppedTime;
  var latitude;
  var longitude;
  var recentStops;
  bool online = true;
  Timer? timer;
  DateTime now =
      DateTime.now().subtract(Duration(days: 0, hours: 5, minutes: 30));
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  String selectedLocation = '24 hours';

  @override
  void initState() {
    super.initState();
    initFunction();
    timer = Timer.periodic(
        Duration(minutes: 0, seconds: 10), (Timer t) => initFunction());
  }

  initFunction() {
    setState(() {
      recentStops = widget.recentStops;
      gpsData = widget.gpsData;
      gpsTruckRoute = widget.gpsTruckRoute;
      gpsDataHistory = widget.gpsDataHistory;
      gpsStoppageHistory = widget.gpsStoppageHistory;
      stops = widget.stops;
      totalRunningTime = widget.totalRunningTime;
      totalStoppedTime = widget.totalStoppedTime;
      latitude = gpsData.last.latitude;
      longitude = gpsData.last.longitude;
    });
  }

  static Future<void> openMap(double latitude, double longitude) async {
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
    if (await canLaunch(googleUrl)) {
      await launch(googleUrl);
    } else {
      throw 'Could not open the map.';
    }
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    if (widget.status == 'Online') {
      online = true;
    } else {
      online = false;
    }

    return Container(
        height: height / 2.8 + 116,
        width: width,
        padding: EdgeInsets.fromLTRB(0, 0, 0, space_3),
        decoration: BoxDecoration(
            color: white,
            borderRadius:
                BorderRadius.only(topLeft: Radius.zero, topRight: Radius.zero),
            boxShadow: [
              BoxShadow(
                color: darkShadow,
                offset: const Offset(
                  0,
                  -5.0,
                ),
                blurRadius: 15.0,
                spreadRadius: 10.0,
              ),
              BoxShadow(
                color: white,
                offset: const Offset(0, 1.0),
                blurRadius: 0.0,
                spreadRadius: 2.0,
              ),
            ]),
        child: Padding(
            padding: const EdgeInsets.only(top: 28.0, left: 40),
            child: Container(
                child: Row(children: [
              Flexible(
                child: Column(
                  children: [
                    online
                        ? Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                  child: Icon(
                                    Icons.circle,
                                    color: const Color(0xff09B778),
                                    size: 8,
                                  ),
                                ),
                                Text(
                                  'online'.tr,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                Container(
                                  child: Text(
                                    '(${'Last Updated'} ${widget.lastupdated} ${'ago'})',
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          )
                        : Container(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(0, 5, 5, 5),
                                  child: Icon(
                                    Icons.circle,
                                    color: const Color(0xffFF4D55),
                                    size: 6,
                                  ),
                                ),
                                Text(
                                  'offline'.tr,
                                  style: TextStyle(
                                    fontSize: 15,
                                  ),
                                ),
                                SizedBox(
                                  child: Text(
                                    '(${'Last Updated'} ${widget.lastupdated} ${'ago'})',
                                    maxLines: 3,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8),
                      child: Row(
                        children: [
                          Image.asset(
                            'assets/icons/box-truck.png',
                            width: 72,
                            height: 72,
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Column(
                            children: [
                              Text(
                                '${widget.TruckNo}',
                                style: TextStyle(
                                  fontSize: 30,
                                  color: black,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.place_outlined,
                              color: bidBackground,
                              size: 20,
                            ),
                            SizedBox(width: 8),
                            Container(
                              width: width / 4.2,
                              child: Text(
                                "${gpsData.last.address}",
                                maxLines: 2,
                                style: TextStyle(
                                    color: black,
                                    fontSize: 15,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: normalWeight),
                              ),
                            ),
                          ]),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8),
                      child: Container(
                        margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            //  textDirection:
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/icons/circle-outline-with-a-central-dot.png',
                                color: bidBackground,
                                width: 15,
                                height: 15,
                              ),
                              SizedBox(width: 10),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Text('ignition'.tr,
                                    softWrap: true,
                                    style: TextStyle(
                                        color: black,
                                        fontSize: 15,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: regularWeight)),
                              ),
                              (gpsData.last.ignition)
                                  ? Container(
                                      alignment: Alignment.centerLeft,
                                      //    width: 217,

                                      child: Text('on'.tr,
                                          softWrap: true,
                                          style: TextStyle(
                                              color: black,
                                              fontSize: 15,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.bold)),
                                    )
                                  : Container(
                                      alignment: Alignment.centerLeft,
                                      //    width: 217,

                                      child: Text("off".tr,
                                          softWrap: true,
                                          style: TextStyle(
                                              color: black,
                                              fontSize: 15,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: FontWeight.bold)),
                                    ),
                            ]),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0, left: 8),
                      child: Row(children: [
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Image(
                                image: AssetImage(
                                    'assets/icons/distanceCovered.png'),
                                height: 20,
                                width: 20,
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                //      width: 103,
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text('truckTravelled'.tr,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: liveasyGreen,
                                                fontSize: 15,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: regularWeight)),
                                        Text(
                                            "${widget.totalDistance} " +
                                                "km".tr,
                                            softWrap: true,
                                            style: TextStyle(
                                                color: black,
                                                fontSize: 15,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: regularWeight)),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Text("$totalRunningTime ",
                                            softWrap: true,
                                            style: TextStyle(
                                                color: grey,
                                                fontSize: 15,
                                                fontStyle: FontStyle.normal,
                                                fontWeight: regularWeight)),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ]),
                        SizedBox(
                          width: 5,
                        ),
                        Container(
                          width: 1,
                          height: 20,
                          color: Colors.grey,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Row(
                          children: [
                            Icon(Icons.pause, size: 20),
                            SizedBox(
                              width: space_1,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              //    width: 103,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Text("${gpsStoppageHistory.length} ",
                                          softWrap: true,
                                          style: TextStyle(
                                              color: black,
                                              fontSize: 15,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: regularWeight)),
                                      Text("stops".tr,
                                          softWrap: true,
                                          style: TextStyle(
                                              color: red,
                                              fontSize: 15,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: regularWeight)),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text("$totalStoppedTime ",
                                          softWrap: true,
                                          style: TextStyle(
                                              color: grey,
                                              fontSize: size_4,
                                              fontStyle: FontStyle.normal,
                                              fontWeight: regularWeight)),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ]),
                    ),
                  ],
                ),
              ),
              Flexible(
                child: VerticalDivider(
                  color: black,
                  // height: size_3,
                  thickness: 0.75,
                  indent: size_10,
                  endIndent: size_10,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: darkShadow,
                                      offset: const Offset(
                                        0,
                                        5.0,
                                      ),
                                      blurRadius: 5.0,
                                      spreadRadius: 5.0,
                                    ),
                                    BoxShadow(
                                      color: white,
                                      offset: const Offset(0, 1.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ]),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      width: 50,
                                      height: 50,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: bidBackground, width: 4),
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: FloatingActionButton(
                                        heroTag: "button1",
                                        backgroundColor: Colors.white,
                                        foregroundColor: bidBackground,
                                        child: Image.asset(
                                          'assets/icons/navigate2.png',
                                          scale: 2.5,
                                        ),
                                        onPressed: () {
                                          openMap(gpsData.last.latitude,
                                              gpsData.last.longitude);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 8,
                                    ),
                                    Text(
                                      "navigate".tr,
                                      style: TextStyle(
                                          color: black,
                                          fontSize: size_6,
                                          fontStyle: FontStyle.normal,
                                          fontWeight: mediumBoldWeight),
                                    ),
                                  ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: darkShadow,
                                      offset: const Offset(
                                        0,
                                        5.0,
                                      ),
                                      blurRadius: 5.0,
                                      spreadRadius: 5.0,
                                    ),
                                    BoxShadow(
                                      color: white,
                                      offset: const Offset(0, 1.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ]),

                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                DynamicLinkService(
                                  deviceId: widget.deviceId,
                                  // truckId: widget.truckId,
                                  truckNo: widget.TruckNo,
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "share".tr,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: size_6,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: mediumBoldWeight),
                                ),
                              ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: darkShadow,
                                      offset: const Offset(
                                        0,
                                        5.0,
                                      ),
                                      blurRadius: 5.0,
                                      spreadRadius: 5.0,
                                    ),
                                    BoxShadow(
                                      color: white,
                                      offset: const Offset(0, 1.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ]),

                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: bidBackground, width: 4),
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: FloatingActionButton(
                                    heroTag: "button3",
                                    backgroundColor: Colors.white,
                                    foregroundColor: bidBackground,
                                    child: const Icon(Icons.play_circle_outline,
                                        size: 30),
                                    onPressed: () {
                                      Get.to(PlayRouteHistory(
                                        gpsTruckHistory: gpsDataHistory,
                                        truckNo: widget.TruckNo,
                                        //    routeHistory: gpsTruckRoute,
                                        gpsData: gpsData,
                                        dateRange: widget.dateRange,
                                        gpsStoppageHistory: gpsStoppageHistory,
                                        //   totalDistance: totalDistance,
                                        totalRunningTime: totalRunningTime,
                                        totalStoppedTime: totalStoppedTime,
                                      ));
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "playtrip".tr,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: size_6,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: mediumBoldWeight),
                                ),
                              ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: darkShadow,
                                      offset: const Offset(
                                        0,
                                        5.0,
                                      ),
                                      blurRadius: 5.0,
                                      spreadRadius: 5.0,
                                    ),
                                    BoxShadow(
                                      color: white,
                                      offset: const Offset(0, 1.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ]),

                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: bidBackground, width: 4),
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: FloatingActionButton(
                                    heroTag: "button4",
                                    backgroundColor: Colors.white,
                                    foregroundColor: bidBackground,
                                    child: const Icon(Icons.history, size: 30),
                                    onPressed: () {
                                      Get.to(TruckHistoryScreen(
                                        truckNo: widget.TruckNo,
                                        gpsTruckRoute: widget.gpsTruckRoute,
                                        dateRange: widget.dateRange,
                                        deviceId: widget.deviceId,
                                        selectedLocation: selectedLocation,
                                        istDate1: yesterday,
                                        istDate2: now,
                                        totalDistance: widget.totalDistance,
                                        //     latitude: latitude,
                                        //      longitude: longitude,
                                      ));
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "history".tr,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: size_6,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: mediumBoldWeight),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: darkShadow,
                                      offset: const Offset(
                                        0,
                                        5.0,
                                      ),
                                      blurRadius: 5.0,
                                      spreadRadius: 5.0,
                                    ),
                                    BoxShadow(
                                      color: white,
                                      offset: const Offset(0, 1.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ]),
                              width: 100,
                              height: 100,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: bidBackground, width: 4),
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: FloatingActionButton(
                                    heroTag: "button5",
                                    backgroundColor: Colors.white,
                                    foregroundColor: bidBackground,
                                    child: Image.asset(
                                      'assets/icons/gas_station.png',
                                      scale: 2.5,
                                    ),
                                    onPressed: () {
                                      Get.to(
                                        NearbyPlacesScreen(
                                          deviceId: widget.deviceId,
                                          gpsData: widget.gpsData,
                                          placeOnTheMapTag: "gas_station",
                                          placeOnTheMapName: "petrol_pump".tr,
                                          // position: position,
                                          TruckNo: widget.TruckNo,
                                          // driverName: widget.driverName,
                                          //  driverNum: widget.driverNum,
                                          //   truckId: widget.truckId,
                                          //    gpsDataHistory: widget.gpsDataHistory,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'petrol_pump'.tr,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: size_6,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: mediumBoldWeight),
                                ),
                              ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: darkShadow,
                                      offset: const Offset(
                                        0,
                                        5.0,
                                      ),
                                      blurRadius: 5.0,
                                      spreadRadius: 5.0,
                                    ),
                                    BoxShadow(
                                      color: white,
                                      offset: const Offset(0, 1.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ]),

                              width: 100,
                              height: 100,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: bidBackground, width: 4),
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: FloatingActionButton(
                                    heroTag: "button6",
                                    backgroundColor: Colors.white,
                                    foregroundColor: bidBackground,
                                    child: Image.asset(
                                      'assets/icons/police.png',
                                      scale: 2.5,
                                    ),
                                    onPressed: () {
                                      Get.to(
                                        NearbyPlacesScreen(
                                          deviceId: widget.deviceId,
                                          gpsData: widget.gpsData,
                                          placeOnTheMapTag: "police",
                                          placeOnTheMapName: "police_station".tr,
                                          // position: position,
                                          TruckNo: widget.TruckNo,
                                          //  driverName: widget.driverName,
                                          //   driverNum: widget.driverNum,
                                          //  truckId: widget.truckId,
                                          // gpsDataHistory: widget.gpsDataHistory,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  'police_station'.tr,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: size_6,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: mediumBoldWeight),
                                ),
                              ]),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      topRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: darkShadow,
                                      offset: const Offset(
                                        0,
                                        5.0,
                                      ),
                                      blurRadius: 5.0,
                                      spreadRadius: 5.0,
                                    ),
                                    BoxShadow(
                                      color: white,
                                      offset: const Offset(0, 1.0),
                                      blurRadius: 0.0,
                                      spreadRadius: 2.0,
                                    ),
                                  ]),

                              width: 100,
                              height: 100,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                Container(
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    border:
                                        Border.all(color: bidBackground, width: 4),
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: FloatingActionButton(
                                    heroTag: "button7",
                                    backgroundColor: Colors.white,
                                    foregroundColor: bidBackground,
                                    child: Image.asset(
                                      'assets/icons/truckAnalysis.png',
                                      scale: 2.5,
                                    ),
                                    onPressed: () {
                                      Get.to(truckAnalysisScreen(
                                          recentStops: recentStops,
                                          //   truckId: widget.truckId,
                                          TruckNo: widget.TruckNo,
                                          imei: widget.imei,
                                          deviceId: widget.deviceId));
                                    },
                                  ),
                                ),
                                SizedBox(
                                  height: 8,
                                ),
                                Text(
                                  "truckanalysis".tr,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: size_6,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: mediumBoldWeight),
                                ),
                              ]),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              )
            ]))));
  }
}
