class QuizFile {
  String qeustions;
  String type;
  List<String> answer;
  List<String> correct_order;
  dynamic content;
  String type_answer;
  String qeustions_one;
  QuizFile({
    required this.qeustions,
    required this.answer,
    required this.type,
    required this.qeustions_one,
    required this.content,
    required this.type_answer,
    required this.correct_order,
  });
}

List<QuizFile> qeustions = [
  QuizFile(
    qeustions: "حمل ملف الامتحان ",
    type: "text",
    qeustions_one: "حمل ملف الامتحان ",
    type_answer: "file",
    content: "",
    answer: [],
    correct_order: [],
  ),

  QuizFile(
    qeustions: "المهمة الرئيسية في طبقة النقل؟",
    qeustions_one: "",
    type_answer: "dragdrop",
    content: "",
    type: "text",
    answer: [
      "طبقة الإيثرنت ",
      "طبقة IP",
      "الطبقة الفيزيائية",
      "طبقة ترابط المعطيات",
    ],

    correct_order: [
      "الطبقة الفيزيائية",
      "طبقة ترابط المعطيات",
      "طبقة IP",
      "طبقة الإيثرنت ",
    ],
  ),
  QuizFile(
    qeustions: "أهم ميزات النموذج الحلزوني؟",
    type: "text",
    content: "",
    type_answer: "radio",
    qeustions_one: "",
    answer: ["إدارة المخاطر  ", "تحليل المتطلبات ", " إدارة الجودة"],
    correct_order: [],
  ),
  QuizFile(
    qeustions:
        " لدينا الكود  for(i=0;i<5;i++)for(i=0;i<n*ni++)ما هو تعقيد الكود التالي ؟",
    type: "paragraph",
    qeustions_one: "أقرأ النص التالي وجاوب عليه:",
    type_answer: "radioImage",
    content: "",
    answer: ["assets/p1.jpg", "assets/p2.jpg", "assets/p3.jpg"],
    correct_order: [],
  ),
  QuizFile(
    qeustions: "ما هي فئات البرامج المهمة؟",
    type: "paragraph",
    qeustions_one: " استمع للتسجيل ثم جاوب على السؤال",
    type_answer: "checkbox",
    content: "https://www.soundjay.com/nature/sounds/rain-01.mp3",
    answer: ["o(n)   ", " o(n^2)  ", " O(5)  "],
    correct_order: [],
  ),
  QuizFile(
    qeustions: "ما هي فئات البرامج المهمة؟",
    type: "text",
    qeustions_one: " استمع للتسجيل ثم جاوب على السؤال",
    type_answer: "checkboxImage",
    content: "https://www.soundjay.com/nature/sounds/rain-01.mp3",
    answer: ["assets/p1.jpg", "assets/p2.jpg", "assets/p3.jpg"],
    correct_order: [],
  ),
];

class Quiz {
  String name;
  String starttime;
  String endtime;
  String date;
  String statuse;
  List<QuizFile> qeustions;
  // List<QuizAnswer>answer;

  Quiz({
    required this.name,
    required this.starttime,
    required this.endtime,
    required this.date,
    required this.statuse,
    required this.qeustions,
  });
}

