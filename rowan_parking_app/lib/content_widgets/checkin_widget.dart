import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


void main() => runApp(const MaterialApp(home: CheckinWidget()));

class CheckinWidget extends StatelessWidget {
  const CheckinWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Lot Information")
        ),
      body: ListView(
        shrinkWrap: true, padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
        children: <Widget> [
          LotInfoBox(
              rating: 'Good Availability',
              lotName: 'Lot O',
              permission: 'Commuter'),
          ElevatedButton( child: const Text('Check-in'),
            onPressed: (){ //Navigates to the Checkout screen
              Navigator.push(context,
                MaterialPageRoute(builder: (context)=> const CheckoutWidget()),
              );
            },
          ),
        ],
      )
    );
  }
}

/* Basic CheckinBox used above
CheckinBox(
  rating: 'No Availability',
  lotName: 'Lot A-1',
  permission: 'Employee'),
 */

// Holds the information for what goes into the LotInfoBox for the above listView
class LotInfoBox extends StatelessWidget {
  LotInfoBox({required this.rating, required this.lotName, required this.permission});
  final String rating;
  final String lotName;
  final String permission;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8), height: 120,
        child: Card(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(rating, style: const TextStyle(fontWeight:
                FontWeight.bold)), Text(lotName), Text(permission),
            ],
          ),

        ),

    );
  }
}

/*
**********************************
  HERE STARTS THEW CHECKOUT PAGE
**********************************
*/
class CheckoutWidget extends StatelessWidget{
  const CheckoutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ready to Check-Out?")
      ),
        body: ListView(
          shrinkWrap: true, padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 20.0),
          children: <Widget> [
            CheckoutBox(rating: 'Test Rating', lotName: 'Test Name'),
            ElevatedButton( child: const Text('Check-out of this lot'),
              onPressed: (){
                Navigator.pop(context);
              },
            ),
          ],
        )
    );
  }
}

//This holds the information for what goes into the checkout box listed above
class CheckoutBox extends StatelessWidget {
  CheckoutBox({required this.rating, required this.lotName});
  final String rating;
  final String lotName;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(2), height: 120, child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: <Widget>[
          Text(rating, style: const TextStyle(fontWeight:
          FontWeight.bold)), Text(lotName),
          ],
        )
        )
    );
  }
}


