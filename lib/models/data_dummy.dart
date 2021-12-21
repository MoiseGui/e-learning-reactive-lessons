part of 'models.dart';

// class VideoQuiz {
//   List<int> secs = [1, 30, 73];
//   List<String> choiceTexts = ["Modelisation", "Vue", "Controlleur"];
//   List<Quiz> videoQuiz = [];
//
//   VideoQuiz() {
//     for (int i = 0; i < secs.length; i++) {
//       List<Choice> choices = [];
//       for (int j = 0; j < choiceTexts.length; j++) {
//         Choice choice = Choice(choiceTexts[j], j == 0 ? true : false, j + 1);
//         choices.add(choice);
//       }
//       Quiz quiz = Quiz(
//           "Qu'est ce qui ne fait pas partie du MVC ?",
//           Duration(seconds: secs[i]),
//           Duration(seconds: secs[i] + 10),
//           true,
//           choices);
//       videoQuiz.add(quiz);
//     }
//   }
//
//   String removeMillis(Duration duration) {
//     return duration.toString().split('.')[0];
//   }
//
//   int compareDurations(Duration d1, Duration d2) {
//     return removeMillis(d1).compareTo(removeMillis(d2));
//   }
//
//   Quiz? getQuizByMoment(Duration duration, bool careIfShown) {
//     Quiz? quizFound;
//     for (var quiz in videoQuiz) {
//       print("hey ${duration} ${quiz.endTime}");
//       if (compareDurations(quiz.endTime, duration) == 0) {
//         if (!quiz.isShown()!) {
//           quiz.setShown(true);
//           quizFound = quiz;
//           print("Video isshown ${quiz.isShown()}");
//           break;
//         } else {
//           if (!careIfShown) {
//             quizFound = quiz;
//             print("Video isshown ${quiz.isShown()}");
//             break;
//           }
//         }
//       }
//     }
//     return quizFound;
//   }
// }

class DataDummy {
  List<Course> courses = [
    Course(
      "1b485d0826897dcd20698b",
        BigInt.zero,
        "Le modèle MVC",
        'Vous avez déjà fait vos premiers pas en PHP... Félicitations, il est maintenant temps d\'apprendre à marcher pour de bon !',
        'https://image.freepik.com/free-vector/developer-laptop-computer-with-open-robotic-soft-open-automation-architecture-open-source-robotics-soft-free-development-concept-bright-vibrant-violet-isolated-illustration_335657-474.jpg',
        "MoiseGui",
        "61b4d0bbaaa5dd729dce4722",
        "https://www.youtube.com/watch?v=6bzqaG2vPZs", [],
        [
          Quiz("Qu'est ce qui ne fait pas partie du MVC ?", Duration(seconds: 3),
              Duration(seconds: 5), true,
              [
                Choice("Modelisation", true, 1),
                Choice("Vue", false, 2),
                Choice("Controlleur", false, 3),
              ], []),
        ]
    ),
    Course(
        "1b485d0826897dcd20698b",
        BigInt.zero,
        "Machine Learning",
        'Vous êtes intéressé par la Data Science et vous cherchez une porte d\'entrée vers ce domaine en plein essor ? Ce cours d\'initiation au Machine Learning est fait pour vous !',
        "https://image.freepik.com/free-vector/wireframe-robot-ai-artificial-intelligence-form-cyborg-bot-brain-robotic-hand-digital-brain_127544-853.jpg",
        "MoiseGui",
        "61b4d0bbaaa5dd729dce4722",
        "https://youtu.be/EUD07IiviJg", [],
        [
          Quiz("Qu'est ce qui fait partie du MVC ?", Duration(seconds: 3),
              Duration(seconds: 5), false,
              [
                Choice("Modèle", true, 1),
                Choice("Véhicule", false, 2),
                Choice("Controlleur", true, 3),
              ], []),
        ]
    ),
    Course(
        "1b485d0826897dcd20698b",
        BigInt.zero,
        "Neural Network",
        'Avez-vous déjà entendu parler d’AlphaZero ? Il s’agit de la super intelligence artificielle de DeepMind, une filiale de Google, capable de battre les meilleurs joueurs de Go au monde !',
        "https://image.freepik.com/free-vector/blue-neural-network-illustration_53876-78755.jpg",
        "MoiseGui",
        "61b4d0bbaaa5dd729dce4722",
        "https://www.youtube.com/watch?v=bfmFfD2RIcg", [], []),
    Course(
        "1b485d0826897dcd20698b",
        BigInt.zero,
        "Java",
        'Pour créer des programmes informatiques ou concevoir l\'application de vos rêves, vous devez savoir coder dans un langage de programmation. Les programmes s\'appuient sur des données et sur la logique pour fonctionner. Pour cela, un programmeur (vous !) doit dire à l\'ordinateur ce qu\'il doit faire et comment il doit le faire.',
        "https://image.freepik.com/free-photo/computer-program-coding-screen_53876-138060.jpg",
        "MoiseGui",
        "61b4d0bbaaa5dd729dce4722",
        "https://www.youtube.com/watch?v=XgVADKKb4jI", [], []),
    Course(
        "1b485d0826897dcd20698b",
        BigInt.zero,
        "Flutter",
        'Dans le cours \“Développez votre première application Android\”, vous avez appris les bases pour créer une application simple mais efficace. Cependant, malgré la joie immense et la satisfaction quasi-divine que cette mini-app\' vous procure, vous souhaitez en savoir un peu plus sur la création d’interface utilisateur sur Android (aaaah la soif de savoir ne s’arrête jamais !).',
        "https://image.freepik.com/free-vector/workout-tracker-app-interface_23-2148653679.jpg",
        "MoiseGui",
        "61b4d0bbaaa5dd729dce4722",
        "https://www.youtube.com/watch?v=I9ceqw5Ny-4&pp=ugMICgJmchABGAE%3D",
        [],
        []),
  ];

  // DataDummy() {
  //   VideoQuiz videoQuiz = VideoQuiz();
  //   // list of quiz
  //   courses.first.quiz = videoQuiz.videoQuiz;
  // }
}
