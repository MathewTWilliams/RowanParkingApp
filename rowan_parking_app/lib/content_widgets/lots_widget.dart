import 'dart:convert';

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
  late Future<Lots>? futureLots;

  @override
  void initState() {
    super.initState();

    futureLots = Lots.getLots();
  }

  @override
  Widget build(BuildContext context) {
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
  }
}

class Lots {
  final int? userId;
  final int? id;
  final String? title;

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
