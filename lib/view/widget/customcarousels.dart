// // import 'package:cached_network_image/cached_network_image.dart';
// // import 'package:carousel_slider/carousel_slider.dart';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:responsive_builder/responsive_builder.dart';
// // import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';
// //
// // class CustomCarouselslider extends StatelessWidget {
// //   final List<String> items;
// //   const CustomCarouselslider({super.key, required this.items});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Center(
// //       child: Container(
// //         width: getValueForScreenType<double>(
// //           context: context,
// //           mobile: 300,
// //           tablet: 700,
// //         ),
// //         height: getValueForScreenType<double>(
// //           context: context,
// //           mobile: 150,
// //           tablet: 300,
// //         ),
// //         child: CarouselSlider(
// //           options: CarouselOptions(
// //             height: getValueForScreenType<double>(
// //               context: context,
// //               mobile: 220,
// //               tablet: 350,
// //             ),
// //             aspectRatio: 16 / 9,
// //             viewportFraction: 0.85,
// //             initialPage: 0,
// //             enableInfiniteScroll: true,
// //             reverse: false,
// //             autoPlay: true,
// //             autoPlayInterval: const Duration(seconds: 5),
// //             autoPlayAnimationDuration: const Duration(milliseconds: 1200),
// //             autoPlayCurve: Curves.easeInOutCubic,
// //             enlargeCenterPage: true,
// //             enlargeFactor: 0.35,
// //             scrollDirection: Axis.horizontal,
// //             pauseAutoPlayOnTouch: true,
// //             pageSnapping: true,
// //             clipBehavior: Clip.antiAlias,
// //             padEnds: true,
// //             disableCenter: false,
// //           ),
// //
// //           // options: CarouselOptions(
// //           //
// //           //   autoPlay: true,
// //           //   enlargeCenterPage: true,
// //           //   viewportFraction: 0.9,
// //           //   aspectRatio: 2.0,
// //           //   height: getValueForScreenType<double>(
// //           //     context: context,
// //           //     mobile: 200,
// //           //     tablet: 300,
// //           //   ),
// //           //   initialPage: 0,
// //           //   enableInfiniteScroll: true,
// //           //   reverse: false,
// //           //   autoPlayInterval: Duration(seconds: 4),
// //           //   autoPlayAnimationDuration: Duration(milliseconds: 2000),
// //           //   autoPlayCurve: Curves.fastOutSlowIn,
// //           //   enlargeFactor: 0.3,
// //           //   scrollDirection: Axis.horizontal,
// //           // ),
// //           items: items.map(
// //             (i) {
// //               return Container(
// //                   width: Get.width,
// //                   margin: EdgeInsets.symmetric(horizontal: 5.0),
// //                   decoration: BoxDecoration(color: Colors.white),
// //                   child: i != "-"
// //                       ? CachedNetworkImage(
// //                           imageUrl: i,
// //                           fit: BoxFit.fill,
// //                           placeholder: (context, url) => LoadingImage(),
// //                           errorWidget: (context, url, error) =>
// //                               Icon(Icons.error),
// //                         )
// //                       : Text(""));
// //             },
// //           ).toList(),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //////////////////////////////////////////////////
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:responsive_builder/responsive_builder.dart';
// import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';
//
// class CustomCarouselslider extends StatelessWidget {
//   final List<String> items;
//   const CustomCarouselslider({super.key, required this.items});
//
//   @override
//   Widget build(BuildContext context) {
//     final RxInt currentIndex = 0.obs;
//
//     return Container(
//       width: double.infinity,
//       height: getValueForScreenType<double>(
//         context: context,
//         mobile: 220,
//         tablet: 350,
//       ),
//       child: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           // Main Carousel
//           CarouselSlider.builder(
//             itemCount: items.length,
//             options: CarouselOptions(
//               height: getValueForScreenType<double>(
//                 context: context,
//                 mobile: 220,
//                 tablet: 350,
//               ),
//               aspectRatio: 16 / 9,
//               viewportFraction: 0.85,
//               initialPage: 0,
//               enableInfiniteScroll: true,
//               reverse: false,
//               autoPlay: true,
//               autoPlayInterval: const Duration(seconds: 5),
//               autoPlayAnimationDuration: const Duration(milliseconds: 1000),
//               autoPlayCurve: Curves.easeInOut,
//               enlargeCenterPage: true,
//               enlargeFactor: 0.25,
//               scrollDirection: Axis.horizontal,
//               pauseAutoPlayOnTouch: true,
//               pauseAutoPlayOnManualNavigate: true,
//               pageSnapping: true,
//               clipBehavior: Clip.antiAliasWithSaveLayer,
//               padEnds: true,
//               onPageChanged: (index, reason) {
//                 currentIndex.value = index;
//               },
//             ),
//             itemBuilder: (context, index, realIndex) {
//               return AnimatedContainer(
//                 duration: Duration(milliseconds: 500),
//                 margin: EdgeInsets.symmetric(
//                   horizontal: 8.0,
//                   vertical: 12.0,
//                 ),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(20),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.3),
//                       blurRadius: 15,
//                       spreadRadius: 2,
//                       offset: Offset(0, 8),
//                     ),
//                   ],
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: items[index] != "-"
//                       ? CachedNetworkImage(
//                     imageUrl: items[index],
//                     fit: BoxFit.cover,
//                     width: double.infinity,
//                     placeholder: (context, url) => Container(
//                       decoration: BoxDecoration(
//                         gradient: LinearGradient(
//                           begin: Alignment.topLeft,
//                           end: Alignment.bottomRight,
//                           colors: [
//                             Color(0xFF6A11CB).withOpacity(0.1),
//                             Color(0xFF2575FC).withOpacity(0.1),
//                           ],
//                         ),
//                       ),
//                       child: Center(
//                         child: LoadingImage(),
//                       ),
//                     ),
//                     errorWidget: (context, url, error) => Container(
//                       color: Colors.grey[200],
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.broken_image_outlined,
//                             size: 50,
//                             color: Colors.grey[400],
//                           ),
//                           SizedBox(height: 8),
//                           Text(
//                             'تعذر تحميل الصورة',
//                             style: TextStyle(
//                               color: Colors.grey[600],
//                               fontSize: 14,
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   )
//                       : Container(
//                     decoration: BoxDecoration(
//                       gradient: LinearGradient(
//                         begin: Alignment.topLeft,
//                         end: Alignment.bottomRight,
//                         colors: [
//                           Color(0xFF6A11CB),
//                           Color(0xFF2575FC),
//                         ],
//                       ),
//                     ),
//                     child: Center(
//                       child: Icon(
//                         Icons.photo_library_outlined,
//                         size: 60,
//                         color: Colors.white.withOpacity(0.8),
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             },
//           ),
//
//           // Indicator Dots
//           if (items.length > 1)
//             Positioned(
//               bottom: 20,
//               child: Obx(
//                     () => Container(
//                   padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: List.generate(
//                       items.length,
//                           (index) => AnimatedContainer(
//                         duration: Duration(milliseconds: 300),
//                         margin: EdgeInsets.symmetric(horizontal: 4),
//                         width: currentIndex.value == index ? 20 : 8,
//                         height: 8,
//                         decoration: BoxDecoration(
//                           shape: currentIndex.value == index
//                               ? BoxShape.rectangle
//                               : BoxShape.circle,
//                           borderRadius: currentIndex.value == index
//                               ? BorderRadius.circular(4)
//                               : null,
//                           color: currentIndex.value == index
//                               ? Colors.white
//                               : Colors.white.withOpacity(0.5),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.3),
//                               blurRadius: 4,
//                               offset: Offset(0, 2),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//           // Gradient Overlay at bottom
//           Positioned(
//             bottom: 0,
//             left: 0,
//             right: 0,
//             child: Container(
//               height: 60,
//               decoration: BoxDecoration(
//                 gradient: LinearGradient(
//                   begin: Alignment.bottomCenter,
//                   end: Alignment.topCenter,
//                   colors: [
//                     Colors.black.withOpacity(0.4),
//                     Colors.transparent,
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';

