import 'dart:convert';
import 'package:http/http.dart' as http;

const String serverURL = "3.137.195.9";


class Lots
{
  static Future<List<LotEntry>> getLotEntryList() async {
    final response =
        await http.get(Uri.parse('http://3.137.195.9/api/venues/1/lots'));

    if (response.statusCode == 200) {
      print(response.body);
      return LotEntry.entryListFromJson(response.body);
    } else {
      throw Exception('Received invalid server response trying to GET Lots');
    }
  }
}

class LotEntry {
  LotEntry({
    required this.spotsTaken,
    required this.lotInfo,
  });

  int spotsTaken;
  LotInfo lotInfo;

  factory LotEntry.fromJson(Map<String, dynamic> json) => LotEntry(
        spotsTaken: json["SpotsTaken"],
        lotInfo: LotInfo.fromJson(json["LotInfo"]),
      );

  static List<LotEntry> entryListFromJson(String str) => List<LotEntry>.from(json.decode(str).map((x) => LotEntry.fromJson(x)));
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