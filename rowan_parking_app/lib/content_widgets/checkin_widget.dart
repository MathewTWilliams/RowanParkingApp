import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:rowan_parking_app/api/requests.dart';

import 'lotinfo_widget.dart';

class CheckinWidget extends StatelessWidget {
  late Future<List<Lot>> futureLotEntries;

  CheckinWidget({Key? key}) : super(key: key) {
    futureLotEntries =
        Requests.getLotList(1); // TODO get venueID instead of placeholder
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Lot>>(
        future: futureLotEntries,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }
          return 
            Scaffold(
              body: Center(
                child: Container(
                  alignment: Alignment.center,
                  child: !snapshot.hasData ? const CircularProgressIndicator() :
                  ListView(
                    shrinkWrap: true,
                    padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
                    children: <Widget>[
                      for (Lot lotEntry in snapshot.data!)
                        CheckinBox(
                          lot: lotEntry,
                        )
                    ],
                  )
                )
            )
          );
        });
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
            ElevatedButton(
              child: Text('Check Into ${lot.lotInfo.lotName}'),
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
          ],
        ),
      ),
    );
  }
}
