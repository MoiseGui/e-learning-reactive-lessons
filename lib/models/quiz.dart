//TODO: Add the form information here
//TODO: Question title, Question choices, unique or multiple answer ?, correct answer(s)
import 'package:elearning/models/choice.dart';

class Quiz {
  String question;
  Duration beginTime;
  Duration endTime;
  bool uniqueChoice;
  List<Choice> choices;

  bool? shown = false;
  bool? passed = false;


  Quiz(this.question, this.beginTime, this.endTime, this.uniqueChoice, this.choices);

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