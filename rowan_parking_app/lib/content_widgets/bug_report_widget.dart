import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'package:rowan_parking_app/api/requests.dart';

void main() => runApp(const MaterialApp(home: BugReportWidget()));

class BugReportWidget extends StatelessWidget {
  const BugReportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: const Center(
          child: MyStatefulWidget(),
        ),
      );
  }
}

/// This is the stateful widget that the main application instantiates.
class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MyStatefulWidgetState extends State<MyStatefulWidget> {

  bool bugReported = false;  // We will want to switch to a splash screen once the bug is reported
  
  String dropdownValue = 'Am not able to check into the lot';
  final List<String> dropdownOptions = 
  [
    'Am not able to check into the lot',
    'Am not able to check out of the lot',
    'Parking lots are not showing up',
    'Does not show how many available spots are left',
    'Does not let me log out of the app',
    'Other'
  ];

  TextEditingController detailsFieldController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: bugReported ? Center(child: const Text("Thank you for your feedback!", style: TextStyle(fontSize: 30), textAlign: TextAlign.center,)) :
      Column(
        children: <Widget>
        [
          Container(  //Spacing container
            height: 35,
          ),
          Container(
            decoration: BoxDecoration(color: Theme.of(context).primaryColor, borderRadius: BorderRadius.circular(4)),
            width: MediaQuery.of(context).size.width * 0.9,
            child: DropdownButton<String>(
              value: dropdownValue,
              isExpanded: true,
              dropdownColor: Theme.of(context).primaryColor,
              iconEnabledColor: Theme.of(context).appBarTheme.backgroundColor,
              icon: Icon(Icons.arrow_downward),
              style: TextStyle(color: Theme.of(context).textTheme.bodyText1?.color, fontSize: 15),
              borderRadius: BorderRadius.circular(4),
              underline: Container(
              ),
              onChanged: (String? newValue) {
                setState(() {
                  dropdownValue = newValue!;
                });
              },
              items: dropdownOptions
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value,),
                );
              }).toList(),
              hint: Text ("Select an issue")
            )
          ),
          Container(  //Spacing container
            height: 15,
          ),
          Container(
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(4)), 
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextField(
              minLines: 4,
              maxLines: 8,
              textCapitalization: TextCapitalization.sentences,
              controller: detailsFieldController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Provide additional info, if applicable."
              ),
            )
          ),
          Container(  //Spacing container
            height: 15,
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: 55,
            child: ElevatedButton(
              child: Text("Submit", textAlign: TextAlign.center,), 
              onPressed: () {
                setState(() {
                  Requests.sendBugReport("$dropdownValue: ${detailsFieldController.text}");
                  bugReported = true;
                });
              }, 
            )
          ),
          
        ]
      )
    );
  }
}