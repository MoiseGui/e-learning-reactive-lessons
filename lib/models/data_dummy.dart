part of 'models.dart';

class DataDummy {
  List<Course> courses = [
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
      Quiz quiz = Quiz("quiz ${i + 1}", Duration(seconds: secs[i]),
          Duration(seconds: secs[i] + 5));
      videoQuiz.add(quiz);
    }
  }
  
  String removeMillis(Duration duration){
    return duration.toString().split('.')[0];
  }

  Quiz? getQuizByMoment(Duration duration) {
    Quiz? quizFound;
    for (var quiz in videoQuiz) {
    print("hey ${duration} ${quiz.endTime}");
      if (removeMillis(quiz.endTime).compareTo(removeMillis(duration)) == 0 && ! quiz.isShown()!) {
        quiz.setShown(true);
        quizFound = quiz;
        print("Video isshown ${quiz.isShown()}");
        break;
      }
    }
    return quizFound;
  }
}
