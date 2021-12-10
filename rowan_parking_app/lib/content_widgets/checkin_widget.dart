import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:rowan_parking_app/api/requests.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'lotinfo_widget.dart';

late List<Lot> lots;

late SharedPreferences prefs;

class CheckinWidget extends StatefulWidget {
  CheckinWidget({Key? key}) : super(key: key) {}

  @override
  State<StatefulWidget> createState() => CheckinWidgetState();
}

class CheckinWidgetState extends State<CheckinWidget> {
  bool loading = true;

  @override
  void initState() {
    super.initState();

    loading = true;

    initialize();
  }

  void initialize() async {
    prefs = await SharedPreferences.getInstance();

    List<Lot> receivedLots = await Requests.getLotList(1); // TODO get venueID instead of placeholder

    String shownLotType = prefs.getString("shown_lot_type_str") ?? "All";

    lots = [];
    for (Lot lot in receivedLots) {
      if(lot.lotInfo.lotDescription.toLowerCase().contains(shownLotType.toLowerCase()) || shownLotType == "All")
        lots.add(lot);
    }

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
            alignment: Alignment.center,
            child: loading
                ? const CircularProgressIndicator()
                : ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(
                        10.0, 20.0, 10.0, 20.0),
                    children: <Widget>[
                      for (Lot lotEntry in lots)
                        CheckinBox(
                          lot: lotEntry,
                        )
                    ],
                  )
          )
        )
    );
  }
}

class CheckinBox extends StatelessWidget {
  CheckinBox({required this.lot});
  Lot lot;

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
                    padding: const EdgeInsets.all(5),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(lot.lotInfo.lotName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              '${lot.lotInfo.numSpaces - lot.spotsTaken}/${lot.lotInfo.numSpaces} Spaces'),
                          Text(lot.lotInfo.lotDescription),
                        ]))),
            Expanded(
              child: ElevatedButton(
                child: Text('Check Into ${lot.lotInfo.lotName}', textAlign: TextAlign.center,),
                onPressed: () {
                  Requests.checkin(lot.lotInfo.venueId, lot.lotInfo.id);

                  //Navigates to the Checkout screen
                  Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (context) => CheckoutWidget(
                              lot: lot,
                            )),
                  );
                },
              )
            )
          ],
        ),
      ),
    );
  }
}
