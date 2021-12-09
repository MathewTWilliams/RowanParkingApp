import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lotinfo_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:rowan_parking_app/api/requests.dart';

void main() => runApp(const MaterialApp(home: LotsWidget()));

//figure out how to grab information from the server than convert them to strings here

late String shownLotType;
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

    shownLotType = prefs.getString("shown_lot_type_str") ?? "All";

    lotEntries = [];
    for (Lot lot in receivedLots) {
      if(lot.lotInfo.lotDescription == shownLotType + " Parking" || shownLotType == "All")
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
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 15.6,
          ),
        ),
    );
        
  }
}

// Holds the information for what goes into the CheckinBox for the above listView
class CheckinBox extends StatelessWidget {
  CheckinBox({required this.lotEntry});
  Lot lotEntry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 120,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: Container(
                    padding: EdgeInsets.all(5),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(lotEntry.lotInfo.lotName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(lotEntry.lotInfo.lotDescription),
                        ]))),
            ElevatedButton(
              //Navigates to the Checkout screen
              child: const Text('Lot Info'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LotInfoWidget(lot: lotEntry)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}