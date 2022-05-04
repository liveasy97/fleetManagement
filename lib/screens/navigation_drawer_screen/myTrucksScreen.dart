import 'package:async/async.dart';
import 'package:fleet_management/maptest.dart';
import 'package:fleet_management/screens/MapTrucks.dart';
import 'package:fleet_management/widgets/buttons/addTruckButton.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../constants/color.dart';
import '../../constants/fontSize.dart';
import '../../constants/spaces.dart';
import '../../controller/transporterIdController.dart';
import '../../functions/mapUtils/getLoactionUsingImei.dart';
import '../../functions/truckApis/truckApiCalls.dart';
import '../../providerClass/providerData.dart';
import '../../widgets/headingTextWidget.dart';
import '../../widgets/helpButton.dart';
import '../../widgets/loadingWidgets/bottomProgressBarIndicatorWidget.dart';
import '../../widgets/loadingWidgets/truckLoadingWidgets.dart';
import '../../widgets/myTrucksCard.dart';
import '../../widgets/truckScreenBarButton.dart';
import '../add truck/truckNumberRegistration.dart';
import '../mapAllTrucks.dart';
import '../myTrucksSearchResultsScreen.dart';

class MyTrucks extends StatefulWidget {
  @override
  _MyTrucksState createState() => _MyTrucksState();
}

