import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

void main() => runApp(const MaterialApp(home: CheckinWidget()));

class CheckinWidget extends StatelessWidget {
  const CheckinWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        shrinkWrap: true, padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
        children: <Widget> [
          CheckinBox(
              rating: 'Good Availability',
              lotName: 'Lot O',
              permission: 'Commuter parking'),
          CheckinBox(
              rating: 'Alright Availability',
              lotName: 'Lot P',
              permission: 'Commuter parking'),
          CheckinBox(
              rating: 'Poor Availability',
              lotName: 'Lot W',
              permission: 'Residential parking'),
          CheckinBox(
              rating: 'No Availability',
              lotName: 'Lot A-1',
              permission: 'Employee parking'),
        ],
      )
    );
  }
}

// Holds the information for what goes into the CheckinBox for the above listView
class CheckinBox extends StatelessWidget {
  CheckinBox({required this.rating, required this.lotName, required this.permission});
  final String rating;
  final String lotName;
  final String permission;

  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2), height: 120, child: Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
          Text(this.rating, style: TextStyle(fontWeight:
            FontWeight.bold)), Text(this.lotName), Text(this.permission)
        ],
      )
      )
    );
  }
}

