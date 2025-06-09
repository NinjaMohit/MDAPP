import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

import 'package:md_app/util/app_color.dart';
import 'package:md_app/util/app_textsize.dart';

class AppSearchDropdown extends StatelessWidget {
  final List<String> items;
  final String? selectedItem;
  final String hintText;

  final ValueChanged<String?> onChanged;
  final bool enabled;
  final FormFieldValidator<String?>? validator;

  const AppSearchDropdown({
    super.key,
    required this.items,
    required this.onChanged,
    this.selectedItem,
    this.hintText = 'Select an option',
    this.enabled = true, // Default to enabled if not specified
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !enabled,
      child: DropdownSearch<String>(
        popupProps: PopupProps.menu(
          menuProps: MenuProps(
            backgroundColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          constraints: BoxConstraints(
            maxHeight: (items.length * 80).toDouble().clamp(140, 300),
          ), //

          showSearchBox: true,
          itemBuilder: (context, item, isSelected) {
            return Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: Text(
                  item,
                  style: TextStyle(
                    fontSize: AppTextSize.textSizeSmall,
                    fontWeight: FontWeight.w400,
                    color: AppColors.primaryText,
                  ),
                ));
          },
          searchFieldProps: TextFieldProps(
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.symmetric(
                  vertical: 10, horizontal: 12), // reduced height

              filled: true,
              fillColor: Colors.white, // ✅ Ensure background remains white
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: AppTextSize.textSizeSmall,
                fontWeight: FontWeight.w500,
                color: AppColors.primaryText,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(color: AppColors.searchfeild, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: AppColors.searchfeild,
                  width: 1,
                ),
              ),
            ),
          ),
        ),
        validator: validator,
        items: items,
        selectedItem: selectedItem,
        dropdownDecoratorProps: DropDownDecoratorProps(
          baseStyle: TextStyle(
            fontSize: AppTextSize.textSizeMedium,
            fontWeight: FontWeight.w400,
            color: AppColors.primaryText,
          ),
          dropdownSearchDecoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: AppTextSize.textSizeSmall,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryText,
            ),
            filled: true,
            fillColor:
                AppColors.buttoncolor, // ✅ Ensure background remains white

            contentPadding:
                const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppColors.searchfeildcolor, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  BorderSide(color: AppColors.searchfeildcolor, width: 1),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 126, 16, 9),
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: const Color.fromARGB(255, 126, 16, 9),
                width: 1,
              ),
            ),
          ),
        ),
        dropdownButtonProps: DropdownButtonProps(
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: AppColors.primaryText,
            size: 27,
          ),
        ),
        onChanged: enabled ? onChanged : null,
      ),
    );
  }
}
