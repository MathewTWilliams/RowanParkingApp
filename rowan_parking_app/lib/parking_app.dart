import 'package:flutter/material.dart';
import 'content_widgets/lots_widget.dart';
import 'content_widgets/settings_widget.dart';
import 'content_widgets/checkin_widget.dart';
import 'content_widgets/bug_report_widget.dart';



/* DEPRECATED
class ParkingApp extends StatefulWidget {
  const ParkingApp({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => ParkingAppState();
}

class ParkingAppState extends State<ParkingApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: NavWidget());
  }
}
*/

class NavWidget extends StatefulWidget {
  NavWidget({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => NavWidgetState();
}

class NavWidgetState extends State<NavWidget> {
  Widget body = LotsWidget();
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
                  body = LotsWidget();
                  Navigator.of(context).pop();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.check_circle_outline),
              title: const Text("Check In"),
              onTap: () {
                setState(() {
                  contentTitle = const Text("Check In");
                  body = CheckinWidget();
                  Navigator.of(context).pop();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.bug_report_outlined),
              title: const Text("Report a Problem"),
              onTap: () {
                setState(() {
                  contentTitle = const Text("Report a Problem");
                  body = BugReportWidget();
                  Navigator.of(context).pop();
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text("Settings"),
              onTap: () {
                setState(() {
                  contentTitle = const Text("Settings");
                  body = SettingsWidget();
                  Navigator.of(context).pop();
                });
              },
            )
          ],
        ),
      ),
    );
  }
}
