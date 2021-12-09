import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'option_selector.dart';

//TODO: manual theme inheritance is a little bit strange, not sure why it wouldn't inherit automatically
//TODO: remove duplication by extracting langauge, lot type settings into some kind of option setting class

late SharedPreferences prefs;

String languageKey = "language";
String shownLotTypeIntKey = "shown_lot_type";
String shownLotTypeStringKey = "shown_lot_type_str";

// Language option data
int selectedLanguage = 0;
final List<String> languageOptions = [
  "English",
  "Español",
  "Français",
  "Deutsch",
  "日本語"
];
String selectedLanguageValue = languageOptions[selectedLanguage];

// Shown lot type option data
int selectedShownLotType = 0;
final List<String> shownLotTypeOptions = [
  "Commuter",
  "Employee",
  "All"
];
String selectedShownLotTypeValue = shownLotTypeOptions[selectedShownLotType];

class SettingsWidget extends StatefulWidget {
  final Future<void> Function() logoutAction;

  SettingsWidget({Key? key, required this.logoutAction}) : super(key: key) {}


  @override
  State<StatefulWidget> createState() => SettingsWidgetState();
}

class SettingsWidgetState extends State<SettingsWidget> {
  bool loading = true;

  @override
  void initState(){
    loading = true;
    initialize();
    super.initState();
  }

  Future<void> initialize() async{
    prefs = await SharedPreferences.getInstance();

    // Check for language settings in shared_preferences
    selectedLanguage = prefs.getInt(languageKey) ?? 0;
    selectedLanguageValue = languageOptions[selectedLanguage];

    // Check for shown lot type settings in shared_preferences
    selectedShownLotType = prefs.getInt(shownLotTypeIntKey) ?? 0;
    selectedShownLotTypeValue = shownLotTypeOptions[selectedShownLotType];

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) => loading?
    Scaffold(
          //Loading screen while gathering information
          body: Center(child: const CircularProgressIndicator())
    ) :
    SettingsList(
      backgroundColor: Theme.of(context).canvasColor,
      sections: [
        SettingsSection(
          //titleTextStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).appBarTheme.backgroundColor),
          //title: 'Section',
          tiles: [
            SettingsTile(
              titleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
              title: 'Language',
              subtitle: selectedLanguageValue,
              subtitleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
              leading: Icon(Icons.language, color: Theme.of(context).textTheme.bodyText1?.color),
              trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).textTheme.bodyText1?.color),
              onPressed: (BuildContext context) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OptionSelector("Select a Language", languageOptions, (int index){
                      //Do other language changing stuff here
                      setState(() {
                        selectedLanguage = index;
                        selectedLanguageValue = languageOptions[selectedLanguage];
                        prefs.setInt(languageKey, selectedLanguage);
                      });
                    })
                  )
                );
              },
            ),
            SettingsTile(
              titleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
              title: 'Lots Shown',
              subtitle: selectedShownLotTypeValue,
              subtitleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
              leading: Icon(Icons.language, color: Theme.of(context).textTheme.bodyText1?.color),
              trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).textTheme.bodyText1?.color),
              onPressed: (BuildContext context) {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => OptionSelector("Which lots should we show you?", shownLotTypeOptions, (int index){
                      //Do other language changing stuff here
                      setState(() {
                        selectedShownLotType = index;
                        selectedShownLotTypeValue = shownLotTypeOptions[selectedShownLotType];
                        prefs.setInt(shownLotTypeIntKey, selectedShownLotType);
                        prefs.setString(shownLotTypeStringKey, selectedShownLotTypeValue);
                      });
                    })
                  )
                );
              },
            ),
          ]
        ),
        SettingsSection(
          //titleTextStyle: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Theme.of(context).appBarTheme.backgroundColor),
          //title: 'Misc',
          tiles: [
              SettingsTile(
                title: 'Text Size' ,
                titleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
                subtitle: 'Default',
                subtitleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
                leading: Icon(Icons.sort_by_alpha, color: Theme.of(context).textTheme.bodyText1?.color),
                trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).textTheme.bodyText1?.color),
                onPressed: (BuildContext context) {},
              ),
              SettingsTile(
                title: 'Logout of app' ,
                titleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
                subtitle: 'Bye',
                subtitleTextStyle: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color),
                leading: Icon(Icons.logout, color: Theme.of(context).textTheme.bodyText1?.color),
                trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).textTheme.bodyText1?.color),
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
