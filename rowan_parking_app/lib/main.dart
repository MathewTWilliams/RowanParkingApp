import 'package:flutter/material.dart';
import 'content_widgets/lots_widget.dart';
import 'content_widgets/settings_widget.dart';
import 'content_widgets/checkin_widget.dart';
import 'content_widgets/bug_report_widget.dart';

void main() => runApp(const MainApp());

class MainApp extends StatelessWidget {
  const MainApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: PrimaryContent(),
    );
  }

  void changePage() {}
}

class PrimaryContent extends StatefulWidget {
  const PrimaryContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PrimaryContentState();
}

class PrimaryContentState extends State<PrimaryContent> {
  Widget body = const LotsWidget();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.local_parking,
              color: Colors.grey,
            ),
            label: "Lots",
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.settings,
              color: Colors.grey,
            ),
            label: "Settings",
          )
        ],
        onTap: (newIndex) {
          switch (newIndex) {
            case 0:
              setState(() {
                body = const LotsWidget();
              });
              break;
            case 1:
              setState(() {
                body = const SettingsWidget();
              });
              break;
          }
        },
        backgroundColor: Colors.red,
        selectedItemColor: Colors.grey,
      ),
    );
  }
}
