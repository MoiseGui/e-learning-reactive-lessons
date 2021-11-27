part of 'models.dart';

class DataDummy {
  List<Course> courses = [
    Course(
        "Le modèle MVC",
        "https://image.freepik.com/free-photo/close-up-image-programer-working-his-desk-office_1098-18707.jpg",
        "MoiseGui",
        mainColor),
    Course(
        "Machine Learning",
        "https://image.freepik.com/free-photo/close-up-image-programer-working-his-desk-office_1098-18707.jpg",
        "MoiseGui",
        mainColor),
    Course(
        "Neural Network",
        "https://image.freepik.com/free-vector/blue-neural-network-illustration_53876-78755.jpg",
        "MoiseGui",
        Colors.purple[200]),
    Course(
        "Java",
        "https://image.freepik.com/free-photo/close-up-image-programer-working-his-desk-office_1098-18707.jpg",
        "MoiseGui",
        successColor),
    Course(
        "Flutter",
        "https://image.freepik.com/free-photo/rear-view-programmer-working-all-night-long_1098-18697.jpg",
        "MoiseGui",
        textNumberColor),
  ];
  List<String> titles = [
    "Machine Learning",
    "Neural Network",
    "Java",
    "Flutter"
  ];

  List<Color?> colors = [
    mainColor,
    secondColor,
    successColor,
    errorColor,
    textNumberColor,
    Colors.purple[200]
  ];
}

class VideoQuiz {
  List<int> secs = [1, 30, 73];
  List<Quiz> videoQuiz = [];

  VideoQuiz() {
    for (int i = 0; i < secs.length; i++) {
      Quiz quiz = Quiz("quiz", Duration(seconds: secs[i]),
          Duration(seconds: secs[i] + 10));
      videoQuiz.add(quiz);
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
    for (var quiz in videoQuiz) {
    print("hey ${duration} ${quiz.endTime}");
      if (compareDurations(quiz.endTime, duration) == 0) {
        if(!quiz.isShown()!){
          quiz.setShown(true);
          quizFound = quiz;
          print("Video isshown ${quiz.isShown()}");
          break;
        }
        else{
          if(!careIfShown){
            quizFound = quiz;
            print("Video isshown ${quiz.isShown()}");
            break;
          }
        }
      }
    }
    return quizFound;
  }
}
