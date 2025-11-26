import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:daliluna_altaalimi/core/constant/color.dart';

final TextEditingController textEditingController = TextEditingController();

class CustomDropDown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;
  const CustomDropDown({
    super.key,
    required this.items,
    this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(
        getValueForScreenType<double>(context: context, mobile: 8, tablet: 20),
      ),
      decoration: BoxDecoration(
        color: AppColor.BackGround3,
        border: Border.all(color: AppColor.DeepPurple, width: 1),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Center(
        child: DropdownButtonHideUnderline(
          child: DropdownButton2<String>(
            isExpanded: true,
            hint: Text(
              'المحافظة',
              style: TextStyle(
                fontSize: getValueForScreenType<double>(
                  context: context,
                  mobile: 15,
                  tablet: 17,
                ),
                color: AppColor.DeepPurple,
              ),
            ),
            items: items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(
                      item,
                      style: TextStyle(
                        fontSize: getValueForScreenType<double>(
                          context: context,
                          mobile: 14,
                          tablet: 17,
                        ),
                        color: AppColor.PrimaryColor,
                      ),
                    ),
                  ),
                )
                .toList(),
            value: value,
            onChanged: onChanged,
            buttonStyleData: const ButtonStyleData(
              padding: EdgeInsets.symmetric(horizontal: 16),
            ),
            dropdownStyleData: DropdownStyleData(
              maxHeight: getValueForScreenType<double>(
                context: context,
                mobile: 200,
                tablet: 300,
              ),
              decoration: BoxDecoration(color: AppColor.BackGround),
            ),
            menuItemStyleData: MenuItemStyleData(
              height: getValueForScreenType<double>(
                context: context,
                mobile: 40,
                tablet: 50,
              ),
            ),
            dropdownSearchData: DropdownSearchData(
              searchController: textEditingController,
              searchInnerWidgetHeight: getValueForScreenType<double>(
                context: context,
                mobile: 50,
                tablet: 100,
              ),
              searchInnerWidget: Container(
                height: getValueForScreenType<double>(
                  context: context,
                  mobile: 50,
                  tablet: 90,
                ),
                padding: EdgeInsets.only(
                  top: getValueForScreenType<double>(
                    context: context,
                    mobile: 8,
                    tablet: 12,
                  ),
                  bottom: getValueForScreenType<double>(
                    context: context,
                    mobile: 4,
                    tablet: 8,
                  ),
                  right: getValueForScreenType<double>(
                    context: context,
                    mobile: 8,
                    tablet: 12,
                  ),
                  left: getValueForScreenType<double>(
                    context: context,
                    mobile: 8,
                    tablet: 12,
                  ),
                ),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: TextFormField(
                    cursorColor: AppColor.PrimaryColor,
                    expands: true,
                    maxLines: null,
                    controller: textEditingController,
                    decoration: InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        // borderRadius: BorderRadius.all(Radius.circular(25)),
                        borderSide: BorderSide(
                          width: 1.5,
                          color: AppColor.DeepPurple,
                        ),
                      ),
                      isDense: true,
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: getValueForScreenType<double>(
                          context: context,
                          mobile: 10,
                          tablet: 15,
                        ),
                        vertical: getValueForScreenType<double>(
                          context: context,
                          mobile: 8,
                          tablet: 12,
                        ),
                      ),
                      hintText: 'البحث عن المحافظة...',
                      hintStyle: TextStyle(
                        fontSize: getValueForScreenType<double>(
                          context: context,
                          mobile: 12,
                          tablet: 15,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ),
              searchMatchFn: (item, searchValue) {
                return item.value.toString().contains(searchValue);
              },
            ),
            //This to clear the search value when you close the menu
            onMenuStateChange: (isOpen) {
              if (!isOpen) {
                textEditingController.clear();
              }
            },
          ),
        ),
      ),
    );
  }
}
