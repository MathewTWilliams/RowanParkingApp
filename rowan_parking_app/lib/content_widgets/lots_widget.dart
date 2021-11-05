import 'lotinfo_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:rowan_parking_app/api/lots.dart';

void main() => runApp(const MaterialApp(home: LotsWidget()));

//figure out how to grab information from the server than convert them to strings here

class LotsWidget extends StatefulWidget {
  const LotsWidget({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => LotsWidgetState();
}

class LotsWidgetState extends State<LotsWidget> {
  late Future<List<LotEntry>> futureLotEntries;

  @override
  void initState() {
    super.initState();

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
                    CheckinBox(lotEntry: lotEntry)
                ]));
          } else if (snapshot.hasError){
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

// Holds the information for what goes into the CheckinBox for the above listView
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
                      builder: (context) => LotInfoWidget(lotEntry: lotEntry)),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}


/* Code removed from the original, it originally replaced the Scaffold() in the build Widget
return FutureBuilder<Lots>(
  future: futureLots,
  builder: (context, snapshot) {
    if (snapshot.hasData) {
    return Text(snapshot.data!.SpotsTaken.toString());
      } else {
        return Text('${snapshot.error}');
     }
   },
 );
 //As above but just under the CheckinBox(), in the Scaffold portion of the app
             Column(
              children: <Widget>[
                Center(
                  child: FutureBuilder<Lots>(
                    future: futureLots,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!.spotsTaken.toString());
                      } else {
                        return Text('${snapshot.error}');
                      }
                    },
                  ),
                )
                ],
            ),
*/
