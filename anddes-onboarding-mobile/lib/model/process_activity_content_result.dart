import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class ProcessActivityContentResult{
  double result;

  ProcessActivityContentResult({required this.result});

  static fromJson(Map<String, dynamic> json) => ProcessActivityContentResult(
      result: json['result'] as double);
}
