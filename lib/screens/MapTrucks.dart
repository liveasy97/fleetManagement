import 'package:flutter/material.dart';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:google_maps/google_maps.dart';


class MapTrucks extends StatefulWidget{
  @override
  State<MapTrucks> createState() => _MapTrucksState();
}

class _MapTrucksState extends State<MapTrucks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: getMap(),
      ),
    );
  }

  Widget getMap() {
    String htmlId = "7";

    final mapOptions = MapOptions()
      ..zoom = 8
      ..center = LatLng(28.5673, 77.3211);

// ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(htmlId, (int viewId) {

      final myLatLang = LatLng(28.5673, 77.3211);

      final mapOptions = MapOptions()
        ..zoom = 10
        ..center = LatLng(28.5673, 77.3211);

      final elem = DivElement()
        ..id = htmlId
        ..style.width = "100%"
        ..style.height = "100%"
        ..style.border = 'none';

      final map = GMap(elem, mapOptions);

      Marker(MarkerOptions()
          ..position = myLatLang
          ..map = map
          ..title = 'Trucks'
          ..icon = Image(image: AssetImage('assets/icons/truckPin.png'),width: 50,height: 50,)


      );

      // final infoWindow = InfoWindow((InfoWindowOptions()..content= co));

      return elem;
    });

    return HtmlElementView(viewType: htmlId);
  }}