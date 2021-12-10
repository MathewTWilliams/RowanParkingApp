import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rowan_parking_app/content_widgets/extra_info_popup.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lotinfo_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:rowan_parking_app/api/requests.dart';

void main() => runApp(const MaterialApp(home: LotsWidget()));

//figure out how to grab information from the server than convert them to strings here

late SharedPreferences prefs;

late GoogleMapController mapController;

late List<Lot> lotEntries;

  final LatLng _center = const LatLng(39.712895, -75.119441);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

class LotsWidget extends StatefulWidget {
  const LotsWidget({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => LotsWidgetState();
}

class LotsWidgetState extends State<LotsWidget> {
  bool loading = true;

  @override
  void initState() {
    loading = true;

    initialize();

    super.initState();
  }

  Future<void> initialize() async {

    prefs = await SharedPreferences.getInstance();
    
    List<Lot> receivedLots = await Requests.getLotList(1); // TODO get venueID instead of placeholder

    String shownLotType = prefs.getString("shown_lot_type_str") ?? "All";

    lotEntries = [];
    for (Lot lot in receivedLots) {
      if(lot.lotInfo.lotDescription.toLowerCase().contains(shownLotType.toLowerCase()) || shownLotType == "All")
        lotEntries.add(lot);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading? Center(
        child: Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator()
          )
        ) :
        GoogleMap(
        onMapCreated: _onMapCreated,

        markers: {
          for(Lot lot in lotEntries)
            //Ignore the blue squigglies. They are lying to you and this sanity check is necessary.
            if(lot.lotInfo.lotLocation.coordinates != null && lot.lotInfo.lotLocation.coordinates.length >= 2)
              Marker(
                markerId: MarkerId("lot${lot.lotInfo.id}"),
                infoWindow: InfoWindow(title: lot.lotInfo.lotName),
                icon: BitmapDescriptor.defaultMarker,
                position: LatLng(lot.lotInfo.lotLocation.coordinates[1] as double, lot.lotInfo.lotLocation.coordinates[0] as double),
                consumeTapEvents: true,
                onTap: () {
                  showDialog(
                    context: context, 
                    builder: (context) => ExtraInfoPopup(lot),
                    barrierColor: Colors.white10
                  );
                },
              )
          /*_kGooglePlexMarker,_kGooglePlexMarkerr,_kGooglePlexMarker2,_kGooglePlexMarker3,_kGooglePlexMarker4,_kGooglePlexMarker5,
            _kGooglePlexMarker6,_kGooglePlexMarker7,_kGooglePlexMarker8,_kGooglePlexMarker9,_kGooglePlexMarker10,_kGooglePlexMarker11,
            _kGooglePlexMarker12,_kGooglePlexMarker13,_kGooglePlexMarker14,_kGooglePlexMarker15, _kGooglePlexMarker16, _kGooglePlexMarker17,
            _kGooglePlexMarker18, _kGooglePlexMarker19, _kGooglePlexMarker20,_kGooglePlexMarker21,_kGooglePlexMarker22,_kGooglePlexMarker23,
            _kGooglePlexMarker24,_kGooglePlexMarker25,_kGooglePlexMarker26,_kGooglePlexMarker27,_kGooglePlexMarker28,_kGooglePlexMarker29,
            _kGooglePlexMarker30,_kGooglePlexMarker31,_kGooglePlexMarker32,_kGooglePlexMarker33,_kGooglePlexMarker34,_kGooglePlexMarker35,
            _kGooglePlexMarker36, _kGooglePlexMarker37, _kGooglePlexMarker38,*/},
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.6,
          ),
        ),
    );
        
  }

