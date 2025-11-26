import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/constant/imageasset.dart';

class customvideo extends StatelessWidget {
  const customvideo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: getValueForScreenType<double>(
        context: context,
        mobile: 200,
        tablet: 400,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: AppColor.BackGround2,
        border: Border.all(
          color: AppColor.DeepPurple,
          width: getValueForScreenType<double>(
            context: context,
            mobile: 1,
            tablet: 2,
          ),
        ),
      ),
      child: Center(child: Lottie.asset(AppImageAsset.video)),
    );
  }
}

class VideoListItem extends StatelessWidget {
  final Map<String, dynamic> video;

  final VoidCallback onTap;

  const VideoListItem({Key? key, required this.video, required this.onTap})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isTablet = MediaQuery.of(context).size.width > 600;
    final double thumbnailWidth = isTablet ? 180 : 120;
    final double thumbnailHeight = isTablet ? 100 : 70;
    final double titleFontSize = isTablet ? 17 : 15;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12.0),
                  child: Image.network(
                    video['thumbnail_url'] ??
                        'https://via.placeholder.com/150x80',
                    width: thumbnailWidth,
                    height: thumbnailHeight,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        width: thumbnailWidth,
                        height: thumbnailHeight,
                        color: Colors.grey[200],
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.grey,
                          size: 40,
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  margin: const EdgeInsets.all(5.0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6.0,
                    vertical: 2.0,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Text(
                    video['duration'] ?? '00:00',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  video['name'] ?? 'عنوان الفيديو غير متوفر',
                  style: TextStyle(
                    color: AppColor.PrimaryColor,
                    fontSize: titleFontSize,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
