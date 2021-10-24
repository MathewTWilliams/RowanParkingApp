import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

bool darkModeToggled = false;

class SettingsWidget extends StatefulWidget {
  ValueNotifier<ThemeData>? appTheme;

  SettingsWidget({Key? key, required this.appTheme}) : super(key: key) {}

  @override
  State<StatefulWidget> createState() => SettingsWidgetState();
}

class SettingsWidgetState extends State<SettingsWidget> {

  SettingsWidgetState();

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Center(
          child: ListView(
            children: [
              Row(
                children: [
                  const Text("Dark Mode"),
                  Switch(
                    value: darkModeToggled,
                    onChanged: (bool on) {
                      setState(() {
                        darkModeToggled = on;
                        print(on);
                        widget.appTheme!.value =
                            on ? ThemeData.dark() : ThemeData.light();
                      });
                    },
                  )
                ],
              )
            ],
          ),
        ),
      );
}
