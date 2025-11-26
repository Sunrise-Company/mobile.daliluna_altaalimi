import 'package:flutter/widgets.dart';
import 'package:readmore/readmore.dart';
import 'package:responsive_builder/responsive_builder.dart';

class CustomReadMore extends StatelessWidget {
  final String text;
  const CustomReadMore({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          right: getValueForScreenType<double>(
            context: context,
            mobile: 10,
            tablet: 20,
          ),
          left: getValueForScreenType<double>(
            context: context,
            mobile: 10,
            tablet: 20,
          ),
          bottom: getValueForScreenType<double>(
            context: context,
            mobile: 10,
            tablet: 20,
          )),
      child: ReadMoreText(
       " ${text}",
        trimLines: 2,
        style: TextStyle(
            fontSize: getValueForScreenType<double>(
          context: context,
          mobile: 13,
          tablet: 30,
        )),
        trimMode: TrimMode.Line,
        trimCollapsedText: 'مشاهدة المزيد',
        trimExpandedText: 'مشاهدة أقل',
        moreStyle: TextStyle(
          fontSize: getValueForScreenType<double>(
            context: context,
            mobile: 12,
            tablet: 30,
          ),
          fontWeight: FontWeight.bold,
        ),
        lessStyle: TextStyle(
            fontSize: getValueForScreenType<double>(
              context: context,
              mobile: 12,
              tablet: 30,
            ),
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
