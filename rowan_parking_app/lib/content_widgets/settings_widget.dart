import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class SettingsWidget extends StatelessWidget {
  final VoidCallback settingsChangedCallback;

  const SettingsWidget({Key? key, required this.settingsChangedCallback})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
