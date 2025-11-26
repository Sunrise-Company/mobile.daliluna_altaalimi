import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';


double responsiveValue({
  required BuildContext context,
  required double mobile,
  required double tablet,
}) {
  return getValueForScreenType<double>(
    context: context,
    mobile: mobile,
    tablet: tablet,
  );
}