class _MyTrucksState extends State<MyTrucks> {
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
    ProviderData providerData = Provider.of<ProviderData>(context);
    PageController pageController =
    PageController(initialPage: providerData.upperNavigatorIndex);
    return Scaffold(
      backgroundColor: backgroundColor,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_2),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width/4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  margin: EdgeInsets.symmetric(vertical: space_3),
                  child: Container(
                    height: space_8,
                    decoration: BoxDecoration(
                      color: widgetBackGroundColor,
                      borderRadius: BorderRadius.zero,
                      border: Border.all(
                        width: 0.8,
                        // color: borderBlueColor,
                      ),
                    ),
                    child: TextField(
                      // onTap: () {
                      //   Get.to(MyTrucksResult(
                      //       gpsDataList: gpsDataList,
                      //       deviceList: devicelist,
                      //       //truckAddressList: truckAddressList,
                      //       status: status,
                      //       items: items,
                      //     ),
                      //   );
                      //   print("Enterrr");
                      //   print("THE ITEMS $items");
                      // },
                      // readOnly: true,
                      textCapitalization: TextCapitalization.characters,
                      onChanged: (value) {
                        filterSearchResults(value);
                        print("EnteRRR");
                        print(gpsDataList);
                        print(status);
                        //print("THE ITEMS $items");
                      },
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      controller: editingController,
                      textAlignVertical: TextAlignVertical.center,
                      textAlign: TextAlign.start,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'search'.tr,
                        icon: Padding(
                          padding: EdgeInsets.only(left: space_2),
                          child: Icon(
                            Icons.search,
                            color: grey,
                          ),
                        ),
                        hintStyle: TextStyle(
                          fontSize: size_8,
                          color: grey,
                        ),
                      ),
                    ),
                  ),
                ),

                //LIST OF TRUCK CARDS---------------------------------------------
                SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.fromLTRB(10, 2, 10, 2),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7F8FA),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFEFEFEF),
                          blurRadius: 9,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        TruckScreenBarButton(
                            text: 'all'.tr,
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
                            text: 'running'.tr,
                            // 'Running'
                            value: 1,
                            pageController: pageController),
                        Container(
                          padding: EdgeInsets.all(0),
                          width: 1,
                          height: 15,
                          color: const Color(0xFFC2C2C2),
                        ),
                        TruckScreenBarButton(
                            text: 'stopped'.tr,
                            // 'Stopped',
                            value: 2,
                            pageController: pageController),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 6,
                ),
                SizedBox(
                  height: 15,
                ),
                Expanded(
                  child: Stack(children: [
                    Container(
                      //    margin: EdgeInsets.fromLTRB(space_2, 0, space_2, 0),
                      height: MediaQuery.of(context).size.height -
                          kBottomNavigationBarHeight -
                          230 -
                          space_4,
                      child: PageView(
                          controller: pageController,
                          onPageChanged: (value) {
                            setState(() {
                              providerData.updateUpperNavigatorIndex(value);
                            });
                          },
                          children: [
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                loading
                                    ? TruckLoadingWidgets()
                                    : trucklist.isEmpty
                                    ? Container(
                                  // height: MediaQuery.of(context).size.height * 0.27,
                                  margin: EdgeInsets.only(top: 153),
                                  child: Column(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/images/TruckListEmptyImage.png'),
                                        height: 127,
                                        width: 127,
                                      ),
                                      Text(
                                        'notruckadded'.tr,
                                        // 'Looks like you have not added any Trucks!',
                                        style: TextStyle(
                                            fontSize: size_8,
                                            color: grey),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ): ListView.builder(
                                      physics: AlwaysScrollableScrollPhysics(),
                                      controller: scrollController,
                                      scrollDirection: Axis.vertical,
                                      padding: EdgeInsets.only(
                                          bottom: space_15),
                                      itemCount: trucklist.length,
                                      itemBuilder: (context, index) =>
                                      index == trucklist.length
                                          ? bottomProgressBarIndicatorWidget()
                                          : MyTruckCard(
                                        truckno:
                                        trucklist[index],
                                        status: status[index],
                                        gpsData:
                                        gpsDataList[index],
                                        device:
                                        devicelist[index],
                                      )),

                              ],
                            ),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                loading
                                    ? TruckLoadingWidgets()
                                    : runningList.isEmpty
                                    ? Container(
                                  // height: MediaQuery.of(context).size.height * 0.27,
                                  margin: EdgeInsets.only(top: 153),
                                  child: Column(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/images/TruckListEmptyImage.png'),
                                        height: 127,
                                        width: 127,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'notruckrunnning'.tr,
                                        // 'Looks like none of your trucks are running!',
                                        style: TextStyle(
                                            fontSize: size_8,
                                            color: grey),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                                    :  ListView.builder(
                                    padding:
                                    EdgeInsets.only(bottom: space_15),
                                    physics: AlwaysScrollableScrollPhysics(),
                                    controller: scrollController,
                                    scrollDirection: Axis.vertical,
                                    itemCount: runningList.length,
                                    itemBuilder: (context, index) => index ==
                                        runningList.length
                                        ? bottomProgressBarIndicatorWidget()
                                        : MyTruckCard(
                                      truckno: runningList[index],
                                      status: runningStatus[index],
                                      gpsData:
                                      runningGpsData[index],
                                      device:
                                      runningdevicelist[index],
                                    ),
                                  ),

                              ],
                            ),
                            Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                loading
                                    ? TruckLoadingWidgets()
                                    : StoppedList.isEmpty
                                    ? Container(
                                  // height: MediaQuery.of(context).size.height * 0.27,
                                  margin: EdgeInsets.only(top: 153),
                                  child: Column(
                                    children: [
                                      Image(
                                        image: AssetImage(
                                            'assets/images/TruckListEmptyImage.png'),
                                        height: 127,
                                        width: 127,
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'notruckstopped'.tr,
                                        // 'Looks like none of your trucks are stopped!',
                                        style: TextStyle(
                                            fontSize: size_8,
                                            color: grey),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                )
                                    : ListView.builder(
                                    padding:
                                    EdgeInsets.only(bottom: space_15),
                                    physics: AlwaysScrollableScrollPhysics(),
                                    controller: scrollController,
                                    scrollDirection: Axis.vertical,
                                    itemCount: StoppedList.length,
                                    itemBuilder: (context, index) => index ==
                                        StoppedList.length
                                        ? bottomProgressBarIndicatorWidget()
                                        : MyTruckCard(
                                      truckno: StoppedList[index],
                                      status: StoppedStatus[index],
                                      gpsData:
                                      StoppedGpsData[index],
                                      device:
                                      stoppeddevicelist[index],

                                    ),
                                  ),

                              ],
                            ),
                          ]),
                    ),
                    Positioned(
                      bottom: 25.0,
                      right: 0.0,
                      child: FloatingActionButton(
                        onPressed: () {
                          Get.to(AddNewTruck());
                        },
                        backgroundColor: darkBlueColor,
                        child: Icon(Icons.add),
                      ),
                    )
                  ]),
                ),
              ],
            ),
          ),
          // Expanded(
          //   child: Container(
          //     padding: EdgeInsets.fromLTRB(space_4, space_4, space_4, space_2),
          //     height: MediaQuery.of(context).size.height -
          //         kBottomNavigationBarHeight -
          //         space_4,
          //     width: MediaQuery.of(context).size.width,
          //     child:
          //     // MapTrucks()
          //     MapAllTrucks(
          //       gpsDataList: gpsDataList,
          //       runningDataList: runningList,
          //       runningGpsDataList: runningGpsData,
          //       stoppedList: StoppedList,
          //       stoppedGpsList: StoppedGpsData,
          //       deviceList: trucklist,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  } //build

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

  refreshData(int i) async {
    FutureGroup futureGroup = FutureGroup();
    print("device list $devicelist");
    //FIX LENGTH OF ALL LIST----------------------
    gpsList = List.filled(devicelist.length, null, growable: true);
    stat = List.filled(devicelist.length, "", growable: true);
    running = List.filled(devicelist.length, null, growable: true);
    runningStat = List.filled(devicelist.length, "", growable: true);
    runningGps = List.filled(devicelist.length, null, growable: true);
    Stopped = List.filled(devicelist.length, null, growable: true);
    StoppedStat = List.filled(devicelist.length, "", growable: true);
    StoppedGps = List.filled(devicelist.length, null, growable: true);
    runningdevicelist = List.filled(devicelist.length, null, growable: true);
    stoppeddevicelist = List.filled(devicelist.length, null, growable: true);
    //------------------------------------------------
    //Fire all APIs at once (not one after the other)
    var gpsDataAll = await mapUtil.getTraccarPositionforAll();
    for (int i = 0; i < gpsDataAll.length; i++) {
      print(
          "DeviceId is ${devicelist[i].deviceId} for ${devicelist[i].truckno}");

      getGPSData(gpsDataAll[i], i, devicelist[i].truckno, devicelist[i]);
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
    print("--TRUCK SCREEN DONE--");
    setState(() {
      loading = false;
    });
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

  void filterSearchResults(String query) {
    print("LIST IS $devicelist");
    print("$query");

    if (query.isNotEmpty) {
      //print("DUMMYSEARCH${dummySearchList}");
      var dummyListData = [];
      var dummyGpsData = [];
      var dummyStatusData = [];
      for (var i = 0; i < dummySearchList.length; i++) {
        print("FOREACH ${dummySearchList[i].truckno}");
        if ((dummySearchList[i].truckno.replaceAll(' ', '')).contains(query) ||
            (dummySearchList[i].truckno).contains(query)) {
          print("INSIDE IF");
          print("THE SEARCHHH IS ${dummySearchList[i].truckno}");
          dummyListData.add(dummySearchList[i]);
          dummyGpsData.add(gpsDataList[i]);
          dummyStatusData.add(status[i]);
          //print("DATATYPE${dummyListData.runtimeType}");
        }
      }
      setState(() {
        items = [];
        gpsDataList = [];

        status = [];
        items.addAll(dummyListData);
        gpsDataList.addAll(dummyGpsData);
        status.addAll(dummyStatusData);
        //print("THE DUMY $dummyListData");
      });
      return;
    } else {
      print("QUERY EMPTY?");
      setState(() {
        items = [];
        gpsDataList = [];
        status = [];
        items.addAll(devicelist);
        gpsDataList.addAll(gpsDataList);
        status.addAll(status);
        //print("THE ITEMSS ${items}");
      });
    }
  }


}

//class
