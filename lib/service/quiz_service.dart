part of 'services.dart';

class QuizService{
  List<Quiz> quizList;

  QuizService(this.quizList){
    this.quizList = quizList;

    // reset all to not shown
    for(Quiz quiz in quizList){
      quiz.setShown(false);
    }
  }

  String removeMillis(Duration duration){
    return duration.toString().split('.')[0];
  }

  int compareDurations(Duration d1, Duration d2){
    return removeMillis(d1).compareTo(removeMillis(d2));
  }

  Quiz? getQuizByMoment(Duration duration, bool careIfShown) {
    Quiz? quizFound;
    for (var quiz in quizList) {
      if (compareDurations(quiz.endTime, duration) == 0) {
        if(!quiz.isShown()!){
          quiz.setShown(true);
          quizFound = quiz;
          break;
        }
        else{
          if(!careIfShown){
            quizFound = quiz;
            break;
          }
        }
      }
    }
    return quizFound;
  }
}