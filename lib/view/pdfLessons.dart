import 'package:daliluna_altaalimi/view/widget/GetValueForScreen.dart';
import 'package:flutter/material.dart';
// import 'package:gradients/gradients.dart';
import 'package:daliluna_altaalimi/controller/viewlesson_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

import 'package:flutter_cached_pdfview/flutter_cached_pdfview.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:shimmer/shimmer.dart';

class pdfLessons extends StatefulWidget {
  final String url;
  final bool isUrl;
  final String name;

  const pdfLessons({
    Key? key,
    required this.isUrl,
    required this.url,
    required this.name,
  }) : super(key: key);

  @override
  _pdfLessonsState createState() => _pdfLessonsState();
}

class _pdfLessonsState extends State<pdfLessons> {
  late ViewLessonController viewLessonController = ViewLessonController();
  var pdflloade;

  String? pdfUrl;
  @override
  void initState() {
    print(widget.url);
    super.initState();
    // downloadPDF();
  }

  // Future<void> downloadPDF() async {
  //   final url =widget.url;
  //   final response = await Dio().get(url, options: Options(responseType: ResponseType.bytes));

  //   final dir = await getTemporaryDirectory();
  //   final filePath = '${dir.path}/downloaded.pdf';
  //   final file = File(filePath);

  //   await file.writeAsBytes(response.data);
  //   setState(() {
  //     pdfUrl = filePath;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            getValueForScreenType<double>(
              context: context,
              mobile: 55,
              tablet: 100,
            ),
          ),
          child: AppBar(
            elevation: 0,
            backgroundColor: AppColor.PrimaryColor,
            title: Shimmer.fromColors(
              baseColor: Colors.white,
              highlightColor: AppColor.SecondryColor,
              child: Text(
                widget.name,
                style: TextStyle(
                  fontSize: responsiveValue(
                    context: context,
                    mobile: 20,
                    tablet: 35,
                  ),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ),
        // appBar: AppBar(
        //   elevation: 0,
        //   flexibleSpace: Container(
        //     decoration: const BoxDecoration(
        //       gradient: LinearGradientPainter(
        //         begin: Alignment.topRight,
        //         end: Alignment.topCenter,
        //         colors: <Color>[AppColor.SecondryColor2, AppColor.DeepPurple],
        //       ),
        //     ),
        //   ),
        //   title: Text(
        //     widget.name,
        //     style: TextStyle(color: Colors.white),
        //   ),
        // ),
        body: PDF().fromUrl(
          widget.url,
          placeholder: (progress) => Center(child: CircularProgressIndicator()),
          errorWidget: (error) => Center(child: Text('خطأ لم يتم تحميل الملف')),
        ),
        // pdfUrl == null
        //     ? Center(child: CircularProgressIndicator())
        //     : PDFView(
        //         filePath: pdfUrl,
        //         onError: (error) {
        //           print('Error: $error');
        //         },
        //         onPageError: (page, error) {
        //           print('Page $page: $error');
        //         },
        //       ),
      ),
    );
  }
}
