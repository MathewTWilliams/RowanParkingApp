import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class LotsWidget extends StatelessWidget {
  const LotsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Parking Lots"),
      ),
    );
  }
}
