import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
  GoogleMapController mapController;
  void initState() {
    setState(() {
      mapToogle = true;
      poblarSitios();
    });
  }

  poblarSitios() {
    sitios = [];
    Firestore.instance.collection('markers').getDocuments().then((docs) {
      if (docs.documents.isNotEmpty) {
        setState(() {
          sitiosToogle = true;
        });
        for (var i = 0; i < docs.documents.length; i++) {
          sitios.add(docs.documents[i].data);
          iniMarkers(docs.documents[i].data);
        }
      }
    });
  }

  iniMarkers(sitio) {
    mapController.clearMarkers().then((value) {
      mapController.addMarker(MarkerOptions(
          position:
              LatLng(sitio['location'].latitude, sitio['location'].longitude),
          draggable: false,
          infoWindowText: InfoWindowText(sitio['name'], 'Universidad')));
    });
  }

  Widget siteCard(sitio) {
    return Padding(
      padding: EdgeInsets.all(2.0),
      child: InkWell(
        onTap: () {
          setState(() {
            sitioActual = sitio;
            currentBearing = 90.0;
          });
          zoomInMarker(sitio);
        },
        child: Material(
          elevation: 4.0,
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            height: 100,
            width: 152,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
              color: Colors.white,
            ),
            child: Center(
              child: Text(sitio['name']),
            ),
          ),
        ),
      ),
    );
  }

  zoomInMarker(sitio) {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(sitioActual['location'].latitude,
                sitioActual['location'].longitude),
            zoom: 5.0)))
        .then((val) {
      setState(() {
        resetToggle = false;
      });
    });
  }

  girarDerecha() {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(sitioActual['location'].latitude,
                sitioActual['location'].longitude),
            bearing: currentBearing == 360.0
                ? currentBearing
                : currentBearing + 90.0,
            zoom: 17.0,
            tilt: 45.0)))
        .then((val) {
      setState(() {
        if (currentBearing == 360.0) {
        } else {
          currentBearing = currentBearing + 90.0;
        }
      });
    });
  }

// Codigo de animacion
  giroIzquierda() {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
            target: LatLng(sitioActual['location'].latitude,
                sitioActual['location'].longitude),
            bearing:
                currentBearing == 0.0 ? currentBearing : currentBearing - 90.0,
            zoom: 17.0,
            tilt: 45.0)))
        .then((val) {
      setState(() {
        if (currentBearing == 0.0) {
        } else {
          currentBearing = currentBearing - 90.0;
        }
      });
    });
  }

  markerInicial() {
    mapController
        .animateCamera(CameraUpdate.newCameraPosition(
            CameraPosition(target: LatLng(51.0533076, 5.9260656), zoom: 5.0)))
        .then((val) {
      //Alemania, Berlin
      setState(() {
        resetToggle = false;
      });
    });
  }

  void onMapCreated(controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: double.infinity,
            child: mapToogle
                ? GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(48.8583998, 2.29322),
                      zoom: 15,
                    ),
                    onMapCreated: onMapCreated,
                    myLocationEnabled: true,
                    mapType: MapType.terrain,
                    compassEnabled: true,
                    trackCameraPosition: true,
                  )
                : Center(
                    child: Text('Revise su dispositivo'),
                  ),
          ),
          
        ],
      ),
    );
  }
}
