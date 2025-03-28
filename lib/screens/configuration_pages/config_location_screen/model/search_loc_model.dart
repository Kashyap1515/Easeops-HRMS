// To parse this JSON data, do
//
//     final locationSearchListModel = locationSearchListModelFromJson(jsonString);

import 'dart:convert';

LocationSearchListModel locationSearchListModelFromJson(String str) =>
    LocationSearchListModel.fromJson(json.decode(str));

String locationSearchListModelToJson(LocationSearchListModel data) =>
    json.encode(data.toJson());

class LocationSearchListModel {
  LocationSearchListModel({
    this.predictions,
    this.status,
  });

  factory LocationSearchListModel.fromJson(Map<String, dynamic> json) =>
      LocationSearchListModel(
        predictions: json['predictions'] == null
            ? []
            : List<Prediction>.from(
                json['predictions']!.map((x) => Prediction.fromJson(x)),
              ),
        status: json['status'],
      );
  List<Prediction>? predictions;
  String? status;

  Map<String, dynamic> toJson() => {
        'predictions': predictions == null
            ? []
            : List<dynamic>.from(predictions!.map((x) => x.toJson())),
        'status': status,
      };
}

class Prediction {
  Prediction({
    this.description,
    this.matchedSubstrings,
    this.placeId,
    this.reference,
    this.structuredFormatting,
    this.terms,
    this.types,
  });

  factory Prediction.fromJson(Map<String, dynamic> json) => Prediction(
        description: json['description'],
        matchedSubstrings: json['matched_substrings'] == null
            ? []
            : List<MatchedSubstring>.from(
                json['matched_substrings']!
                    .map((x) => MatchedSubstring.fromJson(x)),
              ),
        placeId: json['place_id'],
        reference: json['reference'],
        structuredFormatting: json['structured_formatting'] == null
            ? null
            : StructuredFormatting.fromJson(json['structured_formatting']),
        terms: json['terms'] == null
            ? []
            : List<Term>.from(json['terms']!.map((x) => Term.fromJson(x))),
        types: json['types'] == null
            ? []
            : List<String>.from(json['types']!.map((x) => x)),
      );
  String? description;
  List<MatchedSubstring>? matchedSubstrings;
  String? placeId;
  String? reference;
  StructuredFormatting? structuredFormatting;
  List<Term>? terms;
  List<String>? types;

  Map<String, dynamic> toJson() => {
        'description': description,
        'matched_substrings': matchedSubstrings == null
            ? []
            : List<dynamic>.from(matchedSubstrings!.map((x) => x.toJson())),
        'place_id': placeId,
        'reference': reference,
        'structured_formatting': structuredFormatting?.toJson(),
        'terms': terms == null
            ? []
            : List<dynamic>.from(terms!.map((x) => x.toJson())),
        'types': types == null ? [] : List<dynamic>.from(types!.map((x) => x)),
      };
}

class MatchedSubstring {
  MatchedSubstring({
    this.length,
    this.offset,
  });

  factory MatchedSubstring.fromJson(Map<String, dynamic> json) =>
      MatchedSubstring(
        length: json['length'],
        offset: json['offset'],
      );
  int? length;
  int? offset;

  Map<String, dynamic> toJson() => {
        'length': length,
        'offset': offset,
      };
}

class StructuredFormatting {
  StructuredFormatting({
    this.mainText,
    this.mainTextMatchedSubstrings,
    this.secondaryText,
  });

  factory StructuredFormatting.fromJson(Map<String, dynamic> json) =>
      StructuredFormatting(
        mainText: json['main_text'],
        mainTextMatchedSubstrings: json['main_text_matched_substrings'] == null
            ? []
            : List<MatchedSubstring>.from(
                json['main_text_matched_substrings']!
                    .map((x) => MatchedSubstring.fromJson(x)),
              ),
        secondaryText: json['secondary_text'],
      );
  String? mainText;
  List<MatchedSubstring>? mainTextMatchedSubstrings;
  String? secondaryText;

  Map<String, dynamic> toJson() => {
        'main_text': mainText,
        'main_text_matched_substrings': mainTextMatchedSubstrings == null
            ? []
            : List<dynamic>.from(
                mainTextMatchedSubstrings!.map((x) => x.toJson()),
              ),
        'secondary_text': secondaryText,
      };
}

class Term {
  Term({
    this.offset,
    this.value,
  });

  factory Term.fromJson(Map<String, dynamic> json) => Term(
        offset: json['offset'],
        value: json['value'],
      );
  int? offset;
  String? value;

  Map<String, dynamic> toJson() => {
        'offset': offset,
        'value': value,
      };
}
