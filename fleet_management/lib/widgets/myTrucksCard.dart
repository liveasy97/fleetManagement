import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_geocoding/google_geocoding.dart';
import 'package:provider/provider.dart';

import '../constants/color.dart';
import '../constants/fontSize.dart';
import '../constants/fontWeights.dart';
import '../constants/spaces.dart';
import '../functions/trackScreenFunctions.dart';
import '../models/deviceModel.dart';
import '../providerClass/providerData.dart';

// ignore: must_be_immutable
class MyTruckCard extends StatefulWidget {
  var truckno;
  var gpsData;
  String status;
  var imei;
  DeviceModel device;
  MyTruckCard(
      {required this.truckno,
        required this.status,
        this.gpsData,
        this.imei,
        required this.device});

  @override
  _MyTruckCardState createState() => _MyTruckCardState();
}

class _MyTruckCardState extends State<MyTruckCard> {

  bool online = true;
  Position? userLocation;
  bool driver = false;
  var gpsDataHistory;
  var gpsStoppageHistory;
  var gpsRoute;
  var totalDistance;
  var lastupdated;
  DateTime yesterday =
  DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));

  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));
  String? from;
  String? to;
  GoogleGeocoding? googleGeocoding;
  List<GeocodingResult> reverseGeocodingResults = [];

  @override
  void initState() {

    String apiKey = dotenv.env['mapKey'].toString();
    googleGeocoding = GoogleGeocoding(apiKey);
    addressFromLatLong();
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    super.initState();

    try {
      initfunction();
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    Map<String, Color> statusColor = {
      'Available': liveasyGreen,
      'Busy': Colors.red,
      'Offline': unselectedGrey,
    };

    if (widget.status == 'Online') {
      online = true;
    } else {
      online = false;
    }
    lastupdated =
        getStopDuration(widget.device.lastUpdate!, now.toIso8601String());

    ProviderData providerData = Provider.of<ProviderData>(context);
    return Container(
      color: Color(0xffF7F8FA),
      margin: EdgeInsets.only(bottom: space_2),
      child: GestureDetector(
        onTap: () async {
          // if (loading) {
          EasyLoading.instance
            ..indicatorType = EasyLoadingIndicatorType.ring
            ..indicatorSize = 45.0
            ..radius = 10.0
            ..maskColor = darkBlueColor
            ..userInteractions = false
            ..backgroundColor = darkBlueColor
            ..dismissOnTap = false;
          EasyLoading.show(
            status: "Loading...",
          );
          // getTruckHistory();
          print("clicked");
          print(widget.gpsData.deviceId);

          var f = getDataHistory(widget.gpsData.deviceId, from!, to!);
          var s = getStoppageHistory(widget.gpsData.deviceId, from!, to!);
          var t = getRouteStatusList(widget.gpsData.deviceId, from!, to!);

          gpsDataHistory = await f;
          gpsStoppageHistory = await s;
          gpsRoute = await t;
          print("done api");
          print(gpsRoute);
          print(gpsDataHistory);
          print(gpsStoppageHistory);
          if (gpsRoute != null &&
              gpsDataHistory != null &&
              gpsStoppageHistory != null) {
            EasyLoading.dismiss();
            print('here no');
            print(widget.gpsData.address);
          } else {
            EasyLoading.dismiss();
            print("gpsData null or truck not approved");
            print(widget.gpsData.address);
          }
        },
        child: Card(
          elevation: 5,
          child: Container(
            // width: MediaQuery.of(context).size.width/3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.all(space_3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FA),
                  ),
                  child: Column(
                    children: [
                      online
                          ? Container(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0,5,5,5),
                              child: Icon(
                                Icons.circle,
                                color: const Color(0xff09B778),
                                size: 6,
                              ),
                            ),
                            Text(
                              'online'.tr,
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            ),
                            Container(
                              child: Text(
                                '(${'Last Updated'} $lastupdated ${'ago'})',
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 12,
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
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(
                              child: Text(
                                '(${'Last Updated'} $lastupdated ${'ago'})',
                                maxLines: 3,
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),

                      Row(
                        children: [
                          Image.asset(
                            'assets/icons/box-truck.png',
                            width: 29,
                            height: 29,
                          ),
                          SizedBox(
                            width: 13,
                          ),
                          Column(
                            children: [
                              Text(
                                '${widget.truckno}',
                                style: TextStyle(
                                  fontSize: 20,
                                  color: black,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(width: 70,),
                          (widget.gpsData.speed > 2)
                              ? Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    "${(widget.gpsData.speed).round()} km/h",
                                    style: TextStyle(
                                        color: liveasyGreen,
                                        fontSize: size_10,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: regularWeight)),
                                Text('running'.tr,
                                    // "Status",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: size_6,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: regularWeight))
                              ],
                            ),
                          )
                              : Container(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                    "${(widget.gpsData.speed).round()} km/h",
                                    style: TextStyle(
                                        color: red,
                                        fontSize: size_10,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: regularWeight)),
                                Text('stopped'.tr,
                                    // "Status",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: size_6,
                                        fontStyle: FontStyle.normal,
                                        fontWeight: regularWeight))
                              ],
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 11,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.place_outlined,
                                color: const Color(0xFFCDCDCD),
                                size: 16,
                              ),
                              SizedBox(width: 8),
                              Container(
                                width: 200,
                                child: Text(
                                  "${widget.gpsData.address}",
                                  maxLines: 3,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: 12,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: normalWeight),
                                ),
                              ),
                            ]),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                        child: Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              size: 14,
                              color: const Color(0xFFCDCDCD),
                            ),
                            SizedBox(width: 8),
                            Text('truckTravelled'.tr,
                                // "Truck Travelled : ",
                                softWrap: true,
                                style: TextStyle(
                                    color: black,
                                    fontSize: size_6,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: regularWeight)),
                            Text("$totalDistance " + 'kmToday'.tr,
                                // "km Today",
                                softWrap: true,
                                style: TextStyle(
                                    color: black,
                                    fontSize: size_6,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: regularWeight)),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 6,
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(26, 0, 0, 0),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/icons/circle-outline-with-a-central-dot.png',
                              color: const Color(0xFFCDCDCD),
                              width: 12,
                              height: 12,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text('ignition'.tr,
                                // 'Ignition  :',
                                style: TextStyle(
                                    color: black,
                                    fontSize: size_6,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: regularWeight)),
                            (widget.gpsData.ignition)
                                ? Text('on'.tr,
                                // "ON",
                                style: TextStyle(
                                    color: black,
                                    fontSize: size_6,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: regularWeight))
                                : Text('off'.tr,
                                // "OFF",
                                style: TextStyle(
                                    color: black,
                                    fontSize: size_6,
                                    fontStyle: FontStyle.normal,
                                    fontWeight: regularWeight)),
                          ],
                        ),
                      ),

                    ],
                  ),
                )

              ],
            ),
          ),
        ),
      ),
    );
  }

  initfunction() async {
    var gpsRoute1 = await mapUtil.getTraccarSummary(
        deviceId: widget.gpsData.deviceId, from: from, to: to);
    setState(() {
      totalDistance = (gpsRoute1[0].distance / 1000).toStringAsFixed(2);
    });
    print('in init');
  }

  addressFromLatLong() async{
    var response = await googleGeocoding?.geocoding.getReverse(LatLon(widget.gpsData.latitude,widget.gpsData.longitude));
    if (response != null && response.results != null) {
      if (mounted) {
        setState(() {
          reverseGeocodingResults = response.results!;
        });
      }
    } else {
      if (mounted) {
        setState(() {
          reverseGeocodingResults = [];
        });
      }
    }
  }

}
