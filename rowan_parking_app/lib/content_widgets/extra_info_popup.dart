import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:rowan_parking_app/api/requests.dart';

import 'lotinfo_widget.dart';

List<String> lotTypes = [
  "None",
  "Commuter",
  "Resident",
  "Garage",
  "Employee",
];

class ExtraInfoPopup extends StatelessWidget {
  Lot lot;

  ExtraInfoPopup(this.lot) {}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Theme.of(context).canvasColor,
      title: Text(lot.lotInfo.lotName, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      insetPadding: EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height * 0.25, horizontal: 20),
      content: Column (
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Availability: ${lot.lotInfo.numSpaces - lot.spotsTaken}/${lot.lotInfo.numSpaces} spaces", style: TextStyle(color: Colors.white), textAlign: TextAlign.left),
          Text("Type: ${lotTypes[lot.lotInfo.lotType]}", style: TextStyle(color: Colors.white), textAlign: TextAlign.left),
          //Text("${lot.lotInfo.lotType}", style: TextStyle(color: Colors.white), textAlign: TextAlign.left),
          Text("Special Rules: ${lot.lotInfo.specificRules.length > 0 ? lot.lotInfo.specificRules : "None"}", style: TextStyle(color: Colors.white), textAlign: TextAlign.left)
        ],
      ),
      actionsAlignment: MainAxisAlignment.spaceAround,
      actions: [
        ElevatedButton(
          child: Text("Close"), 
          onPressed: () {
            Navigator.of(context).pop();
          }
        ),
        ElevatedButton(
          child: Text("Check In"), 
          onPressed: () {
            Requests.checkin(lot.lotInfo.venueId, lot.lotInfo.id);

            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CheckoutWidget(
                  lot: lot,
                )
              ),
            );
          }
        ),
        
      ],
    );
  }

}