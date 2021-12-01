import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:rowan_parking_app/api/requests.dart';

class LotInfoWidget extends StatelessWidget {
  Lot lot;

  LotInfoWidget({required this.lot});

  @override
  Widget build(BuildContext context) {
    try{
      return Scaffold(
          appBar: AppBar(title: Text("${lot.lotInfo.lotName} Information")),
            body: ListView(
            shrinkWrap: true,
            padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
            children: <Widget>[
              LotInfoBox(
                  rating: 'Good Availability',
                  spaces:
                      '${lot.lotInfo.numSpaces - lot.spotsTaken}/${lot.lotInfo.numSpaces} Spaces',
                  permission: '${lot.lotInfo.specificRules}'),
              ElevatedButton(
                child: const Text('Check-in'),
                onPressed: () {
                  Requests.checkin(lot.lotInfo.venueId, lot.lotInfo.id);
                  
                  //Navigates to the Checkout screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => CheckoutWidget(
                              lot: lot,
                            )),
                  );
                },
              ),
            ],
          ));
    }catch(e){
      return Scaffold(
          appBar: AppBar(
              title: Text("${lot.lotInfo.lotName} Information Error")),
          body: Center(
              child: SizedBox(width: 200, height: 200, child: CircularProgressIndicator())
        )

      );
    }
  }
}

class LotInfoBox extends StatelessWidget {
  LotInfoBox(
      {required this.rating, required this.permission, required this.spaces});
  final String rating;
  final String permission;
  final String spaces;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      height: 120,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(rating, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(spaces),
            Text(permission),
          ],
        ),
      ),
    );
  }
}

/*
**********************************
  HERE STARTS THEW CHECKOUT PAGE
**********************************
*/
class CheckoutWidget extends StatelessWidget {
  CheckoutWidget({Key? key, required this.lot}) : super(key: key);
  Lot lot;

  @override
  Widget build(BuildContext context) {
    try{
    return Scaffold(
        appBar: AppBar(title: const Text("Ready to Check-Out?"), automaticallyImplyLeading: false), // automaticallyImplyLeading: false disables the back arrow
        body: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 20.0),
          children: <Widget>[
            CheckoutBox(
                rating: 'Test Rating',
                lotName: 'You are checked into ' + lot.lotInfo.lotName + '.'),
            ElevatedButton(
              child: Text('Check-out of ' + lot.lotInfo.lotName + '.'),
              onPressed: () {
                Requests.checkout(lot.lotInfo.venueId, lot.lotInfo.id);
                Navigator.of(context).pop();
              },
            ),
          ],
        ));
    }catch(e){
      return Scaffold(
          appBar: AppBar(
              title: Text("Information Error")),
          body: Center(
              child: SizedBox(width: 200, height: 200, child: CircularProgressIndicator())
        )

      );
    }
  }
}

//This holds the information for what goes into the checkout box listed above
class CheckoutBox extends StatelessWidget {
  CheckoutBox({required this.rating, required this.lotName});
  final String rating;
  final String lotName;

  @override
  Widget build(BuildContext context) {
    // Encapsulating WillPopScope prevents the system popping the context outside of the checkout button
    // TODO this also prevents the system back arrow being used at all while in the checkout widget
    return WillPopScope(onWillPop: () async => false,
    child: Container(
        padding: const EdgeInsets.all(2),
        height: 120,
        child: Card(
            child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(rating, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text(lotName),
          ],
        ))));
  }
}
