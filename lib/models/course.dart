part of 'models.dart';

class Course {
  String title;
  String description;
  String? image;
  String video;
  String username;
  List<String> paragraphs;
  List<Quiz> quiz;

  Course(this.title, this.description, this.image, this.username, this.video, this.paragraphs, this.quiz);
}