class AnswerModel {
  int? questionid;
  List<String>? answer;
  List<bool>? answerstate;

  AnswerModel() {}
  answeradd(String s) {
    this.answer!.add(s);
  }
}
