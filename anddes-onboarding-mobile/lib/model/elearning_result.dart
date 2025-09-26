class ELearningResult{

  double? result;

  ELearningResult({this.result});

  static fromJson(Map<String, dynamic> json) => ELearningResult(
  result: json['result']!=null?(json['result'] as num).toDouble():null);

  Map<String, dynamic> toJson() => <String, dynamic> { 'result' : result };
}
