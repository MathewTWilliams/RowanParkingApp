import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'lotinfo_widget.dart';


void main() => runApp(const MaterialApp(home: CheckinWidget()));

class CheckinWidget extends StatelessWidget {
  const CheckinWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          shrinkWrap: true, padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          children: <Widget> [
            CheckinBox(
                lotName: 'Lot O',
                spaces: 'x/201 Spaces',
                permission: 'Commuter'),
            ElevatedButton(child: const Text('Check Into Lot O'),
              onPressed: (){ //Navigates to the Checkout screen
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> CheckoutWidget(nameLot: 'Lot O',)),
                );
              },
            ),
            CheckinBox(
                lotName: 'Lot O-1',
                spaces: 'X/296 Spaces',
                permission: 'Employee Only until 4pm'),
            ElevatedButton(child: const Text('Check Into Lot O-1'),
              onPressed: (){ //Navigates to the Checkout screen
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> CheckoutWidget(nameLot: 'Lot O-1',)),
                );
              },
            ),
            CheckinBox(
                lotName: 'Lot P',
                spaces: 'x/524 Spaces',
                permission: 'Commuter'),
            ElevatedButton(child: const Text('Check Into Lot P'),
              onPressed: (){ //Navigates to the Checkout screen
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> CheckoutWidget(nameLot: 'Lot P',)),
                );
              },
            ),
            CheckinBox(
                lotName: 'Lot D',
                spaces: 'X/391 Spaces',
                permission: 'Commuter'),
            ElevatedButton(child: const Text('Check Into Lot D'),
              onPressed: (){ //Navigates to the Checkout screen
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> CheckoutWidget(nameLot: 'Lot D',)),
                );
              },
            ),
            CheckinBox(
                lotName: 'Lot A',
                spaces: 'X/200 Spaces',
                permission: 'Commuter'),
            ElevatedButton(child: const Text('Check Into Lot A'),
              onPressed: (){ //Navigates to the Checkout screen
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> CheckoutWidget(nameLot: 'Lot A',)),
                );
              },
            ),
          ],
        )
    );
  }
}

class CheckinBox extends StatelessWidget {
  CheckinBox({required this.lotName, required this.spaces, required this.permission});
  String lotName;
  String spaces;
  String permission;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8), height: 120,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
                child: Container(
                    padding: const EdgeInsets.all(5),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Text(lotName, style: const TextStyle(fontWeight:
                          FontWeight.bold)), Text(spaces), Text(permission),
                        ]
                    )
                )
            ),
            //put the button here again if you want to remake it
          ],
        ),
      ),
    );
  }
}
