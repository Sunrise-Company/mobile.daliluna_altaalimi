import 'package:flutter/widgets.dart';
import 'package:daliluna_altaalimi/view/widget/customcontainer.dart';

class CustomWidgetRequired extends StatelessWidget {
  final String text;
  const CustomWidgetRequired({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 15, bottom: 10, left: 5),
      child: Row(
        children: [
          CustomContainer(),
          Flexible(
            child: Container(
              padding: EdgeInsets.only(right: 10),
              child: Text(text),
            ),
          ),
        ],
      ),
    );
  }
}
