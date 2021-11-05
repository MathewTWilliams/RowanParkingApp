import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:rowan_parking_app/api/lots.dart';

import 'lotinfo_widget.dart';

class CheckinWidget extends StatelessWidget {
  late Future<List<LotEntry>> futureLotEntries;

  CheckinWidget({Key? key}) : super(key: key) {
    futureLotEntries = Lots.getLotEntryList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LotEntry>>(
        future: futureLotEntries,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
                body: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
              children: <Widget>[
                for (LotEntry lotEntry in snapshot.data!)
                  CheckinBox(
                    lotEntry: lotEntry,
                  )
              ],
            ));
          } else if(snapshot.hasError){
            return Text('${snapshot.error}');
          } 
            return Scaffold( //Loading screen while gathering information
              body: Center(
                  child: SizedBox(width: 200, height: 200, child: CircularProgressIndicator())
              )
          );
        });
  }
}

class CheckinBox extends StatelessWidget {
  CheckinBox({required this.lotEntry});
  LotEntry lotEntry;

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
                          Text(lotEntry.lotInfo.lotName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                              '${lotEntry.lotInfo.numSpaces - lotEntry.spotsTaken}/${lotEntry.lotInfo.numSpaces} Spaces'),
                          Text(lotEntry.lotInfo.lotDescription),
                        ]))),
            ElevatedButton(
              child: Text('Check Into ${lotEntry.lotInfo.lotName}'),
              onPressed: () {
                //Navigates to the Checkout screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => CheckoutWidget(
                            nameLot: lotEntry.lotInfo.lotName,
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
