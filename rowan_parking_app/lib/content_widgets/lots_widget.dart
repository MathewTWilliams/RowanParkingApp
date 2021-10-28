import 'dart:convert';

import 'checkin_widget.dart';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:http/http.dart' as http;

const String serverURL = "18.118.241.218";

void main() => runApp(const MaterialApp(home: LotsWidget()));

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
      shrinkWrap: true,
      padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
      children: <Widget>[
        CheckinBox(
            lotName: 'Lot O', rating: 'x/201 Spaces', permission: 'Commuter'),
        CheckinBox(
            lotName: 'Lot P', rating: 'x/524 Spaces', permission: 'Commuter'),
        CheckinBox(
            lotName: 'Lot W', rating: 'X/Y Spaces', permission: 'Residential'),
        CheckinBox(
            lotName: 'Lot A-1', rating: 'X/Y Spaces', permission: 'Employee'),
      ],
    ));
  }
}

class Lots {
  final int userId;
  final int id;
  final String title;

  Lots({
    required this.userId,
    required this.id,
    required this.title,
  });

  factory Lots.fromJson(Map<String, dynamic> json) {
    return Lots(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
    );
  }

  static Future<Lots> getLots() async {
    final response = await http
        .get(Uri.parse('https://jsonplaceholder.typicode.com/albums/1'));

    if (response.statusCode == 200) {
      return Lots.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Received invalid server response trying to GET Lots');
    }
  }
}

// Holds the information for what goes into the CheckinBox for the above listView
class CheckinBox extends StatelessWidget {
  CheckinBox(
      {required this.lotName, required this.rating, required this.permission});
  final String lotName;
  final String rating;
  final String permission;

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
                          Text(lotName,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold)),
                          Text(rating),
                          Text(permission),
                        ]))),
            ElevatedButton(
              child: const Text('Lot Info'),
              onPressed: () {
                //Navigates to the Checkout screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CheckinWidget()),
                );
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
return Text(snapshot.data!.userId.toString());
} else {
return Text('${snapshot.error}');
}
},
);
 */