List<Quiz> exam = [
  Quiz(
    name: "امتحان مادة الهندسة ",
    starttime: "10:00",
    endtime: "11:30",
    date: '2024/5/5',
    statuse: 'لم يبدأ بعد',
    qeustions: [
      QuizFile(
        qeustions: "حمل ملف الامتحان ",
        type: "text",
        qeustions_one: "حمل ملف الامتحان ",
        type_answer: "file",
        content: "",
        answer: [],
        correct_order: [],
      ),

      QuizFile(
        qeustions: "المهمة الرئيسية في طبقة النقل؟",
        qeustions_one: "",
        type_answer: "dragdrop",
        content: "",
        type: "text",
        answer: [
          "طبقة الإيثرنت ",
          "طبقة IP",
          "الطبقة الفيزيائية",
          "طبقة ترابط المعطيات",
        ],

        correct_order: [
          "الطبقة الفيزيائية",
          "طبقة ترابط المعطيات",
          "طبقة IP",
          "طبقة الإيثرنت ",
        ],
      ),
      QuizFile(
        qeustions: "أهم ميزات النموذج الحلزوني؟",
        type: "text",
        content: "",
        type_answer: "radio",
        qeustions_one: "",
        answer: ["إدارة المخاطر  ", "تحليل المتطلبات ", " إدارة الجودة"],
        correct_order: [],
      ),
      QuizFile(
        qeustions:
            " لدينا الكود  for(i=0;i<5;i++)for(i=0;i<n*ni++)ما هو تعقيد الكود التالي ؟",
        type: "paragraph",
        qeustions_one: "أقرأ النص التالي وجاوب عليه:",
        type_answer: "radioImage",
        content: "",
        answer: ["assets/p1.jpg", "assets/p2.jpg", "assets/p3.jpg"],
        correct_order: [],
      ),
      QuizFile(
        qeustions: "ما هي فئات البرامج المهمة؟",
        type: "paragraph",
        qeustions_one: " استمع للتسجيل ثم جاوب على السؤال",
        type_answer: "checkbox",
        content: "https://www.soundjay.com/nature/sounds/rain-01.mp3",
        answer: ["o(n)   ", " o(n^2)  ", " O(5)  "],
        correct_order: [],
      ),
      QuizFile(
        qeustions: "ما هي فئات البرامج المهمة؟",
        type: "text",
        qeustions_one: " استمع للتسجيل ثم جاوب على السؤال",
        type_answer: "checkboxImage",
        content: "https://www.soundjay.com/nature/sounds/rain-01.mp3",
        answer: ["assets/p1.jpg", "assets/p2.jpg", "assets/p3.jpg"],
        correct_order: [],
      ),
      QuizFile(
        qeustions: "حمل ملف الامتحان ",
        type: "text",
        qeustions_one: "حمل ملف الامتحان ",
        type_answer: "file",
        content: "",
        answer: [],
        correct_order: [],
      ),
      QuizFile(
        qeustions: "اصل العبارات الصحيحة الرئيسية في طبقة النقل؟",
        qeustions_one: "",
        type_answer: "matching",
        content: "",
        type: "text",
        answer: [
          "طبقة الإيثرنت ",
          "طبقة IP",
          "الطبقة الفيزيائية",
          "طبقة ترابط المعطيات",
        ],
        correct_order: [
          "طبقة السابعة ",
          "الطبقة الخامسة",
          "الطبقة الفيزيائية",
          "طبقة datat link ",
        ],
      ),
      QuizFile(
        qeustions: "المهمة الرئيسية في طبقة الشبكة؟",
        qeustions_one: "",
        type_answer: "gridcheckbox",
        content: "",
        type: "text",
        answer: [
          " نقل الارسال من المصدر إلى الوجهة ",
          " نقل المعطيات فيزائيا",
          "طبقة ترابط المعطيات",
        ],
        correct_order: [],
      ),
      QuizFile(
        qeustions: "المهمة الرئيسية في طبقة راديو",
        qeustions_one: "",
        type_answer: "gridradio",
        content: "",
        type: "text",
        answer: [
          " نقل الارسال من المصدر إلى الوجهة ",
          " نقل المعطيات فيزائيا",
          "طبقة ترابط المعطيات",
        ],
        correct_order: [],
      ),
      QuizFile(
        qeustions: "جاوب عن السؤال التقليدي التالي",
        qeustions_one: "",
        type_answer: "textfield",
        content: "",
        type: "paragraph",
        answer: [],
        correct_order: [],
      ),
    ],
  ),
  Quiz(
    name: "امتحان مادة الشبكات ",
    starttime: "11:00",
    endtime: "12:30",
    date: '2024/4/29',
    statuse: 'جاري الآن ',
    qeustions: [
      QuizFile(
        qeustions: "جاوب عن السؤال التقليدي التالي",
        qeustions_one: "",
        type_answer: "textfield",
        content: "",
        type: "paragraph",
        answer: [],
        correct_order: [],
      ),
    ],
  ),
  Quiz(
    name: "امتحان مادة الأمن  ",
    starttime: "13:00",
    endtime: "14:30",
    date: '2024/5/20',
    statuse: 'جاري الآن',
    qeustions: [
      QuizFile(
        qeustions: "جاوب عن السؤال التقليدي التالي",
        qeustions_one: "",
        type_answer: "textfield",
        content: "",
        type: "paragraph",
        answer: [],
        correct_order: [],
      ),
    ],
  ),
  Quiz(
    name: "امتحان مادة الذكاء  ",
    starttime: "10:00",
    endtime: "11:30",
    date: '2024/4/28',
    statuse: ' لم ينتهي بعد',
    qeustions: [
      QuizFile(
        qeustions: "المهمة الرئيسية في طبقة الشبكة؟",
        qeustions_one: "",
        type_answer: "checkbox",
        content: "",
        type: "text",
        answer: [
          " نقل الارسال من المصدر إلى الوجهة ",
          " نقل المعطيات فيزائيا",
          "طبقة ترابط المعطيات",
        ],
        correct_order: [],
      ),
    ],
  ),
];
