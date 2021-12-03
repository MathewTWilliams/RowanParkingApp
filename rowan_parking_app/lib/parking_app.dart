import 'package:flutter/material.dart';
import 'package:rowan_parking_app/content_widgets/lotinfo_widget.dart';
import 'api/requests.dart';
import 'content_widgets/lots_widget.dart';
import 'content_widgets/settings_widget.dart';
import 'content_widgets/checkin_widget.dart';
import 'content_widgets/bug_report_widget.dart';

class ParkingApp extends StatefulWidget {
  LoginReceipt userInfo;
  final Future<void> Function() logoutAction;

  ParkingApp({Key? key, required this.userInfo, required this.logoutAction})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => ParkingAppState();
}

class ParkingAppState extends State<ParkingApp> {
  bool isBusy = false;
  late CheckinInfo lastCheckin;
  bool currentlyCheckedIn = false;
  bool hasLastCheckin = false;
  late Lot lotCheckedInto;
  late CheckinInfo receivedCheckinInfo;

  Widget body = LotsWidget();
  Text contentTitle = const Text("Parking Lots");

  @override
  void initState() {
    isBusy = true;
    loadLastCheckinInfo();
    super.initState();
  }

  Future<void> loadLastCheckinInfo() async {
    receivedCheckinInfo =
        await Requests.getCheckinInfo(widget.userInfo.lastCheckIn);

    hasLastCheckin = widget.userInfo.lastCheckIn != -1;

    /* When a user hasn't checked out, the server returns a checkout DateTime of the form 0001-01-01 00:00:00.000Z.
    Checking if checkout is before checkin should be robust enough to determine this, for now. */
    if (hasLastCheckin) {
      currentlyCheckedIn = receivedCheckinInfo.checkOutTime
          .isBefore(receivedCheckinInfo.checkInTime);

      lastCheckin = receivedCheckinInfo;

      /* If checked in get the lot. Thus lotCheckedInto may never receive a value. Nick-specific TODO: This is bad practice. Fix it.*/
      if (currentlyCheckedIn)
        lotCheckedInto = await Requests.getLot(
            widget.userInfo.venueId, receivedCheckinInfo.lotId);
    }

    setState(() {
      isBusy = false;

      if (hasLastCheckin) lastCheckin = receivedCheckinInfo;

      if (currentlyCheckedIn)
        Navigator.of(context).push(
          MaterialPageRoute(
              builder: (context) => CheckoutWidget(
                    lot: lotCheckedInto,
                  )),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return isBusy
        ? Scaffold(
            //Loading screen while gathering information
            body: Center(child: const CircularProgressIndicator()))
        : Scaffold(
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
                        body = SettingsWidget(
                          logoutAction: widget.logoutAction,
                        );
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
