import 'package:daliluna_altaalimi/modules/bindings/groupChatStudentBinig.dart';
import 'package:daliluna_altaalimi/modules/bindings/inialBinidig.dart';
import 'package:daliluna_altaalimi/modules/bindings/institutes_binding.dart';
import 'package:daliluna_altaalimi/modules/bindings/videoBinind.dart';
import 'package:daliluna_altaalimi/modules/bindings/videolecutreBinidg.dart';
import 'package:daliluna_altaalimi/modules/teacherBinding/chatTeacherBinig.dart';
import 'package:daliluna_altaalimi/modules/teacherBinding/chatteachergroupBinong.dart';
import 'package:daliluna_altaalimi/modules/teacherBinding/vidoeLEssonBinig.dart';
import 'package:daliluna_altaalimi/view/VideoLecture.dart';
import 'package:daliluna_altaalimi/view/VideoLessonso.dart';
import 'package:daliluna_altaalimi/view/firstpage.dart';
import 'package:daliluna_altaalimi/view/screen/chatstudent/gorupchatStudent.dart';
import 'package:daliluna_altaalimi/view/screen/chatstudent/listgroup.dart';
import 'package:daliluna_altaalimi/view/screen/exam/examsoltuions.dart';
import 'package:daliluna_altaalimi/view/screen/exam/test.dart';
import 'package:daliluna_altaalimi/view/teacher/chatTeacher/chatTeacher.dart';
import 'package:daliluna_altaalimi/view/teacher/chatTeacher/groupChat/groupChatTeacher.dart';
import 'package:daliluna_altaalimi/view/teacher/homepageTeacher.dart';
import 'package:daliluna_altaalimi/view/teacher/lectureTeacher.dart';
import 'package:daliluna_altaalimi/view/teacher/lessonTeacher.dart';
import 'package:daliluna_altaalimi/view/teacher/sutedntTeacher/listStudentForTeacher.dart';
import 'package:daliluna_altaalimi/view/teacher/unitTeacher.dart';
import 'package:daliluna_altaalimi/view/teacher/videoLessonTeacher.dart';
import 'package:daliluna_altaalimi/view/teacher/viewSection.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/routes.dart';
import 'package:daliluna_altaalimi/modules/bindings/auth/login_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/auth/register_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/basket_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/foundation_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/home_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/homepage_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/intensivelessons_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/lessondetails_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/lessons_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/lessonvedios_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/mycourselessons_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/mycourses_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/mycoursesections_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/mycourseteachers_controller.dart';
import 'package:daliluna_altaalimi/modules/bindings/mycourseunitssubject_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/notifications_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/ourcourseexams_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/pdfs_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/privacypolicy_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/sectionssubject_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/subjects_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/unitssubject_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/ourcoursesselected_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/search_binding.dart';
import 'package:daliluna_altaalimi/modules/bindings/sectionselected_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/teacher_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/vedios_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/vedioswithoutappbar_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/viewlesson_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/viewpdf_bindings.dart';
import 'package:daliluna_altaalimi/modules/bindings/viewvedio_bindings.dart';
import 'package:daliluna_altaalimi/view/screen/auth/login.dart';
import 'package:daliluna_altaalimi/view/screen/auth/register.dart';
import 'package:daliluna_altaalimi/view/screen/basket.dart';
import 'package:daliluna_altaalimi/view/screen/foundation.dart';
import 'package:daliluna_altaalimi/view/screen/home.dart';
import 'package:daliluna_altaalimi/view/screen/homepage.dart';
import 'package:daliluna_altaalimi/view/screen/intensivelessons.dart';
import 'package:daliluna_altaalimi/view/screen/institutes.dart';
import 'package:daliluna_altaalimi/view/screen/lessondetails.dart';
import 'package:daliluna_altaalimi/view/screen/lessons.dart';
import 'package:daliluna_altaalimi/view/screen/lessonvedios.dart';
import 'package:daliluna_altaalimi/view/screen/mycourselessons.dart';
import 'package:daliluna_altaalimi/view/screen/mycourses.dart';
import 'package:daliluna_altaalimi/view/screen/mycourseteachers.dart';
import 'package:daliluna_altaalimi/view/screen/search_screen.dart';
import 'package:daliluna_altaalimi/view/screen/mycourseunitssubject.dart';
import 'package:daliluna_altaalimi/view/screen/mycousesections.dart';
import 'package:daliluna_altaalimi/view/screen/mylessons.dart';
import 'package:daliluna_altaalimi/view/screen/mysectionselected.dart';
import 'package:daliluna_altaalimi/view/screen/mysectionssubject.dart';
import 'package:daliluna_altaalimi/view/screen/mysubjects.dart';
import 'package:daliluna_altaalimi/view/screen/myteacher.dart';
import 'package:daliluna_altaalimi/view/screen/notifications.dart';
import 'package:daliluna_altaalimi/view/screen/ourcourseexams.dart';
import 'package:daliluna_altaalimi/view/screen/ourcourses.dart';
import 'package:daliluna_altaalimi/view/screen/pdfs.dart';
import 'package:daliluna_altaalimi/view/screen/privacypolicy.dart';
import 'package:daliluna_altaalimi/view/screen/sectionssubject.dart';
import 'package:daliluna_altaalimi/view/screen/subjects.dart';
import 'package:daliluna_altaalimi/view/screen/myunitssubject.dart';
import 'package:daliluna_altaalimi/view/screen/unitssubject.dart';
import 'package:daliluna_altaalimi/view/screen/ourcoursesselected.dart';
import 'package:daliluna_altaalimi/view/screen/sectionselected.dart';
import 'package:daliluna_altaalimi/view/screen/teacher.dart';
import 'package:daliluna_altaalimi/view/screen/vedios.dart';
import 'package:daliluna_altaalimi/view/screen/vedioswithoutappbar.dart';
import 'package:daliluna_altaalimi/view/screen/viewlesson.dart';
import 'package:daliluna_altaalimi/view/screen/viewpdf.dart';
import 'package:daliluna_altaalimi/view/screen/viewvideo.dart';
import 'modules/bindings/exam/examSoltionsBinding.dart';
import 'modules/bindings/exam/startExamBinding.dart';
import 'modules/teacherBinding/fileTeacherBinding.dart';
import 'modules/teacherBinding/homePageTeacherBinding.dart';
import 'modules/teacherBinding/lecutreTeacherBinding.dart';
import 'modules/teacherBinding/lessonDepsBinding.dart';
import 'modules/teacherBinding/teacherUnitBindig.dart';
import 'modules/teacherBinding/teacherstudentBinding.dart';