  static final Marker _kGooglePlexMarker = Marker(
    markerId: MarkerId('_kGooglePlex'),
    infoWindow: InfoWindow(title: 'Lot O'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.712895, -75.119441),

  );
  static final Marker _kGooglePlexMarkerr = Marker(
    markerId: MarkerId('_kGooglePlex'),
    infoWindow: InfoWindow(title: 'Lot A-1 Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.710565, -75.123723),

  );
  static final Marker _kGooglePlexMarker2 = Marker(
      markerId: MarkerId('_kGooglePlexx'),
      infoWindow: InfoWindow(title: 'Lot A-2 Employee Parking'),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(39.710034, -75.121839),
  );
  static final Marker _kGooglePlexMarker3 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot C-1 Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.713889, -75.118585),
  );

  static final Marker _kGooglePlexMarker4 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot D-2 Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.713621, -75.122156),
  );

  static final Marker _kGooglePlexMarker5 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot E Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.707674, -75.120843),
  );

  static final Marker _kGooglePlexMarker6 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot G Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.708710, -75.121678),
  );

  static final Marker _kGooglePlexMarker7 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot H Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.708310, -75.119450),
  );

  static final Marker _kGooglePlexMarker8 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot H-1 Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.707691, -75.118813),
  );

  static final Marker _kGooglePlexMarker9 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot H-1 Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.707691, -75.118813),
  );

  static final Marker _kGooglePlexMarker10 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot M Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.711120, -75.118352),
  );

  static final Marker _kGooglePlexMarker11 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot N Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.706073, -75.123264),
  );

  static final Marker _kGooglePlexMarker12 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot O-1 Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.712506, -75.120383),
  );

  static final Marker _kGooglePlexMarker13 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot O-2 Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.712145, -75.121637),
  );

  static final Marker _kGooglePlexMarker14 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot P Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.706032, -75.119215 ),
  );

  static final Marker _kGooglePlexMarker15 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot S Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.706763, -75.118416),
  );

  static final Marker _kGooglePlexMarker16 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot Shpeen Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.703803, -75.108698),
  );

  static final Marker _kGooglePlexMarker17 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot T Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.706518, -75.116395),
  );

  static final Marker _kGooglePlexMarker18 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot U Employee Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.708022, -75.116388),
  );

  static final Marker _kGooglePlexMarker19 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot A Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.710894, -75.124116),
  );

  static final Marker _kGooglePlexMarker20 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot B-1 Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.712892, -75.117838),
  );

  static final Marker _kGooglePlexMarker21 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot C Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.714774, -75.119734),
  );

  static final Marker _kGooglePlexMarker22 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot D Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.714961, -75.121441),
  );

  static final Marker _kGooglePlexMarker23 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot D-1 Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.713947, -75.122743),
  );

  static final Marker _kGooglePlexMarker24 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot F-1 Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.711685, -75.127033),
  );

  static final Marker _kGooglePlexMarker25 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot J Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.708436, -75.114802 ),
  );

  static final Marker _kGooglePlexMarker26 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot R Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.705614, -75.120021),
  );

  static final Marker _kGooglePlexMarker27 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot Y Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.706061, -75.122080),
  );

  static final Marker _kGooglePlexMarker28 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot 411 Ellis St Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.701837, -75.120106),
  );

  static final Marker _kGooglePlexMarker29 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot B Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.712052, -75.116764),
  );

  static final Marker _kGooglePlexMarker30 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Chesnut Lot Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.709892, -75.113617),
  );

  static final Marker _kGooglePlexMarker31 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Chesnut-1 Lot" Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.709406, -75.113042),
  );

  static final Marker _kGooglePlexMarker32 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot B-1 Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.712892, -75.117838),
  );

  static final Marker _kGooglePlexMarker33 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Edgewood Lot Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.711223, -75.115355),
  );

  static final Marker _kGooglePlexMarker34 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Triad Lot-F Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.711303, -75.125021),
  );

  static final Marker _kGooglePlexMarker35 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Lot W Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.710262, -75.117577),
  );

  static final Marker _kGooglePlexMarker36 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Townhouse Garage Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.707757, -75.122926),
  );

  static final Marker _kGooglePlexMarker37 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Rowan Boulevard Garage Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.706117, -75.113432),
  );

  static final Marker _kGooglePlexMarker38 = Marker(
    markerId: MarkerId('_kGooglePlexx'),
    infoWindow: InfoWindow(title: 'Mick Drive Garage Student Parking'),
    icon: BitmapDescriptor.defaultMarker,
    position: LatLng(39.703782, -75.114822),
  );
}

