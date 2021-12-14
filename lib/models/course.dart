part of 'models.dart';

class Course {
  String _id;
  String title;
  String description;
  String? image;
  String video;
  String? username;
  String  categoryId;
  List<String> paragraphs;
  List<Quiz> quiz;

  Course(this._id, this.title, this.description, this.image, this.username, this.categoryId, this.video, this.paragraphs, this.quiz);

  static Course parse(data){
    var allQuiz = data['quiz'];
    List<Quiz> quiz = [];
    for(var singleQuiz in allQuiz){
      var choiceList = singleQuiz['choices'];
      List<Choice> choices = [];
      for(var choice in choiceList){
        choices.add(Choice(choice['text'], choice['correct'], choice['order']));
      }
      quiz.add(Quiz(singleQuiz['question'].toString(), Duration(seconds: singleQuiz['beginTime']), Duration(seconds: singleQuiz['endTime']), singleQuiz['uniqueChoice'], choices));
    }
    List<String> paragraphs = [];

    for(var para in data["paragraphs"]){
      paragraphs.add(para);
    }

    return Course(data['_id'].toString(), data['title'].toString(), data['description'].toString(), data['image'].toString(), data['username'].toString(), data['categoryId'].toString(), data['video'].toString(), paragraphs, quiz);
  }
}