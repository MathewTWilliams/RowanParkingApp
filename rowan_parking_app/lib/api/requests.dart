
//* Handles all API requests */

// TODO break this down into single-responsibility libraries

import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String serverURL = "3.137.195.9";
//const String serverURL = "127.0.0.1";

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class Requests {
  static Future<List<Venue>> getVenueList() async {
    final String accessToken = await secureStorage.read(key: 'access_token');
    final response = await http.get(Uri.parse('http://' + serverURL + '/api/venues'),
        headers: {'authorization': accessToken});

    if (response.statusCode == 200) {
      return Venue.venueListFromJson(response.body);
    } else {
      throw Exception('Received invalid server response trying to GET Venues. Status Code: ' + response.statusCode.toString());
    }
  }

  static Future<VenueInfo> getVenueInfo(final int venueID) async {
    final String accessToken = await secureStorage.read(key: 'access_token');
    final response = await http.get(
        Uri.parse('http://' + serverURL + '/api/venues/$venueID'),
        headers: {'authorization': accessToken});

    if (response.statusCode == 200) {
      return VenueInfo.venueInfoFromJson(response.body);
    } else {
      throw Exception(
          'Received invalid server response trying to GET VenueInfo with ID: $venueID. Status Code: ' + response.statusCode.toString());
    }
  }

  static Future<List<Lot>> getLotList(final int venueID) async {
    final String accessToken = await secureStorage.read(key: 'access_token');

    final response = await http.get(
        Uri.parse('http://' + serverURL + '/api/venues/$venueID/lots'),
        headers: {'authorization': accessToken});

    if (response.statusCode == 200) {
      return Lot.lotListFromJson(response.body);
    } else {
      throw Exception(
          'Received invalid server response trying to GET Lots with venue ID $venueID. Status Code: ' + response.statusCode.toString());
    }

    
  }

  /*
  static Future<Lot> getLot(final int venueID, final int lotID) async {
    final String accessToken = await secureStorage.read(key: 'access_token');
    final response = await http.get(
        Uri.parse('http://' + serverURL + '/api/venues/$venueID/lots/$lotID'),
        headers: {'authorization': accessToken});

    if (response.statusCode == 200) {
      return Lot.lotFromJson(response.body);
    } else {
      throw Exception(
          'Received invalid server response trying to GET Lot with venue ID $venueID, lot ID $lotID. Status Code:' + response.statusCode.toString());
    }
  }
  */

  static Future<CheckinReceipt> checkin(final int venueID, final int lotID) async {
    final String accessToken = await secureStorage.read(key: 'access_token');
    final int userID = (await SharedPreferences.getInstance()).getInt('user_id') ?? -1;

    if('user_id' == -1)
      throw Exception('No user_id found in local storage');

    final response = await http.post(
        Uri.parse('http://' + serverURL + '/api/venues/$venueID/lots/$lotID/check_in'),
        headers: {'authorization': accessToken, "Content-Type": "application/json"},
        body: json.encode({"UserId" : userID}));

    if (response.statusCode == 200 || response.statusCode == 201) { 
      print("successful checkin returned: ${response.body}");
      return CheckinReceipt.checkinReceiptFromJson(response.body);
    } else {
      throw Exception(
          'Received invalid server response trying to checkin to venue $venueID, lot $lotID');
    }
  }

  static Future<CheckinReceipt> checkout(final int venueID, final int lotID) async {
    final String accessToken = await secureStorage.read(key: 'access_token');
    final int userID = (await SharedPreferences.getInstance()).getInt('user_id') ?? -1;

    if(userID == -1)
      throw Exception('No user_id found in local storage');

    final response = await http.post(
        Uri.parse('http://' + serverURL + '/api/venues/$venueID/lots/$lotID/check-out'),
        headers: {'authorization': accessToken, "Content-Type": "application/json"},
        body: json.encode({"UserId" : userID}));

    if (response.statusCode == 200 || response.statusCode == 201) { 
      print("successful checkout returned: ${response.body}");
      return CheckinReceipt.checkinReceiptFromJson(response.body);
    } else {
      throw Exception(
          'Received invalid server response trying to checkin to venue $venueID, lot $lotID');
    }
  }

  static Future<LoginReceipt> login(String username, int venueID) async {
    final String accessToken = await secureStorage.read(key: 'access_token');
    final response = await http.post(
        Uri.parse('http://' + serverURL + '/api/users/login'),
        headers: {'authorization': accessToken},
        body: jsonEncode(<String, Object>
        {
          'UserName': username,
          'VenueId': venueID
        }));

    if (response.statusCode == 200) {
      LoginReceipt rec = LoginReceipt.userDetailsFromJson(response.body);
      print("Login processed. Last checkin's id is ${rec.lastCheckIn}");
      return rec;
    } else {
      throw Exception(
          'Received invalid server response trying to log in, with username $username, venueID $venueID');
    }
  }

}



