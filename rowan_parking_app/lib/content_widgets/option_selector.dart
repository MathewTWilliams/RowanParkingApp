import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class OptionSelector extends StatelessWidget {
  String prompt; // appbar text
  List<String> options; // a list of options to ask the user to choose from
  void Function(int) callback;  // when an option is selected, this function is called with the index of the selected option

  OptionSelector(this.prompt, this.options, this.callback) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(prompt)),
      body: Center(
        child: ListView(
          children: [
            for (String option in options) 
              ElevatedButton(child: Text(option), onPressed:() {
                callback(options.indexOf(option));
                Navigator.of(context).pop();
              }
            ),
          ],
        ),
      ),
    );
  }
}