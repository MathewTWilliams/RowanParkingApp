import 'dart:convert';

import 'lotinfo_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

const String serverURL = "3.137.195.9";

void main() => runApp(const MaterialApp(home: LotsWidget()));

//figure out how to grab information from the server than convert them to strings here

class LotsWidget extends StatefulWidget {
  const LotsWidget({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => LotsWidgetState();
}

class LotsWidgetState extends State<LotsWidget> {
  late Future<Lots> futureLots;

  @override
  void initState() {
    super.initState();

    futureLots = Lots.getLots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          shrinkWrap: true, padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          children: <Widget> [
            CheckinBox(
                lotName: 'Lot O',
                permission: 'Commuter'),
            CheckinBox(
                lotName: 'Lot O-1',
                permission: 'Employee Only until 4pm'),
            CheckinBox(
                lotName: 'Lot P',
                permission: 'Commuter'),
            CheckinBox(
                lotName: 'Lot D',
                permission: 'Commuter'),
            CheckinBox(
              lotName: 'Lot A',
              permission: 'Commuter'),
          ],
        )
    );
  }
}

class Lots {
  int venueId;
  int id;
  String title;
  int spotsTaken;
  int numSpaces;

  static Future<Lots> getLots() async {
    final response = await http.get(Uri.parse('http://3.137.195.9/api/venues/1/lots/1'));

    if (response.statusCode == 200) {
      return Lots.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Received invalid server response trying to GET Lots');
    }
  }

  Lots({
    required this.venueId,
    required this.id,
    required this.title,
    required this.numSpaces,
    required this.spotsTaken,
  });

  factory Lots.fromJson(Map<String, dynamic> json) {
    return Lots(
      venueId: json['VenueId'],
      id: json['Id'],
      title: json['LotName'],
      numSpaces: json['NumSpaces'],
      spotsTaken: json['SpotsTaken'],
    );
  }
}

// Holds the information for what goes into the CheckinBox for the above listView
class CheckinBox extends StatelessWidget {
  CheckinBox({required this.lotName, required this.permission});
  String lotName;
  String permission;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8), height: 120,
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
                          Text(lotName, style: const TextStyle(fontWeight:
                          FontWeight.bold)), Text(permission),
                        ]
                    )
                )
            ),
            ElevatedButton(child: const Text('Lot Info'),
              onPressed: (){ //Navigates to the Checkout screen
              if(lotName == 'Lot O'){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> LotOWidget()),
                );
              }
              if(lotName == 'Lot O-1'){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> LotO1Widget()),
                );
              }
              if(lotName == 'Lot P'){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> LotPWidget()),
                );
              }
              if(lotName == 'Lot D'){
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> LotDWidget()),
                );
              }
              if(lotName == 'Lot A'){
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=> LotAWidget()),
                );
              }
              else{ print("That lof doesn't have info yet. Sorry!");}
              },
            ),
          ],
        ),
      ),
    );
  }
}

/* Code removed from the original
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
 //As above but into the CheckinBox in the Scaffold portion of the app
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