class Venue {
  Venue({
    required this.id,
    required this.venueName,
    required this.venueLocation,
  });

  int id;
  String venueName;
  VenueLocation venueLocation;

  factory Venue.fromJson(Map<String, dynamic> json) => Venue(
        id: json["Id"],
        venueName: json["VenueName"],
        venueLocation: VenueLocation.fromJson(json["VenueLocation"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "VenueName": venueName,
        "VenueLocation": venueLocation.toJson(),
      };

  static List<Venue> venueListFromJson(String str) =>
      List<Venue>.from(json.decode(str).map((x) => Venue.fromJson(x)));
}

class VenueLocation {
  VenueLocation({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<double> coordinates;

  factory VenueLocation.fromJson(Map<String, dynamic> json) => VenueLocation(
        type: json["type"],
        coordinates:
            List<double>.from(json["coordinates"].map((x) => x.toDouble())),
      );

  Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
      };
}

class Lot {
    Lot({
        required this.spotsTaken,
        required this.lotInfo,
    });

    int spotsTaken;
    LotInfo lotInfo;

    factory Lot.fromJson(Map<String, dynamic> json) => Lot(
        spotsTaken: json["SpotsTaken"],
        lotInfo: LotInfo.fromJson(json["LotInfo"]),
    );

    Map<String, dynamic> toJson() => {
        "SpotsTaken": spotsTaken,
        "LotInfo": lotInfo.toJson(),
    };

    static List<Lot> lotListFromJson(String str) => List<Lot>.from(json.decode(str).map((x) => Lot.fromJson(x)));

}

class LotInfo {
    LotInfo({
        required this.id,
        required this.lotName,
        required this.lotDescription,
        required this.lotType,
        required this.numSpaces,
        required this.venueId,
        required this.specificRules,
        required this.boundingBox,
        required this.lotLocation,
    });

    int id;
    String lotName;
    String lotDescription;
    int lotType;
    int numSpaces;
    int venueId;
    String specificRules;
    BoundingBox boundingBox;
    LotLocation lotLocation;

    factory LotInfo.fromJson(Map<String, dynamic> json) => LotInfo(
        id: json["Id"],
        lotName: json["LotName"],
        lotDescription: json["LotDescription"],
        lotType: json["LotType"],
        numSpaces: json["NumSpaces"],
        venueId: json["VenueId"],
        specificRules: json["SpecificRules"],
        boundingBox: json["BoundingBox"] == null ? BoundingBox(type: "None", coordinates: List.empty()) : BoundingBox.fromJson(json["BoundingBox"]),
        lotLocation: json["LotLocation"] == null ? LotLocation(type: "None", coordinates: List.empty()) : LotLocation.fromJson(json["LotLocation"]),
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "LotName": lotName,
        "LotDescription": lotDescription,
        "LotType": lotType,
        "NumSpaces": numSpaces,
        "VenueId": venueId,
        "SpecificRules": specificRules,
        "BoundingBox": boundingBox == null ? null : boundingBox.toJson(),
        "LotLocation": lotLocation == null ? null : lotLocation.toJson(),
    };
}

class BoundingBox {
    BoundingBox({
        required this.type,
        required this.coordinates,
    });

    String type;
    List<List<List<int>>> coordinates;

    factory BoundingBox.fromJson(Map<String, dynamic> json) => BoundingBox(
        type: json["type"],
        coordinates: List<List<List<int>>>.from(json["coordinates"].map((x) => List<List<int>>.from(x.map((x) => List<int>.from(x.map((x) => x)))))),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => List<dynamic>.from(x.map((x) => List<dynamic>.from(x.map((x) => x)))))),
    };
}

class LotLocation {
    LotLocation({
        required this.type,
        required this.coordinates,
    });