class CustomCarouselslider extends StatelessWidget {
  final List<String> items;
  const CustomCarouselslider({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final RxInt currentIndex = 0.obs;

    return Container(
      width: double.infinity,
      height: getValueForScreenType<double>(
        context: context,
        mobile: 170,
        tablet: 280,
      ),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Main Carousel
          CarouselSlider.builder(
            itemCount: items.length,
            options: CarouselOptions(
              height: getValueForScreenType<double>(
                context: context,
                mobile: 170,
                tablet: 280,
              ),
              aspectRatio: 16 / 9,
              viewportFraction: 0.9,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 4),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.easeInOutCubic,
              enlargeCenterPage: true,
              enlargeFactor: 0.15,
              scrollDirection: Axis.horizontal,
              pauseAutoPlayOnTouch: true,
              pauseAutoPlayOnManualNavigate: true,
              pageSnapping: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              padEnds: true,
              onPageChanged: (index, reason) {
                currentIndex.value = index;
              },
            ),
            itemBuilder: (context, index, realIndex) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.symmetric(
                  horizontal: 6.0,
                  vertical: 8.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      spreadRadius: 0,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: items[index] != "-"
                      ? CachedNetworkImage(
                          imageUrl: items[index],
                          fit: BoxFit.cover,
                          width: double.infinity,
                          placeholder: (context, url) => Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  const Color(0xFF6A11CB).withOpacity(0.1),
                                  const Color(0xFF2575FC).withOpacity(0.1),
                                ],
                              ),
                            ),
                            child: const Center(child: LoadingImage()),
                          ),
                          errorWidget: (context, url, error) => Container(
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.broken_image_outlined,
                                  size: 50,
                                  color: Colors.grey[400],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'تعذر تحميل الصورة',
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [Color(0xFF6A11CB), Color(0xFF2575FC)],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              Icons.photo_library_outlined,
                              size: 60,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                        ),
                ),
              );
            },
          ),

          // Indicator Dots
          if (items.length > 1)
            Positioned(
              bottom: 16,
              child: Obx(
                () => Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(items.length, (index) {
                      final bool isActive = currentIndex.value == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: isActive ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.white
                              : Colors.white.withOpacity(0.5),
                          // shape: isActive
                          //     ? BoxShape.rectangle
                          //     : BoxShape.circle,
                          borderRadius: isActive
                              ? BorderRadius.circular(4)
                              : null,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),
                ),
              ),
            ),

          // Gradient Overlay at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [Colors.black.withOpacity(0.2), Colors.transparent],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
