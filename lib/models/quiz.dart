part of 'models.dart';

class Quiz {
  String question;
  Duration beginTime;
  Duration endTime;
  bool uniqueChoice;
  List<Choice> choices;
  List<Reponse> responses;

  bool? shown = false;
  bool? passed = false;


  Quiz(this.question, this.beginTime, this.endTime, this.uniqueChoice, this.choices, this.responses);

  bool? isShown(){
    return shown;
  }

  void setShown(bool value){
    shown = value;
  }

  bool? isPassed(){
    return passed;
  }

  void setPassed(bool value){
    passed = value;
  }

  Choice findChoiceByOrder(int order){
    return choices.firstWhere((element) => element.order == order);
  }
}