import 'package:async/async.dart';
import 'package:fleet_management/screens/navigation_drawer_screen/myTrucksScreen.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';

import '../../constants/spaces.dart';
import '../../controller/transporterIdController.dart';
import '../../functions/mapUtils/getLoactionUsingImei.dart';
import '../../functions/truckApis/truckApiCalls.dart';
import '../mapAllTrucks.dart';

class FirstPage extends StatefulWidget {
  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  //TransporterId controller
  TransporterIdController transporterIdController =
      Get.find<TransporterIdController>();

  //Scroll Controller for Pagination
  ScrollController scrollController = ScrollController();

  TruckApiCalls truckApiCalls = TruckApiCalls();

  // Truck Model List used to  create cards
  // var truckDataList = [];
  var devicelist = [];
  var trucklist = [];

  // var truckAddressList = [];
  var status = [];
  var gpsDataList = [];
  var gpsStoppageHistory = [];
  MapUtil mapUtil = MapUtil();
  List<Placemark>? placemarks;
  String? date;
  var runningdevicelist = [];
  var stoppeddevicelist = [];
  var gpsData;
  bool loading = false;
  DateTime yesterday =
      DateTime.now().subtract(Duration(days: 1, hours: 5, minutes: 30));
  String? from;
  String? to;
  DateTime now = DateTime.now().subtract(Duration(hours: 5, minutes: 30));
  var runningList = [];
  var runningStatus = [];
  var runningGpsData = [];
  int i = 0;
  var StoppedList = [];
  var StoppedStatus = [];
  var StoppedGpsData = [];
  var truckDataListForPage = [];

  var gpsList = [];
  var stat = [];
  var running = [];
  var runningStat = [];
  var runningGps = [];
  var Stopped = [];
  var StoppedStat = [];
  var StoppedGps = [];

  var items = [];
  var dummySearchList = [];

  TextEditingController editingController = TextEditingController();

