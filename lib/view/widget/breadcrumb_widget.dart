import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/core/services/breadcrumb_service.dart';
import 'package:daliluna_altaalimi/data/model/breadcrumb_model.dart';
import 'package:responsive_builder/responsive_builder.dart';

class BreadcrumbWidget extends StatelessWidget {
  const BreadcrumbWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final BreadcrumbService service = Get.find<BreadcrumbService>();

    return Obx(() {
      if (service.breadcrumbs.isEmpty) return const SizedBox.shrink();

      return Container(
        width: double.infinity,
        color: AppColor.SecondryColor.withOpacity(0.1),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          // reverse: true, // RTL support
          child: Row(
            children: service.breadcrumbs.asMap().entries.map((entry) {
              int index = entry.key;
              BreadcrumbItem item = entry.value;
              bool isLast = index == service.breadcrumbs.length - 1;

              return Row(
                children: [
                  if (index > 0)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        size: 12,
                        color: Colors.grey,
                      ),
                    ),
                  InkWell(
                    onTap: isLast ? null : () => service.navigateTo(index),
                    child: Text(
                      item.title,
                      style: TextStyle(
                        color: isLast
                            ? AppColor.PrimaryColor
                            : Colors.grey[700],
                        fontWeight: isLast
                            ? FontWeight.bold
                            : FontWeight.normal,
                        fontSize: getValueForScreenType<double>(
                          context: context,
                          mobile: 12,
                          tablet: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      );
    });
  }
}
