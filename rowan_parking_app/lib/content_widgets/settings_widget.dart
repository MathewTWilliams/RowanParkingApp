// @dart=2.10

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

bool darkModeToggled = false;

class SettingsWidget extends StatefulWidget {
  ValueNotifier<ThemeData> appTheme;

  SettingsWidget({Key key, this.appTheme}) : super(key: key) {}

  @override
  State<StatefulWidget> createState() => SettingsWidgetState();
}

class SettingsWidgetState extends State<SettingsWidget> {
  static const darkModeKey = 'dark-mode';
  @override
  Widget build(BuildContext context) => Scaffold(
        body: ListView(
          children: [
            SwitchSettingsTile(settingKey: darkModeKey, title: "Dark Mode")
          ],
        ),
      );
}
