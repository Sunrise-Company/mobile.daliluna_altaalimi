import 'package:flutter/material.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

class CustomRadioListTile extends StatelessWidget {
  final String text;
  final String value;
  final String? groupvalue;
  final void Function(String?) onChanged;
  const CustomRadioListTile({
    super.key,
    required this.text,
    required this.value,
    this.groupvalue,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      title: Text(text, style: TextStyle(color: AppColor.PrimaryColor)),
      value: value,
      groupValue: groupvalue,
      onChanged: onChanged,
    );
  }
}