    String type;
    List<int> coordinates;

    factory LotLocation.fromJson(Map<String, dynamic> json) => LotLocation(
        type: json["type"],
        coordinates: List<int>.from(json["coordinates"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "type": type,
        "coordinates": List<dynamic>.from(coordinates.map((x) => x)),
    };
}


String venueInfoToJson(VenueInfo data) => json.encode(data.toJson());

class VenueInfo {
  VenueInfo({
    required this.id,
    required this.venueName,
    required this.venueLocation,
  });

  int id;
  String venueName;
  VenueLocation venueLocation;

  factory VenueInfo.fromJson(Map<String, dynamic> json) => VenueInfo(
        id: json["Id"],
        venueName: json["VenueName"],
        venueLocation: VenueLocation.fromJson(json["VenueLocation"]),
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "VenueName": venueName,
        "VenueLocation": venueLocation.toJson(),
      };

  static VenueInfo venueInfoFromJson(String str) =>
      VenueInfo.fromJson(json.decode(str));
}

class CheckinReceipt {
  CheckinReceipt({
    required this.spotsTaken,
    required this.checkInInfo,
  });

  int spotsTaken;
  CheckInInfo checkInInfo;

  factory CheckinReceipt.fromJson(Map<String, dynamic> json) => CheckinReceipt(
        spotsTaken: json["SpotsTaken"],
        checkInInfo: CheckInInfo.fromJson(json["CheckInInfo"]),
      );

  Map<String, dynamic> toJson() => {
        "SpotsTaken": spotsTaken,
        "CheckInInfo": checkInInfo.toJson(),
      };

  static CheckinReceipt checkinReceiptFromJson(String str) =>
    CheckinReceipt.fromJson(json.decode(str));
}

class CheckInInfo {
  CheckInInfo({
    required this.id,
    required this.lotId,
    required this.checkInTime,
    required this.checkOutTime,
    required this.userid,
  });

  int id;
  int lotId;
  DateTime checkInTime;
  DateTime checkOutTime;
  int userid;

  factory CheckInInfo.fromJson(Map<String, dynamic> json) => CheckInInfo(
        id: json["Id"],
        lotId: json["LotId"],
        checkInTime: DateTime.parse(json["CheckInTime"]),
        checkOutTime: DateTime.parse(json["CheckOutTime"]),
        userid: json["Userid"],
      );

  Map<String, dynamic> toJson() => {
        "Id": id,
        "LotId": lotId,
        "CheckInTime": checkInTime.toIso8601String(),
        "CheckOutTime": checkOutTime.toIso8601String(),
        "Userid": userid,
      };
}


class LoginReceipt {
    LoginReceipt({
        required this.id,
        required this.settings,
        required this.userName,
        required this.venueId,
        required this.lastCheckIn,
    });

    int id;
    Settings settings;
    String userName;
    int venueId;
    int lastCheckIn;

    factory LoginReceipt.fromJson(Map<String, dynamic> json) => LoginReceipt(
        id: json["Id"],
        settings: Settings.fromJson(json["Settings"]),
        userName: json["UserName"],
        venueId: json["VenueId"],
        lastCheckIn: json["LastCheckIn"],
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "Settings": settings.toJson(),
        "UserName": userName,
        "VenueId": venueId,
        "LastCheckIn": lastCheckIn,
    };

    static LoginReceipt userDetailsFromJson(String str) => LoginReceipt.fromJson(json.decode(str));
}

class Settings {
    Settings({
        required this.textSize,
        required this.language,
    });

    int textSize;
    String language;

    factory Settings.fromJson(Map<String, dynamic> json) => Settings(
        textSize: json["Text_Size"],
        language: json["Language"],
    );

    Map<String, dynamic> toJson() => {
        "Text_Size": textSize,
        "Language": language,
    };
}

