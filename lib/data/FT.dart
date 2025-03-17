import 'package:latlong2/latlong.dart';

class FT {
  late List<Features> features = <Features>[];

  FT({ required this.features});

  FT.fromJson(Map<String, dynamic> json) {
    json['features'].forEach((v) {
      features.add(Features.fromJson(v));
    });
  }

}

class Features  {
  String id = "";
  Geometry geometry = Geometry();
  Properties properties = Properties();

  Features(
      {
      required this.id,
      required this.geometry,
      required this.properties
      });

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    geometry = Geometry.fromJson(json['geometry']);
    properties = (Properties.fromJson(json['properties']));
  }

  @override

  LatLng get location => LatLng(geometry.coordinates!.last, geometry.coordinates!.first);
}

class Geometry {
  List<double>? coordinates;

  Geometry({ this.coordinates});

  Geometry.fromJson(Map<String, dynamic> json) {
    coordinates = json['coordinates'].cast<double>();
  }
}

class Properties {
  int id = 0;
  String? slaegt;
  String danskNavn = "";
  String slaegtsnavn = "";
  String planteaar = "";

  Properties(
      {this.id = 0,
      this.slaegt = "",
      this.danskNavn = "",
      this.slaegtsnavn = "",
      this.planteaar = ""});

  Properties.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    slaegt = json['slaegt'] ?? "";
    danskNavn = json['dansk_navn'] ?? "";
    slaegtsnavn = json['slaegtsnavn'] ?? "";
    planteaar = json['planteaar'] ?? "";
  }
}
