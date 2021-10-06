import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class BugReportWidget extends StatelessWidget {
  const BugReportWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Report a Problem"),
      ),
    );
  }
}
