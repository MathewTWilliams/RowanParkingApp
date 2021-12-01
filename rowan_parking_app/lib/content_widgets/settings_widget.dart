import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:settings_ui/settings_ui.dart';

//TODO: this has a different theme than the other pages, unsure why. Style likely undefined for its widgets

class SettingsWidget extends StatefulWidget {
  final Future<void> Function() logoutAction;

  SettingsWidget({Key? key, required this.logoutAction}) : super(key: key) {}


  @override
  State<StatefulWidget> createState() => SettingsWidgetState();
}

class SettingsWidgetState extends State<SettingsWidget> {

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
            ),
            SettingsTile(
              title: 'Logout of app' ,
              subtitle: 'Bye',
              leading: Icon(Icons.logout),
              onPressed: (BuildContext context) {
                Future.delayed(const Duration(milliseconds: 500), (){
                  widget.logoutAction();

                  /* General design principle is that mobile apps don't exit until the user exits them. Keeping the code in case

                  if (Platform.isAndroid) {
                    print('Logged off of an Android');
                    SystemNavigator.pop();
                  } else if (Platform.isIOS) {
                    print('Logged off of an iOS');
                    exit(0);
                  }*/
                });
              }, //end of onPressed
          )
        ], //End of Misc. Tiles section
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
