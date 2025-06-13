import 'dart:convert';

AddressModel addressModelFromJson(String str) =>
    AddressModel.fromJson(json.decode(str));

String addressModelToJson(AddressModel data) =>
    json.encode(data.toJson());

class AddressModel {
  int? placeId;
  String? licence;
  String? osmType;
  int? osmId;
  String? lat;
  String? lon;
  String? addressModelClass;
  String? type;
  int? placeRank;
  double? importance;
  String? addresstype;
  String? name;
  String? displayName;
  Address? address;
  List<String>? boundingbox;

  AddressModel({
    this.placeId,
    this.licence,
    this.osmType,
    this.osmId,
    this.lat,
    this.lon,
    this.addressModelClass,
    this.type,
    this.placeRank,
    this.importance,
    this.addresstype,
    this.name,
    this.displayName,
    this.address,
    this.boundingbox,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) => AddressModel(
    placeId: json["place_id"],
    licence: json["licence"],
    osmType: json["osm_type"],
    osmId: json["osm_id"],
    lat: json["lat"],
    lon: json["lon"],
    addressModelClass: json["class"],
    type: json["type"],
    placeRank: json["place_rank"],
    importance: json["importance"]?.toDouble(),
    addresstype: json["addresstype"],
    name: json["name"],
    displayName: json["display_name"],
    address: json["address"] != null
        ? Address.fromJson(json["address"])
        : null,
    boundingbox: json["boundingbox"] == null
        ? null
        : List<String>.from(json["boundingbox"]),
  );

  Map<String, dynamic> toJson() => {
    "place_id": placeId,
    "licence": licence,
    "osm_type": osmType,
    "osm_id": osmId,
    "lat": lat,
    "lon": lon,
    "class": addressModelClass,
    "type": type,
    "place_rank": placeRank,
    "importance": importance,
    "addresstype": addresstype,
    "name": name,
    "display_name": displayName,
    "address": address?.toJson(),
    "boundingbox": boundingbox,
  };
}

class Address {
  String? road;
  String? cityBlock;
  String? neighbourhood;
  String? suburb;
  String? cityDistrict;
  String? city;
  String? iso31662Lvl4;
  String? region;
  String? iso31662Lvl3;
  String? postcode;
  String? country;
  String? countryCode;

  Address({
    this.road,
    this.cityBlock,
    this.neighbourhood,
    this.suburb,
    this.cityDistrict,
    this.city,
    this.iso31662Lvl4,
    this.region,
    this.iso31662Lvl3,
    this.postcode,
    this.country,
    this.countryCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
    road: json["road"],
    cityBlock: json["city_block"],
    neighbourhood: json["neighbourhood"],
    suburb: json["suburb"],
    cityDistrict: json["city_district"],
    city: json["city"],
    iso31662Lvl4: json["ISO3166-2-lvl4"],
    region: json["region"],
    iso31662Lvl3: json["ISO3166-2-lvl3"],
    postcode: json["postcode"],
    country: json["country"],
    countryCode: json["country_code"],
  );

  Map<String, dynamic> toJson() => {
    "road": road,
    "city_block": cityBlock,
    "neighbourhood": neighbourhood,
    "suburb": suburb,
    "city_district": cityDistrict,
    "city": city,
    "ISO3166-2-lvl4": iso31662Lvl4,
    "region": region,
    "ISO3166-2-lvl3": iso31662Lvl3,
    "postcode": postcode,
    "country": country,
    "country_code": countryCode,
  };
}
