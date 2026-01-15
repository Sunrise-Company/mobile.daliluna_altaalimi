class ShowTestModel {
  List<Question>? questions;
  Exam? exam;
  ExamResult? examResult;
  int? contentId;
  String? lessonName;
  String? roomName;
  String? termName;
  var examPeriod;
  var studentResult;
  String? year;
  String? city;
  int? status;
  int? exaacademyv3ark;

  ShowTestModel({
    this.questions,
    this.exam,
    this.examResult,
    this.contentId,
    this.lessonName,
    this.roomName,
    this.termName,
    this.examPeriod,
    this.studentResult,
    this.year,
    this.city,
    this.status,
    this.exaacademyv3ark,
  });

  ShowTestModel.fromJson(Map<String, dynamic> json) {
    if (json['questions'] != null) {
      questions = [];
      json['questions'].forEach((v) {
        questions!.add(Question.fromJson(v));
      });
    }
    exam = json['exam'] != null ? Exam.fromJson(json['exam']) : null;
    examResult = json['exam_result'] != null
        ? ExamResult.fromJson(json['exam_result'])
        : null;
    contentId = json['content_id'];
    lessonName = json['lesson_name'];
    roomName = json['room_name'];
    termName = json['term_name'];
    examPeriod = json['exam_period'];
    studentResult = json['student_result'];
    year = json['year'];
    city = json['city'];
    status = json['status'];
    exaacademyv3ark = json['mark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (this.questions != null) {
      data['questions'] = this.questions!.map((v) => v.toJson()).toList();
    }
    if (this.exam != null) {
      data['exam'] = this.exam!.toJson();
    }
    if (this.examResult != null) {
      data['exam_result'] = this.examResult!.toJson();
    }
    data['content_id'] = this.contentId;
    data['lesson_name'] = this.lessonName;
    data['room_name'] = this.roomName;
    data['term_name'] = this.termName;
    data['exam_period'] = this.examPeriod;
    data['student_result'] = this.studentResult;
    data['year'] = this.year;
    data['city'] = this.city;
    data['status'] = this.status;
    data['mark'] = this.exaacademyv3ark;

    return data;
  }
}

class Question {
  int? id;
  String? questionForm;
  String? answer;
  double? mark;
  double? studentMark; // Adjusted variable name for consistency
  String? note;
  int? quesType; // Question type
  int? classId; // Class ID
  int? sectionId; // Section ID
  int? lectureId; // Lecture ID
  int? lessonId; // Lesson ID
  int? teacherId; // Teacher ID
  int? coorId; // Coordinator ID
  String? createdAt; // Creation timestamp
  String? updatedAt; // Update timestamp
  var deservedMark; // Deserved mark
  Option? option; // Associated options

  Question({
    this.id,
    this.questionForm,
    this.answer,
    this.mark,
    this.studentMark,
    this.note,
    this.quesType,
    this.classId,
    this.sectionId,
    this.lectureId,
    this.lessonId,
    this.teacherId,
    this.coorId,
    this.createdAt,
    this.updatedAt,
    this.deservedMark,
    this.option,
  });

  Question.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionForm = json['question_form'];
    answer = json['answer'];
    mark = double.tryParse(json['mark'].toString()) ?? 0.0;
    studentMark =
        double.tryParse(json['student_mark'].toString()) ??
        0.0; // Default to zero if not present
    note = json['note'];
    quesType = json['ques_type'];
    classId = json['class_id'];
    sectionId = json['section_id'];
    lectureId = json['lecture_id'];
    lessonId = json['lesson_id'];
    teacherId = json['teacher_id'];
    coorId = json['coor_id'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deservedMark = json['deserved_mark'];
    option = json['option'] != null ? Option.fromJson(json['option']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['question_form'] = questionForm;
    data['answer'] = answer;
    data['mark'] = mark;
    data['student_mark'] = studentMark;
    data['note'] = note;
    data['ques_type'] = quesType;
    data['class_id'] = classId;
    data['section_id'] = sectionId;
    data['lecture_id'] = lectureId;
    data['lesson_id'] = lessonId;
    data['teacher_id'] = teacherId;
    data['coor_id'] = coorId;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deserved_mark'] = deservedMark;

    if (option != null) {
      data['option'] = option!.toJson();
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

  Option({
    this.id,
    this.questionId,
    this.myOptions,
    this.createdAt,
    this.updatedAt,
  });

  Option.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    questionId = json['question_id'];
    myOptions = json['myOptions'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['question_id'] = questionId;
    data['myOptions'] = myOptions;
    return data;
  }
}

class Exam {
  int? mark;
  int? id;
  int? lessonId;
  int? teacherId;
  int? roomId;
  int? termId;
  var period;
  String? startTime;
  String? endTime;
  String? name;

  Exam({
    required this.mark,
    required this.id,
    required this.lessonId,
    required this.teacherId,
    required this.roomId,
    required this.termId,
    required this.period,
    required this.startTime,
    required this.endTime,
    required this.name,
  });

  Exam.fromJson(Map<String, dynamic> json) {
    mark = json['mark'];
    id = json['id'];
    lessonId = json['lesson_id'];
    teacherId = json['teacher_id'];
    roomId = json['room_id'];
    termId = json['term_id'];
    period = json['period'];
    startTime = json['start_time'];
    endTime = json['end_time'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['mark'] = mark;
    data['id'] = id;
    data['lesson_id'] = lessonId;
    data['teacher_id'] = teacherId;
    data['room_id'] = roomId;
    data['term_id'] = termId;
    data['period'] = period;
    data['start_time'] = startTime;
    data['end_time'] = endTime;
    data['name'] = name;

    return data;
  }
}

class ExamResult {
  int? id;
  int? classID;
  int? roomID;
  int? examID;
  int? userID;
  int? lessonID;
  String? selectedQues;
  String? userAnswers;
  String? result;
  String? traditionalResult;
  String? type;
  String? status;

  ExamResult({
    required this.id,
    required this.classID,
    required this.roomID,
    required this.examID,
    required this.userID,
    required this.lessonID,
    required this.selectedQues,
    required this.userAnswers,
    required this.result,
    required this.traditionalResult,
    required this.type,
    required this.status,
  });

  ExamResult.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    classID = json['class_id'];
    roomID = json['room_id'];
    examID = json['exam_id'];
    userID = json['user_id'];
    lessonID = json['lesson_id'];
    selectedQues = json['selected_ques'];
    userAnswers = json['user_answers'];
    result = json['result'];
    traditionalResult = json['traditional_result'];
    type = json['type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['id'] = id;
    data['class_id'] = classID;
    data['room_id'] = roomID;
    data['exam_id'] = examID;
    data['user_id'] = userID;
    data['lesson_id'] = lessonID;
    data['selected_ques'] = selectedQues;
    data['user_answers'] = userAnswers;
    data['result'] = result;
    data['traditional_result'] = traditionalResult;
    data['type'] = type;
    data['status'] = status;

    return data;
  }
}
