import 'package:flutter/widgets.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customcontainer.dart';

class CustomContainerSection extends StatelessWidget {
  final String text;
  final String count;
  const CustomContainerSection({
    super.key,
    required this.text,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      color: AppColor.BackGround2,
      child: Row(
        children: [
          CustomContainer(),
          SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 15)),
          SizedBox(width: 10),
          Text(
            count,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: AppColor.DeepPurple,
            ),
          ),
        ],
      ),
    );
  }
}
