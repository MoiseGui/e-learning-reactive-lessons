class Quiz {
  String text;
  Duration beginTime;
  Duration endTime;
  bool? shown = false;
  bool? passed = false;

  Quiz(this.text, this.beginTime, this.endTime);

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
}