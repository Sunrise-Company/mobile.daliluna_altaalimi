import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/controller/institutes_controller.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';
import 'package:daliluna_altaalimi/view/widget/customcardhome.dart';
import 'package:daliluna_altaalimi/view/widget/loadingimage.dart';

class InstitutesPage extends GetView<InstitutesController> {
  const InstitutesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColor.PrimaryColor,
          elevation: 0,
          title: Text(
            'معاهد ${controller.cityName}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColor.White,
              fontSize: getValueForScreenType<double>(
                context: context,
                mobile: 18,
                tablet: 28,
              ),
            ),
          ),
        ),
        body: GetBuilder<InstitutesController>(
          builder: (institutesController) {
            if (institutesController.isLoading) {
              return const Center(child: LoadingImage());
            }
            if (institutesController.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      institutesController.errorMessage!,
                      style: TextStyle(
                        color: AppColor.PrimaryColor,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton.icon(
                      onPressed: institutesController.fetchInstitutes,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.SecondryColor,
                      ),
                      icon: const Icon(Icons.refresh),
                      label: const Text('إعادة المحاولة'),
                    ),
                  ],
                ),
              );
            }
            if (institutesController.institutes.isEmpty) {
              return Center(
                child: Text(
                  'لا توجد معاهد مسجلة في هذه المحافظة حالياً',
                  style: TextStyle(
                    color: AppColor.grey,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.builder(
                itemCount: institutesController.institutes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.95,
                ),
                itemBuilder: (context, index) {
                  final institute = institutesController.institutes[index];
                  return CustomCardHome(
                    name: institute['name'] ?? '',
                    image: institute['image'],
                    onTap: () => institutesController.selectInstitute(
                      Map<String, dynamic>.from(institute),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
