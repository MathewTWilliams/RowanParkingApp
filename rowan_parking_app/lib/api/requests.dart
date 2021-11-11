import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const String serverURL = "3.137.195.9";

const FlutterSecureStorage secureStorage = FlutterSecureStorage();

class Requests {
  static Future<List<Venue>> getVenueList() async {
    final String accessToken = await secureStorage.read(key: 'access_token');
    final response = await http.get(Uri.parse('http://3.137.195.9/api/venues'),
        headers: {'authorization': 'Basic $accessToken'});

    if (response.statusCode == 200) {
      print(response.body);
      return Venue.venueListFromJson(response.body);
    } else {
      throw Exception('Received invalid server response trying to GET Venues');
    }
  }

  static Future<VenueInfo> getVenueInfo(final int venueID) async {
    final String accessToken = await secureStorage.read(key: 'access_token');
    final response = await http.get(
        Uri.parse('http://3.137.195.9//api/venues/$venueID'),
        headers: {'authorization': 'Basic $accessToken'});

    if (response.statusCode == 200) {
      print(response.body);
      return VenueInfo.venueInfoFromJson(response.body);
    } else {
      throw Exception(
          'Received invalid server response trying to GET VenueInfo with ID: $venueID');
    }
  }

  static Future<List<Lot>> getLotList(final int venueID) async {
    final String accessToken = await secureStorage.read(key: 'access_token');
    final response = await http.get(
        Uri.parse('http://3.137.195.9/api/venues/$venueID/lots'),
        headers: {'authorization': 'Basic $accessToken'});

    if (response.statusCode == 200) {
      print(response.body);
      return Lot.lotListFromJson(response.body);
    } else {
      throw Exception(
          'Received invalid server response trying to GET Lots with venue ID $venueID');
    }
  }

  static Future<Lot> getLot(final int venueID, final int lid) async {
    final String accessToken = await secureStorage.read(key: 'access_token');
    final response = await http.get(
        Uri.parse('http://3.137.195.9/api/venues/$venueID/lots/$lid'),
        headers: {'authorization': 'Basic $accessToken'});

    if (response.statusCode == 200) {
      print(response.body);
      return Lot.lotFromJson(response.body);
    } else {
      throw Exception(
          'Received invalid server response trying to GET Lot with venue ID $venueID, lot ID $lid');
    }
  }

  //static Future<CheckinReceipt> checkin(final int venueID, final int lotID, final int userID)
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

  static List<Lot> lotListFromJson(String str) =>
      List<Lot>.from(json.decode(str).map((x) => Lot.fromJson(x)));

  static Lot lotFromJson(String str) => Lot.fromJson(json.decode(str));
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
        boundingBox: BoundingBox.fromJson(json["BoundingBox"]),
        lotLocation: LotLocation.fromJson(json["LotLocation"]),
      );
}

class BoundingBox {
  BoundingBox({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<List<List<num>>> coordinates;

  factory BoundingBox.fromJson(Map<String, dynamic> json) => BoundingBox(
        type: json["type"],
        coordinates: List<List<List<num>>>.from(json["coordinates"].map((x) =>
            List<List<num>>.from(
                x.map((x) => List<num>.from(x.map((x) => x)))))),
      );
}

class LotLocation {
  LotLocation({
    required this.type,
    required this.coordinates,
  });

  String type;
  List<num> coordinates;

  factory LotLocation.fromJson(Map<String, dynamic> json) => LotLocation(
        type: json["type"],
        coordinates: List<num>.from(json["coordinates"].map((x) => x)),
      );
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

CheckinReceipt checkinReceiptFromJson(String str) =>
    CheckinReceipt.fromJson(json.decode(str));

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
