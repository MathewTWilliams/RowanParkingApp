import 'package:flutter/material.dart';
import 'content_widgets/lots_widget.dart';
import 'content_widgets/settings_widget.dart';
import 'content_widgets/checkin_widget.dart';
import 'content_widgets/bug_report_widget.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => AppState();
}

class AppState extends State<App> {
  final ValueNotifier<ThemeData> appTheme =
      ValueNotifier<ThemeData>(ThemeData.light());

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeData>(
      valueListenable: appTheme,
      builder: (context, themeData, child) {
        return MaterialApp(theme: themeData, home: NavWidget(appTheme));
      },
    );
  }

  void toggleDarkMode(bool on) {
    appTheme.value = on ? ThemeData.dark() : ThemeData.light();
  }
}

class NavWidget extends StatefulWidget {
  final ValueNotifier<ThemeData> appTheme;
  NavWidget(this.appTheme, {Key? key}) : super(key: key);

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
                  body = SettingsWidget(appTheme: widget.appTheme);
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