  @override
  void initState() {
    from = yesterday.toIso8601String();
    to = now.toIso8601String();
    FutureGroup futureGroup = FutureGroup();
    super.initState();
    setState(() {
      loading = true;
    });
    var f1 = getMyTruckPosition();
    var f2 = getMyDevices(i);

    futureGroup.add(f1);
    futureGroup.add(f2);

    futureGroup.close();
    scrollController.addListener(() {
      if (scrollController.position.pixels ==
          scrollController.position.maxScrollExtent) {
        i = i + 1;
        getMyDevices(i);
      }
    });

    //search
    dummySearchList = items;
    // items = items;
    // gpsDataList = gpsDataList;
    // status = widget.status;
    // deviceList = widget.deviceList;
    print("CHECK Init${status}");
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
        child: Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Flexible(
              child: Container(
            child: MyTrucks(),
            width: MediaQuery.of(context).size.width / 4,
          )),
          Container(
            padding: EdgeInsets.fromLTRB(0, space_4, 0, space_2),
            height: MediaQuery.of(context).size.height -
                kBottomNavigationBarHeight -
                space_4,
            width: MediaQuery.of(context).size.width/1.5,
            child:
                // MapTrucks()
                MapAllTrucks(
              gpsDataList: gpsDataList,
              runningDataList: runningList,
              runningGpsDataList: runningGpsData,
              stoppedList: StoppedList,
              stoppedGpsList: StoppedGpsData,
              deviceList: trucklist,
                  status: status,
            ),
          )
        ],
      ),
    ));
  }

  getMyDevices(int i) async {
    var devices = await mapUtil.getDevices();
    trucklist.clear();
    devicelist.clear();
    for (var device in devices) {
      setState(() {
        trucklist.add(device.truckno);
        devicelist.add(device);
      });
    }
  }

  getMyTruckPosition() async {
    //   FutureGroup futureGroup = FutureGroup();

    var devices = await mapUtil.getDevices();

    print("total devices for me are ${devices.length}");

    setState(() {
      items = devices;
    });

    //FIX LENGTH OF ALL LIST----------------------
    gpsList = List.filled(devices.length, null, growable: true);
    stat = List.filled(devices.length, "", growable: true);
    running = List.filled(devices.length, null, growable: true);
    runningStat = List.filled(devices.length, "", growable: true);
    runningGps = List.filled(devices.length, null, growable: true);
    Stopped = List.filled(devices.length, null, growable: true);
    StoppedStat = List.filled(devices.length, "", growable: true);
    StoppedGps = List.filled(devices.length, null, growable: true);
    runningdevicelist = List.filled(devices.length, null, growable: true);
    stoppeddevicelist = List.filled(devices.length, null, growable: true);
    //------------------------------------------------

    //START ADDING DATA-------------------------------
    /*for (int i = 0; i < devices.length; i++) {
      print(
          "DeviceId is ${devices[i].deviceId} for ${devices[i].truckno}");


        var future = getGPSData(devices[i], i);
        futureGroup.add(future);

    }
    futureGroup.close();
    await futureGroup.future; */ //Fire all APIs at once (not one after the other)

    var gpsDataAll = await mapUtil.getTraccarPositionforAll();
    for (int i = 0; i < gpsDataAll.length; i++) {
      print("DeviceId is ${devices[i].deviceId} for ${devices[i].truckno}");

      getGPSData(gpsDataAll[i], i, devices[i].truckno, devices[i]);
    }

    setState(() {
      gpsDataList = gpsList;
      status = stat;

      runningList = running;
      runningGpsData = runningGps;
      runningStatus = runningStat;

      StoppedList = Stopped;
      StoppedGpsData = StoppedGps;
      StoppedStatus = StoppedStat;
    });

    //NOW REMOVE EXTRA ELEMENTS FROM RUNNING AND STOPPED LISTS-------

    runningList.removeWhere((item) => item == null);
    runningGpsData.removeWhere((item) => item == null);
    runningStatus.removeWhere((item) => item == "");
    runningdevicelist.removeWhere((item) => item == null);
    stoppeddevicelist.removeWhere((item) => item == null);
    StoppedList.removeWhere((item) => item == null);
    StoppedGpsData.removeWhere((item) => item == null);
    StoppedStatus.removeWhere((item) => item == "");

    print("ALL $status");
    print("ALL $gpsDataList");
    print("ALL RUNNING $runningList");
    print("ALL STOPPED $StoppedList");
    print("ALL STOPPED $StoppedGpsData ");
    print("ALL STOPPED $StoppedStatus");
    print("--TRUCK SCREEN DONE--");
    setState(() {
      loading = false;
    });
  }

  getGPSData(var gpsData, int i, var truckno, var device) async {
    getStoppedSince(gpsData, i, device);
    print('get stopped done');
    if (gpsData.speed >= 2) //For RUNNING Section
    {
      running.removeAt(i);
      runningGps.removeAt(i);
      runningdevicelist.removeAt(i);
      running.insert(i, truckno);
      runningdevicelist.insert(i, device);
      runningGps.insert(i, gpsData);
    } else if (gpsData.speed < 2) {
      //For STOPPED section

      Stopped.removeAt(i);
      StoppedGps.removeAt(i);
      stoppeddevicelist.removeAt(i);
      stoppeddevicelist.insert(i, device);
      Stopped.insert(i, truckno);
      StoppedGps.insert(i, gpsData);
    }
    gpsList.removeAt(i);

    gpsList.insert(i, gpsData);
    print("DONE ONE PART");
  }

  getStoppedSince(var gpsData, int i, var device) async {
    if (device.status == 'online') {
      StoppedStat.removeAt(i);
      StoppedStat.insert(i, "Online");

      runningStat.removeAt(i);
      runningStat.insert(i, "Online");

      stat.removeAt(i);
      stat.insert(i, "Online");
    } else {
      StoppedStat.removeAt(i);
      StoppedStat.insert(i, "Offline");

      runningStat.removeAt(i);
      runningStat.insert(i, "Offline");

      stat.removeAt(i);
      stat.insert(i, "Offline");
    }
    /*   if (gpsData.motion == false) {
      StoppedStat.removeAt(i);
      StoppedStat.insert(i, "Stopped");

      stat.removeAt(i);
      stat.insert(i, "Stopped");
    } else {
      runningStat.removeAt(i);
      runningStat.insert(i, "Running");

      stat.removeAt(i);
      stat.insert(i, "Running");
    }*/
  }
}