List<GetPage<dynamic>>? routes = [
  GetPage(
    name: '/homepageTeacher',
    binding: HomePageTeacherBinding(),
    page: () => HomePageTeacher(),
  ),

  GetPage(
    name: '/VideoLessonso',
    binding: ViideoBinding(),
    page: () => VideoLessons(),
  ),
  GetPage(
    name: '/videoLessonTeacher',
    binding: VidoeTeaherBinding(),
    page: () => VediosTeacherLesson(),
  ),

  GetPage(
    name: '/',
    binding: InialHomePageBinding(),
    page: () => FirstPageTeacher(),
  ),
  GetPage(
    name: '/homepage',
    binding: HomePageBinding(),
    page: () => HomePage(),
  ),
  GetPage(
    name: '/lessonTeacher',
    binding: LessonDespsTeacherBinding(),
    page: () => LessonTeacher(),
  ),

  GetPage(
    name: '/unitTeacher',
    binding: UnitTeacherBinding(),
    page: () => UnitTeacher(),
  ),
  GetPage(
    name: '/VideoLecture',
    binding: VideoLecutresBinding(),
    page: () => VideoLecture(),
  ),
  GetPage(
    name: '/gorupchatStudent',
    binding: GroupChatStudentBinding(),
    page: () => GroupChatPageStudent(),
  ),
  GetPage(
    name: '/chatTeacher',
    binding: ChatTeacherBinding(),
    page: () => ChatPage(),
  ),
  GetPage(
    name: '/groupChatTeacher',
    binding: ChatTeacherGroupBinding(),
    page: () => GroupChatPageTeacher(),
  ),
  GetPage(
    name: '/lectureTeacher',
    binding: LectureTeacherBinding(),
    page: () => LecutreTeacher(),
  ),

  GetPage(
    name: '/viewSection',
    binding: FileTeacherBinding(),
    page: () => ViewSectionTeacher(),
  ),

  GetPage(
    name: '/listStudentForTeacher',
    binding: TeacherListStudentBinding(),
    page: () => ListStudentTeacher(),
  ),

  // GetPage(
  //   name: '/videoplayeryoutube',
  //   binding: VideoPyaerYoutubeBinding(),
  //   page: () => YouTubeVideo(),
  // ),
  GetPage(
    name: AppRoute.ourCourses,
    // binding: OurCoursesBinding(),
    page: () => OurCoursesPage(),
  ),
  GetPage(
    name: AppRoute.institutes,
    binding: InstitutesBinding(),
    page: () => const InstitutesPage(),
  ),

  GetPage(
    name: '/examsoltuions',
    binding: ExamSolutionsBinding(),
    page: () => SoltionsScreen(),
  ),
  GetPage(name: '/test', binding: StartExamBinding(), page: () => testPage()),
  GetPage(
    name: '/GroupChatListPageStudent',
    // binding: StartExamBinding(),
    page: () => GroupChatListPageStudent(),
  ),
  GetPage(
    name: AppRoute.ourCoursesSelected,
    binding: OurCoursesSelectedBinding(),
    page: () => OueCoursesSelected(),
  ),
  GetPage(
    name: AppRoute.unitsSubject,
    binding: UnitsSubjectBinding(),
    page: () => UnitsSubject(),
  ),
  GetPage(
    name: AppRoute.myunitsSubject,
    binding: UnitsSubjectBinding(),
    page: () => MyUnitsSubject(),
  ),
  GetPage(
    name: AppRoute.sectionSelected,
    binding: SectionSelectedBinding(),
    page: () => SectionSelected(),
  ),
  GetPage(
    name: AppRoute.mysectionSelected,
    binding: SectionSelectedBinding(),
    page: () => MySectionSelected(),
  ),
  GetPage(
    name: AppRoute.ourCoursesExams,
    binding: OurCoursesExamsBinding(),
    page: () => const OurCourseExams(),
  ),
  GetPage(
    name: AppRoute.lessonDetails,
    binding: LessonDetailsBinding(),
    page: () => LessonDetailsPage(),
  ),
  GetPage(
    name: AppRoute.teacher,
    binding: TeacherBinding(),
    page: () => Teacher(),
  ),
  GetPage(
    name: AppRoute.myteacher,
    binding: TeacherBinding(),
    page: () => MyTeacher(),
  ),
  GetPage(
    name: AppRoute.lessons,
    binding: LessonsBinding(),
    page: () => Lessons(),
  ),

  GetPage(
    name: AppRoute.mylessons,
    binding: LessonsBinding(),
    page: () => MyLessons(),
  ),

  GetPage(
    name: AppRoute.viewLessons,
    binding: ViewLessonBinding(),
    page: () => ViewLesson(),
  ),
  GetPage(name: AppRoute.login, binding: LoginBinding(), page: () => Login()),
  GetPage(
    name: AppRoute.register,
    binding: RegisterBinding(),
    page: () => const Register(),
  ),
  GetPage(
    name: AppRoute.foundation,
    binding: FoundationBinding(),
    page: () => const Foundation(),
  ),
  GetPage(
    name: AppRoute.intensiveLessons,
    binding: IntensiveLessonsBinding(),
    page: () => const IntensiveLessons(),
  ),
  GetPage(
    name: AppRoute.sectionsSubject,
    binding: SectionSubjectBinding(),
    page: () => SectionsSubject(),
  ),
  GetPage(
    name: AppRoute.mysectionsSubject,
    binding: SectionSubjectBinding(),
    page: () => MySectionsSubject(),
  ),
  GetPage(
    name: AppRoute.privacyPolicy,
    binding: PrivacyPolicyBinding(),
    page: () => const PrivacyPolicy(),
  ),
  GetPage(name: AppRoute.home, binding: HomeBinding(), page: () => Home()),
  GetPage(
    name: AppRoute.myCourses,
    binding: MyCoursesBinding(),
    page: () => MyCourses(),
  ),
  GetPage(
    name: AppRoute.notifications,
    binding: NotificationsBinding(),
    page: () => Notifications(),
  ),
  GetPage(
    name: AppRoute.search,
    binding: SearchBinding(),
    page: () => SearchScreen(),
  ),
  GetPage(
    name: AppRoute.viewPdf,
    binding: ViewPdfBinding(),
    page: () => const ViewPdf(),
  ),
  GetPage(
    name: AppRoute.viewVedio,
    binding: ViewVedioBinding(),
    page: () => const ViewVideo(),
  ),
  GetPage(
    name: AppRoute.lessonVedios,
    binding: LessonVediosBinding(),
    page: () => LessonVedios(),
  ),
  GetPage(
    name: AppRoute.myCourseSections,
    binding: MyCourseSectionsBinding(),
    page: () => const MyCourseSections(),
  ),
  GetPage(
    name: AppRoute.myCourseTeachers,
    binding: MyCourseTeachersBinding(),
    page: () => const MyCourseTeachers(),
  ),
  GetPage(
    name: AppRoute.mycourseLessons,
    binding: MyCourseLessonsBinding(),
    page: () => const MyCourseLessons(),
  ),
  GetPage(
    name: AppRoute.mycourseUnitsSubject,
    binding: MyCourseUnitsSubjectBinding(),
    page: () => const MyCourseUnitsSubject(),
  ),
  GetPage(
    name: AppRoute.vedios,
    binding: VediosBinding(),
    page: () => Vedios(false),
  ),
  GetPage(
    name: AppRoute.pdfs,
    binding: PdfsBinding(),
    page: () => Pdfs([], false),
  ),
  GetPage(
    name: AppRoute.vediosWithoutAppBar,
    binding: VediosWithoutAppBarBinding(),
    page: () => VediosWithoutAppBar([], false),
  ),
  GetPage(
    name: AppRoute.basket,
    binding: BasketBinding(),
    page: () => Basket(),
  ),
  GetPage(
    name: AppRoute.subjects,
    binding: SubjectsBinding(),
    page: () => Subjects(),
  ),
  GetPage(
    name: AppRoute.mysubjects,
    binding: SubjectsBinding(),
    page: () => MySubjects(),
  ),
];
