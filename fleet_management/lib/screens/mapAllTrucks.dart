import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:flutter_config/flutter_config.dart';

import '../constants/spaces.dart';
import '../functions/mapUtils/getLoactionUsingImei.dart';
import '../providerClass/providerData.dart';
import 'allMapWidget.dart';

class MapAllTrucks extends StatefulWidget {
  List gpsDataList;
  List deviceList;
  List runningDataList;
  List runningGpsDataList;
  List stoppedList;
  List stoppedGpsList;
  List status;

  MapAllTrucks({
    required this.gpsDataList,
    required this.deviceList,
    required this.runningDataList,
    required this.runningGpsDataList,
    required this.stoppedGpsList,
    required this.stoppedList,
    required this.status,
  });

  @override
  _MapAllTrucksState createState() => _MapAllTrucksState();
}

class _MapAllTrucksState extends State<MapAllTrucks>
    with WidgetsBindingObserver {
  GoogleMapController? _googleMapController;
  LatLng lastlatLngMarker = LatLng(28.5673, 77.3211);
  List<Placemark>? placemarks;
  Iterable markers = [];
  ScreenshotController screenshotController = ScreenshotController();
  BitmapDescriptor? pinLocationIcon;
  BitmapDescriptor? pinLocationIconTruck;
  late CameraPosition camPosition =
  CameraPosition(zoom: 4, target: lastlatLngMarker);
  var logger = Logger();
  Marker? markernew;
  List<Marker> customMarkers = [];
  Timer? timer;
  Completer<GoogleMapController> _controller = Completer();
  List? newGPSData;
  List? reversedList;
  List? oldGPSData;
  MapUtil mapUtil = MapUtil();
  List<LatLng> latlng = [];
  String googleAPiKey = dotenv.env["mapKey"].toString();
  bool popUp = false;
  Uint8List? markerIcon;
  var markerslist;
  CustomInfoWindowController _customInfoWindowController =
  CustomInfoWindowController();
  bool isAnimation = false;
  double mapHeight = 600;
  var direction;
  var maptype = MapType.normal;
  double zoom = 8;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  void onMapCreated(GoogleMapController controller) {
    controller.setMapStyle("[]");

    _controller.complete(controller);

    _customInfoWindowController.googleMapController = controller;
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.inactive:
        print('appLifeCycleState inactive');
        break;
      case AppLifecycleState.resumed:
        final GoogleMapController controller = await _controller.future;
        onMapCreated(controller);
        print('appLifeCycleState resumed');
        break;
      case AppLifecycleState.paused:
        print('appLifeCycleState paused');
        break;
      case AppLifecycleState.detached:
        print('appLifeCycleState detached');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery
        .of(context)
        .size
        .height;
    double threshold = 100;
    ProviderData providerData = Provider.of<ProviderData>(context);
    PageController pageController =
    PageController(initialPage: providerData.upperNavigatorIndex);
    return Scaffold(
        body: SingleChildScrollView(
            child: Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
              width: MediaQuery.of(context).size.width,
              child: AllMapWidget(
                  gpsDataList: widget.gpsDataList,
                  truckDataList: widget.deviceList,
                  status: widget.status,
              ),

            )
        ));
  }
}
