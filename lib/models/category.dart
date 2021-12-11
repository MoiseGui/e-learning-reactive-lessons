part of 'models.dart';

class Category{
  String _id;
  String title;
  String description;


  Category(this._id, this.title, this.description);

  String get id => _id;

  set id(String value) {
    _id = value;
  }

  static Category parse(data){
    return Category(data['_id'].toString(), data['title'].toString(), data['description'] == null ? '' : data['description'].toString());
  }
}