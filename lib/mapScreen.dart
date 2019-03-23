import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';
import 'reduxApp.dart';
import 'package:flutter_redux/flutter_redux.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  bool mapToogle = false;
  bool sitiosToogle = false;
  bool resetToggle = false;
  var currentLocation;
  var sitios = [];
  var sitioActual;
  var currentBearing;
  var map = <String, String>{};
  double _ber;
  GoogleMapController mapController;
  void initState() {
    setState(() {
      mapToogle = true;
      poblarSitios();
      _ber = 0;
    });
  }

  poblarSitios() {
    sitios = [];
    // Conexion a Firestore
    Firestore.instance.collection('markers').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          sitiosToogle = true;
        });
        for (var i = 0; i < docs.documents.length; i++) {
          sitios.add(docs.documents[i].data);
          initMarker(docs.documents[i].data);
        }
      }
    });
  }

  initMarker(sitio) {
    mapController.clearMarkers().then((value) {
      mapController
          .addMarker(MarkerOptions(
              position: LatLng(
                  sitio['position'].latitude, sitio['position'].longitude),
              draggable: false,
              infoWindowText: InfoWindowText(sitio['name'], 'Universidad')))
          .then((marker) {
        map[marker.id] = sitio['name']; // this will return when tap on marker
        return marker;
      });
    });
  }

  void _onMarkerTapped(Marker marker) {
    double lat = double.parse(marker.options.position.latitude.toString());
    double long = double.parse(marker.options.position.longitude.toString());
    Random rnd = new Random();
    double max = 90;

    double _bearing = max * rnd.nextDouble();
    setState(() {
      _ber = _bearing;
    });

    mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      bearing: _ber,
      target: LatLng(lat, long),
      zoom: 15,
      tilt: 50,
    )));
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return Container(
            height: 300,
            width: double.infinity,
            color: Colors.blueGrey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Center(
                    child: Text(
                  marker.options.infoWindowText.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                )),
              ],
            ),
          );
        });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
    mapController.onMarkerTapped.add(_onMarkerTapped);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                    height: MediaQuery.of(context).size.height - 64,
                    width: double.infinity,
                    child: mapToogle
                        ? GoogleMap(
                            initialCameraPosition: CameraPosition(
                                target: LatLng(-0.2069681, -78.4912876), //Quito
                                zoom: 13),
                            onMapCreated: onMapCreated,
                            myLocationEnabled: true,
                            mapType: MapType.normal,
                            compassEnabled: true,
                            zoomGesturesEnabled: true,
                            trackCameraPosition: true,
                          )
                        : Center(
                            child: Text(
                            'Revisa datos, gps, wifi..',
                            style: TextStyle(fontSize: 20.0),
                          ))),

/* *********************************************** REDUX */
                Container(
                    child: StoreConnector<int, VoidCallback>(
                  converter: (store) {
                    return () => store.dispatch(Actions.Increment);
                  },
                  builder: (context, callback) {
                    return MaterialButton(
                      onPressed: callback,
                      child: Text("Seguir aumentando"),
                      color: Colors.blueAccent,
                    );
                  },
                )),
                StoreConnector<int, String>(
                  converter: (store) => store.state.toString(),
                  builder: (context, msj) {
                    return Text("Valor en el store: " + msj);
                  },
                )
              ],
            ),
          ],
        )
      ],
    ));
  }
}
