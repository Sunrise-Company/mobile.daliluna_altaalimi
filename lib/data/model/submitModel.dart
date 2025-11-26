// To parse this JSON data, do
//
//     final submit = submitFromJson(jsonString);

import 'dart:convert';

List<Submit> submitFromJson(String str) => List<Submit>.from(json.decode(str).map((x) => Submit.fromJson(x)));

String submitToJson(List<Submit> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Submit {
    Submit({
        required this.id,
        required this.answer,
    });

    String id;
    List<String> answer;

    factory Submit.fromJson(Map<String, dynamic> json) => Submit(
        id: json["id"],
        answer: List<String>.from(json["answer"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
      
        id: List<dynamic>.from(answer.map((x) => x)),
    };
}
