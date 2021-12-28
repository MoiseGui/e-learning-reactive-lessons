part of 'models.dart';

class Course {
  String id;
  BigInt numViews;
  String title;
  String description;
  String? image;
  String video;
  String? username;
  String  categoryId;
  List<String> paragraphs;
  List<Quiz> quiz;

  Course(this.id, this.numViews, this.title, this.description, this.image, this.username, this.categoryId, this.video, this.paragraphs, this.quiz);


  static Course parse(data){
    var allQuiz = data['quiz'];
    List<Quiz> quiz = [];
    for(var singleQuiz in allQuiz){
      var choiceList = singleQuiz['choices'];
      List<Choice> choices = [];
      for(var choice in choiceList){
        choices.add(Choice(choice['text'], choice['correct'], choice['order']));
      }

      var responseList = singleQuiz['responses'];
      List<Reponse> responses = [];
      for(var resp in responseList){
        responses.add(Reponse(resp['name'], resp['correct']));
      }

      quiz.add(Quiz(singleQuiz['question'].toString(), Duration(seconds: singleQuiz['beginTime']), Duration(seconds: singleQuiz['endTime']), singleQuiz['uniqueChoice'], choices, responses));
    }
    List<String> paragraphs = [];

    for(var para in data["paragraphs"]){
      paragraphs.add(para);
    }

    return Course(data['_id'].toString(), BigInt.from(data['numViews']), data['title'].toString(), data['description'].toString(), data['image'].toString(), data['username'].toString(), data['categoryId'].toString(), data['video'].toString(), paragraphs, quiz);
  }
}