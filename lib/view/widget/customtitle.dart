import 'package:flutter/widgets.dart';

import '../../core/constant/color.dart';
import 'GetValueForScreen.dart';

class CustomTitle extends StatelessWidget {
  final String text;
  const CustomTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(

           text,
            style: TextStyle(fontSize: responsiveValue(context: context, mobile: 20,tablet: 30), fontWeight: FontWeight.bold, decorationThickness: 2),
          ),
        const SizedBox(height: 5),
        Container(
          width: responsiveValue(context: context, mobile: 20,tablet: 30) * 4,
          height: 3,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: AppColor.SecondryColor

          ),
        ),
      ],
    );
    // return Container(
    //   padding: EdgeInsets.all(10),
    //   child: Text(
    //
    //    text,
    //     style: TextStyle(fontSize: responsiveValue(context: context, mobile: 20,tablet: 30), fontWeight: FontWeight.bold, decorationThickness: 2),
    //   ),
    // );
  }
}
