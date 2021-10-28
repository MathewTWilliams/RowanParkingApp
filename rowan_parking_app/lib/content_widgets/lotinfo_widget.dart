import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';


class LotOWidget extends StatelessWidget {
  LotOWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Lot O Information")
        ),
        body: ListView(
          shrinkWrap: true, padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          children: <Widget> [
            LotInfoBox(
                rating: 'Good Availability',
                spaces: 'X/201 Spaces',
                permission: 'Commuter'),
            ElevatedButton( child: const Text('Check-in'),
              onPressed: (){ //Navigates to the Checkout screen
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> CheckoutWidget(nameLot: 'Lot O',)),
                );
              },
            ),
          ],
        )
    );
  }
}

class LotO1Widget extends StatelessWidget {
  LotO1Widget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Lot O-1 Information")
        ),
        body: ListView(
          shrinkWrap: true, padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          children: <Widget> [
            LotInfoBox(
                rating: 'Good Availability',
                spaces: 'X/296 Spaces',
                permission: 'Employee Only'),
            ElevatedButton( child: const Text('Check-in'),
              onPressed: (){ //Navigates to the Checkout screen
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> CheckoutWidget(nameLot: 'Lot O-1',)),
                );
              },
            ),
          ],
        )
    );
  }
}

class LotPWidget extends StatelessWidget {
  LotPWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Lot P Information")
        ),
        body: ListView(
          shrinkWrap: true, padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          children: <Widget> [
            LotInfoBox(
                rating: 'Good Availability',
                spaces: 'x/524 Spaces',
                permission: 'Commuter'),
            ElevatedButton( child: const Text('Check-in'),
              onPressed: (){ //Navigates to the Checkout screen
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> CheckoutWidget(nameLot: 'Lot P',)),
                );
              },
            ),
          ],
        )
    );
  }
}

class LotDWidget extends StatelessWidget {
  LotDWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Lot D Information")
        ),
        body: ListView(
          shrinkWrap: true, padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          children: <Widget> [
            LotInfoBox(
                rating: 'Good Availability',
                spaces: 'X/391 Spaces',
                permission: 'Commuter'),
            ElevatedButton( child: const Text('Check-in'),
              onPressed: (){ //Navigates to the Checkout screen
                Navigator.push(context,
                  MaterialPageRoute(builder: (context)=> CheckoutWidget(nameLot: 'Lot D',)),
                );
              },
            ),
          ],
        )
    );
  }
}

class LotAWidget extends StatelessWidget {
  LotAWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Lot A Information")
        ),
        body: ListView(
          shrinkWrap: true, padding: const EdgeInsets.fromLTRB(10.0, 20.0, 10.0, 20.0),
          children: <Widget> [
            LotInfoBox(
                rating: 'Good Availability',
                spaces: 'X/200 Spaces',
                permission: 'Commuter'),
            ElevatedButton( child: const Text('Check-in'),
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

class LotInfoBox extends StatelessWidget {
  LotInfoBox({required this.rating, required this.permission, required this.spaces});
  final String rating;
  final String permission;
  final String spaces;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8), height: 120,
      child: Card(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(rating, style: const TextStyle(fontWeight:
            FontWeight.bold)), Text(spaces), Text(permission),
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
  CheckoutWidget({Key? key, required this.nameLot}) : super(key: key);
  String nameLot;

  @override
  Widget build(BuildContext context){
    return Scaffold(
        appBar: AppBar(
            title: const Text("Ready to Check-Out?")
        ),
        body: ListView(
          shrinkWrap: true, padding: const EdgeInsets.fromLTRB(10.0, 50.0, 10.0, 20.0),
          children: <Widget> [
            CheckoutBox(rating: 'Test Rating', lotName: 'You are checked into '+ nameLot +'.'),
            ElevatedButton( child: Text('Check-out of '+ nameLot +'.'),
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