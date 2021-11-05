import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences_settings/shared_preferences_settings.dart';

bool darkModeToggled = false;
bool value = false;

class SettingsWidget extends StatefulWidget {

  SettingsWidget({Key? key}) : super(key: key) {}

  @override
  State<StatefulWidget> createState() => SettingsWidgetState();
}

class SettingsWidgetState extends State<SettingsWidget> {
  static const darkModeKey = 'dark-mode';
  @override
  Widget build(BuildContext context) => SettingsList(
    sections: [
      SettingsSection(
        title: 'Section',
        tiles: [
          SettingsTile(
            title: 'Language',
            subtitle: 'English',
            leading: Icon(Icons.language),
            onPressed: (BuildContext context) {},
          ),
          //commented out because i don't want to access fingerprints
          /*SettingsTile.switchTile(
            title: 'Use fingerprint',
            leading: Icon(Icons.fingerprint),
            switchValue: value,
            onToggle: (bool value) {},
          ),*/
        ]
      ),
      SettingsSection(
        title: 'Misc',
        tiles: [
            SettingsTile(
              title: 'Text Size' ,
              subtitle: 'Default',
              leading: Icon(Icons.sort_by_alpha),
              onPressed: (BuildContext context) {},
            )
        ],
      )
    ]
  );
}

// admin panel icon thing: admin_panel_settings

/* new stuff
SettingsList(
    sections: [
      SettingsSection(
        title: 'Section',
        tiles: [
          SettingsTile(
            title: 'Language',
            subtitle: 'English',
            leading: Icon(Icons.language),
            onPressed: (BuildContext context) {},
          ),
          SettingsTile.switchTile(
            title: 'Use fingerprint',
            leading: Icon(Icons.fingerprint),
            switchValue: value,
            onToggle: (bool value) {},
          ),
        ],
      ),
    ],
  );
*/

/* original stuff
Scaffold(
        body: ListView(
          children: [
            SwitchSettingsTile(settingKey: darkModeKey, title: "Dark Mode (Unused)")
          ],
        ),
      );
 */
