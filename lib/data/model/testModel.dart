class TestModel {
  List<Questions>? questions;
  var exam_period;

  TestModel({this.questions, this.exam_period});

  TestModel.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      questions = <Questions>[];
      json['questions'].forEach((v) {
        questions!.add(new Questions.fromJson(v));
      });
    }
    exam_period = json['exam_period'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();

    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    data['exam_period'] = this.exam_period;

    return data;
  }
}

class Questions {
  int? id;
  String? questionForm;

  int? quesType;

  Option? option;

  Section? section;
  Lesson? lesson;

  Questions(
      {this.id, this.questionForm, this.quesType, this.option, this.section,this.lesson});

  Questions.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionForm = json['question_form'];

    quesType = json['ques_type'];

    option =
        json['option'] != null ? new Option.fromJson(json['option']) : null;
    section =
        json['section'] != null ? new Section.fromJson(json['section']) : null;

        lesson =
        json['lesson'] != null ? new Lesson.fromJson(json['lesson']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_form'] = this.questionForm;

    data['ques_type'] = this.quesType;

    if (this.option != null) {
      data['option'] = this.option!.toJson();
    }
    if (this.section != null) {
      data['section'] = this.section!.toJson();
    }
        if (this.lesson != null) {
      data['lesson'] = this.lesson!.toJson();
    }
    return data;
  }
}

class Option {
  int? id;
  int? questionId;
  String? myOptions;
  String? createdAt;
  String? updatedAt;

  Option(
      {this.id,
      this.questionId,
      this.myOptions,
      this.createdAt,
      this.updatedAt});

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    myOptions = json['myOptions'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['question_id'] = this.questionId;
    data['myOptions'] = this.myOptions;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}

class Section {
  int? id;
  String? title;
  int? type;
  String? content;

  Section({
    this.id,
    this.title,
    this.type,
    this.content,
  });

  Section.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    title = json['title'];
    type = json['type'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    data['title'] = this.title;
    data['type'] = this.type;
    data['content'] = this.content;

    return data;
  }
}

class Lesson {
  int? id;
  String? isEnglish;

  Lesson({
    this.id,
    this.isEnglish,
  });

  Lesson.fromJson(Map<String, dynamic> json) {
    id = json['id'];

    isEnglish = json['isEnglish'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;

    data['isEnglish'] = this.isEnglish;

    return data;
  }
}
