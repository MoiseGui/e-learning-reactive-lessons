part of 'models.dart';

class Reponse{
  String name;
  bool correct;
  int? beginTime;

  Reponse(this.name, this.correct);

  Reponse.all(this.name, this.correct, this.beginTime);

  Map toJson() => {
    "name": name,
    "correct": correct,
    "beginTime": beginTime.toString()
  };
}