import 'package:flutter/material.dart';
import 'content_widgets/lots_widget.dart';
import 'content_widgets/settings_widget.dart';
import 'content_widgets/checkin_widget.dart';
import 'content_widgets/bug_report_widget.dart';

void main() => runApp(MaterialApp(
      home: const PrimaryContent(),
      theme: ThemeData.dark(),
    ));

class PrimaryContent extends StatefulWidget {
  const PrimaryContent({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PrimaryContentState();
}

class PrimaryContentState extends State<PrimaryContent> {
  Widget body = const LotsWidget();
  Text contentTitle = const Text("Parking Lots");

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: contentTitle,
      ),
      body: body,
      drawer: Drawer(
        elevation: 2,
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.local_parking_outlined),
              title: const Text("Parking Lots"),
              onTap: () {
                setState(() {
                  contentTitle = const Text("Parking Lots");
                  body = const LotsWidget();
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Settings"),
              onTap: () {
                setState(() {
                  contentTitle = const Text("Settings");
                  body =
                      SettingsWidget(settingsChangedCallback: settingsChanged);
                  Navigator.pop(context);
                });
              },
            )
          ],
        ),
      ),
    );
  }

  void settingsChanged() {
    print("settings have changed!");
  }
}
