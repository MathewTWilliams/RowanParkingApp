import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class CheckinWidget extends StatelessWidget {
  const CheckinWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Check in", //TODO this will need to switch between Check In and Check Out
        ),
      ),
    );
  }
}
