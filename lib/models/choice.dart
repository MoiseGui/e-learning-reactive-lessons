part of 'models.dart';

class Choice{
  int order;
  String text;
  bool correct;

  Choice(this.text, this.correct, this.order);

  Map toJson() => {
    "order": order.toString(),
    "text": text,
    "correct": correct.toString()
  };
}