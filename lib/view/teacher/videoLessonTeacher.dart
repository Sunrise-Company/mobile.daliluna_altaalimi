import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:daliluna_altaalimi/constant.dart';
import 'package:daliluna_altaalimi/controller/teacherController/videosLessonTeacherController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// import 'package:gradients/gradients.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/vedios_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/linkapi.dart';
import 'package:daliluna_altaalimi/view/VideoLecture.dart';
import 'package:daliluna_altaalimi/view/widget/customiconappbar.dart';
import 'package:daliluna_altaalimi/view/widget/customvideo.dart';
import 'package:daliluna_altaalimi/view/widget/loading.dart';
import 'package:shimmer/shimmer.dart';

import '../widget/GetValueForScreen.dart';

class VediosTeacherLesson extends GetView<TeacherVideosLessonContrlloer> {
  VediosTeacherLesson({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        // appBar: AppBar(
        //   leading: CustomIconAppBar(),
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
        //     "الفيديوهات",
        //     style: TextStyle(
        //       color: AppColor.White,
        //       fontSize: getValueForScreenType<double>(
        //         context: context,
        //         mobile: 20,
        //         tablet: 30,
        //       ),
        //     ),
        //   ),
        // ),
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
                "الفيديوهات",
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
        body: GetBuilder<TeacherVideosLessonContrlloer>(
          builder: (controller) {
            if (!controller.isloded.value) {
              return Loading();
            }

            return Container(
              color: Colors.white,
              child: !controller.isloded.value
                  ? _buildLoadingIndicator()
                  : controller.dataList.isNotEmpty
                  ? _buildVideosList(context)
                  : _buildEmptyState(context),
            );
          },
          //   },
        ),
      ),
    );
  }

  Widget _buildLoadingIndicator() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Loading(),
          Text(
            "جاري تحميل الفيديوهات...",
            style: TextStyle(
              color: AppColor.PrimaryColor,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideosList(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.symmetric(
        vertical: getValueForScreenType<double>(
          context: context,
          mobile: 10,
          tablet: 20,
        ),
        horizontal: getValueForScreenType<double>(
          context: context,
          mobile: 15,
          tablet: 25,
        ),
      ),
      itemCount: controller!.dataList.length,
      itemBuilder: (BuildContext context, index) {
        final video = Map<String, dynamic>.from(controller!.dataList[index]);
        // final bool isLocked =
        //     !controller!.isSectionPurchased && video['free_status'] != '1';

        final bool isYoutubeVideo =
            video['link'] != null &&
            (video['link'].contains('youtube.com') ||
                video['link'].contains('youtu.be'));

        if (isYoutubeVideo) {
          return YoutubeVideoCard(video: video, index: index, isLocked: false);
        } else {
          return _buildVideoCard(context, video, index, false);
        }
      },
      separatorBuilder: (context, index) => SizedBox(
        height: getValueForScreenType<double>(
          context: context,
          mobile: 10,
          tablet: 15,
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.video_library_outlined, size: 80, color: Colors.grey[400]),
          SizedBox(height: 20),
          Text(
            "لا يوجد فيديوهات حالياً",
            style: TextStyle(
              fontSize: getValueForScreenType<double>(
                context: context,
                mobile: 18,
                tablet: 22,
              ),
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 10),
          Text(
            "سيتم إضافة فيديوهات جديدة قريباً",
            style: TextStyle(
              fontSize: getValueForScreenType<double>(
                context: context,
                mobile: 14,
                tablet: 16,
              ),
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVideoCard(
    BuildContext context,
    Map<String, dynamic> video,
    int index,
    bool isLocked,
  ) {
    return _buildCardLayout(
      context: context,
      video: video,
      index: index,
      durationText: _formatDuration(video['duration'] ?? 0),
      thumbnail: _buildDefaultThumbnail(context),
      isLocked: isLocked,
    );
  }

  Widget _buildCardLayout({
    required BuildContext context,
    required Map<String, dynamic> video,
    required int index,
    required String durationText,
    required Widget thumbnail,
    required bool isLocked,
  }) {
    return Opacity(
      opacity: isLocked ? 0.6 : 1.0,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColor.PrimaryColor,
              blurRadius: 8,
              offset: Offset(0, 3),
              spreadRadius: 1,
            ),
          ],
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.white.withOpacity(0.98)],
          ),
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              if (isLocked) {
                Get.snackbar(
                  "محتوى حصري للمشتركين",
                  "اشترك في القسم للوصول إلى هذا الفيديو وكل المحتوى.",
                  icon: Icon(Icons.lock, color: Colors.white),
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: AppColor.PrimaryColor,
                  colorText: Colors.white,
                  margin: EdgeInsets.all(15),
                  borderRadius: 12,
                  duration: Duration(seconds: 4),
                );
              } else {
                if (video['link'] != null) {
                  Get.toNamed(
                    '/VideoLecture',
                    arguments: {
                      'url': video['link'],
                      'videoFiles': video['files'],
                      'lesson_dep_file_id': video['id'],
                    },
                  );
                } else {
                  Get.toNamed(
                    '/VideoLecture',
                    arguments: {
                      'url':
                          '${AppLink.baseUrl}/storage/' + (video['file'] ?? ''),
                      'videoFiles': video['files'],
                      'lesson_dep_file_id': video['id'],
                    },
                  );
                }
              }
            },
            child: Padding(
              padding: EdgeInsets.all(
                getValueForScreenType<double>(
                  context: context,
                  mobile: 12,
                  tablet: 15,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: getValueForScreenType<double>(
                      context: context,
                      mobile: 100,
                      tablet: 120,
                    ),
                    width: getValueForScreenType<double>(
                      context: context,
                      mobile: 140,
                      tablet: 160,
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      alignment: Alignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: thumbnail,
                        ),
                        Positioned(
                          top: 6,
                          right: 6,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColor.PrimaryColor,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${video['lesson_dep_oreder']}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 6,
                          left: 6,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              durationText,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                        if (isLocked)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Icon(
                                Icons.lock,
                                color: Colors.white,
                                size: 40,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.5),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                video['name'] ?? 'فيديو بدون عنوان',
                                style: TextStyle(
                                  fontSize: getValueForScreenType<double>(
                                    context: context,
                                    mobile: 15,
                                    tablet: 17,
                                  ),
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            video['free_status'].toString() == '1'
                                ? Container(
                                    decoration: BoxDecoration(
                                      color: AppColor.SecondryColor,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(6.0),
                                      child: Text(
                                        video['free_status'].toString() == '1'
                                            ? "مجاني"
                                            : "مدفوع",
                                        style: TextStyle(
                                          fontSize:
                                              getValueForScreenType<double>(
                                                context: context,
                                                mobile: 10,
                                                tablet: 12,
                                              ),
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          height: 1.3,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  )
                                : SizedBox(),
                          ],
                        ),
                        SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.video_library,
                              size: 16,
                              color: AppColor.SecondryColor,
                            ),
                            SizedBox(width: 6),
                            Text(
                              'فيديو تعليمي',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColor.SecondryColor,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDefaultThumbnail(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColor.PrimaryColor.withOpacity(0.9),
            AppColor.SecondryColor.withOpacity(0.7),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.play_circle_filled,
          size: getValueForScreenType<double>(
            context: context,
            mobile: 35,
            tablet: 40,
          ),
          color: Colors.white,
        ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    if (seconds <= 0) return '0:00';
    final duration = Duration(seconds: seconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final remainingSeconds = duration.inSeconds.remainder(60);

    if (hours > 0) {
      return '${hours.toString()}:${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString()}:${remainingSeconds.toString().padLeft(2, '0')}';
    }
  }
}

class YoutubeVideoCard extends StatefulWidget {
  final Map<String, dynamic> video;
  final int index;
  final bool isLocked;

  const YoutubeVideoCard({
    Key? key,
    required this.video,
    required this.index,
    required this.isLocked,
  }) : super(key: key);

  @override
  _YoutubeVideoCardState createState() => _YoutubeVideoCardState();
}

class _YoutubeVideoCardState extends State<YoutubeVideoCard> {
  final String _apiKey = "${AppConstants.YoutubeApiKey}";
  late Future<String> _durationFuture;
  String? _videoId;

  @override
  void initState() {
    super.initState();
    _videoId = _extractVideoId(widget.video['link']);
    _durationFuture = _fetchVideoDuration();
  }

  String? _extractVideoId(String url) {
    if (!url.contains("youtube.com") && !url.contains("youtu.be")) return null;
    if (url.contains("youtu.be")) return url.split('/').last.split('?').first;
    RegExp regExp = RegExp(
      r".*(?:(?:youtu\.be\/|v\/|vi\/|u\/\w\/|embed\/)|(?:(?:watch)?\?v(?:i)?=|\&v(?:i)?=))([^#\&\?]*).*",
    );
    Match? match = regExp.firstMatch(url);
    return (match != null && match.group(1)!.length == 11)
        ? match.group(1)
        : null;
  }

  Future<String> _fetchVideoDuration() async {
    if (_videoId == null || _apiKey == "YOUR_API_KEY") {
      return "0:00";
    }
    final url =
        'https://www.googleapis.com/youtube/v3/videos?id=$_videoId&part=contentDetails&key=$_apiKey';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['items'] != null && data['items'].isNotEmpty) {
          final durationString = data['items'][0]['contentDetails']['duration'];
          return _formatIso8601Duration(durationString);
        }
      }
      return "0:00";
    } catch (e) {
      return "0:00";
    }
  }

  String _formatIso8601Duration(String iso) {
    final regex = RegExp(r'PT(?:(\d+)H)?(?:(\d+)M)?(?:(\d+)S)?');
    final matches = regex.firstMatch(iso);
    if (matches == null) return '0:00';

    final hours = int.tryParse(matches.group(1) ?? '0') ?? 0;
    final minutes = int.tryParse(matches.group(2) ?? '0') ?? 0;
    final seconds = int.tryParse(matches.group(3) ?? '0') ?? 0;

    int totalSeconds = (hours * 3600) + (minutes * 60) + seconds;
    return VediosTeacherLesson()._formatDuration(totalSeconds);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _durationFuture,
      builder: (context, snapshot) {
        String durationText = "...";
        if (snapshot.connectionState == ConnectionState.done) {
          durationText = snapshot.data ?? "0:00";
        }

        final thumbnailUrl =
            'https://img.youtube.com/vi/$_videoId/mqdefault.jpg';

        return VediosTeacherLesson()._buildCardLayout(
          isLocked: widget.isLocked,
          context: context,
          video: widget.video,
          index: widget.index,
          durationText: durationText,
          thumbnail: _videoId == null
              ? VediosTeacherLesson()._buildDefaultThumbnail(context)
              : Image.network(
                  thumbnailUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    return progress == null ? child : Center(child: Loading());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return VediosTeacherLesson()._buildDefaultThumbnail(
                      context,
                    );
                  },
                ),
        );
      },
    );
  }
}
