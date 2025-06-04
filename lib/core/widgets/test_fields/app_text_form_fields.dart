import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../colors/app_colors.dart';


// ignore: must_be_immutable
// class AppTextFormField extends StatelessWidget {
//   final String header;
//   final int? maxLInes;
//   final int? minLines;
//   final TextCapitalization? textCapitalization;
//   final int? maxLength;
//   final bool? readOnly;
//   final String? placeHolder;
//   final Widget? icon;
//   String? errorText;
//   final bool? obscureText;
//   final String? Function(String?)? validator;
//   final void Function(String)? onChange;
//   final TextEditingController controller;
//   final TextInputType? textInputType;
//   final List<TextInputFormatter>? inputFormatters;
//
//   AppTextFormField(
//       {super.key,
//       required this.controller,
//       this.validator,
//       this.maxLInes,
//       this.readOnly,
//       this.icon,
//       this.obscureText,
//       this.maxLength,
//       this.minLines,
//       this.errorText,
//       this.onChange,
//       this.textCapitalization,
//       this.placeHolder,
//       required this.header,
//       this.textInputType,
//       this.inputFormatters});
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         header.isNotEmpty
//             ? Column(
//                 children: [
//                   Text(
//                     header.tr,
//                     style:
//                         TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
//                   ),
//                   SizedBox(
//                     height: 7.sp,
//                   )
//                 ],
//               )
//             : const SizedBox(),
//         TextFormField(
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           controller: controller,
//           textCapitalization: textCapitalization ?? TextCapitalization.none,
//           style: TextStyle(
//               fontSize: 16.sp,
//               color: (readOnly ?? false) ? AppColors.black : AppColors.grey93),
//           readOnly: readOnly ?? false,
//           validator: validator,
//           obscureText: obscureText ?? false,
//           onChanged: onChange,
//           inputFormatters: inputFormatters,
//           keyboardType: textInputType,
//           smartDashesType: SmartDashesType.enabled,
//           maxLines: maxLInes ?? 1,
//           minLines: minLines ?? 1,
//           maxLength: maxLength,
//           decoration: InputDecoration(
//             isDense: false,
//             suffixIcon: Container(
//               padding: EdgeInsets.only(right: 13.sp),
//               child: icon,
//             ),
//             suffixIconConstraints: BoxConstraints(
//               maxHeight: 25.sp,
//               maxWidth: 80.sp,
//             ),
//             counterText: "",
//             hintText: placeHolder,
//             hintStyle: TextStyle(
//                 fontSize: 14.sp,
//                 fontWeight: FontWeight.w400,
//                 color: AppColors.grey122),
//             contentPadding:
//                 EdgeInsets.symmetric(horizontal: 15.sp, vertical: 13.sp),
//             alignLabelWithHint: true,
//             errorText: (errorText ?? "").isEmpty ? null : errorText,
//             filled: true,
//             fillColor: (readOnly ?? false)
//                 ? Get.theme.indicatorColor.withOpacity(.1)
//                 : Get.theme.primaryColor,
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.sp),
//                 borderSide: BorderSide(
//                     color: (readOnly ?? false)
//                         ? AppColors.grey249
//                         : AppColors.grey155)),
//             enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.sp),
//                 borderSide: BorderSide(
//                     color: (readOnly ?? false)
//                         ? AppColors.grey249
//                         : AppColors.grey155)),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.sp),
//                 borderSide: BorderSide(
//                     color: (readOnly ?? false)
//                         ? AppColors.grey249
//                         : AppColors.grey155)),
//             disabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(8.sp),
//                 borderSide: BorderSide(
//                     color: (readOnly ?? false)
//                         ? AppColors.grey249
//                         : AppColors.grey155)),
//           ),
//         )
//       ],
//     );
//   }
// }
import 'package:flutter/services.dart';

// Custom TextInputFormatter to filter out emojis
class NoEmojiFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    // Regular expression to match emojis and other Unicode symbols
    final emojiRegex = RegExp(
      r'[\u{1F600}-\u{1F64F}]|[\u{1F300}-\u{1F5FF}]|[\u{1F680}-\u{1F6FF}]|[\u{1F1E0}-\u{1F1FF}]|[\u{2600}-\u{26FF}]|[\u{2700}-\u{27BF}]|[\u{1F900}-\u{1F9FF}]|[\u{1F018}-\u{1F270}]|[\u{238C}-\u{2454}]|[\u{20D0}-\u{20FF}]|[\u{A490}-\u{A4C6}]|[\u{2000}-\u{200D}]|[\u{20E0}-\u{20EF}]|[\u{FE00}-\u{FE0F}]|[\u{1F000}-\u{1F02F}]|[\u{1F0A0}-\u{1F0FF}]|[\u{1F100}-\u{1F64F}]|[\u{1F170}-\u{1F251}]|[\u{1F004}]|[\u{1F0CF}]|[\u{1F18E}]|[\u{3030}]',
      unicode: true,
    );
    // Remove emojis from the new text
    final filteredText = newValue.text.replaceAll(emojiRegex, '');

    // If text was filtered, return the filtered version
    if (filteredText != newValue.text) {
      return TextEditingValue(
        text: filteredText,
        selection: TextSelection.collapsed(
          offset: filteredText.length.clamp(0, filteredText.length),
        ),
      );
    }

    return newValue;
  }
}

class AppTextFormField extends StatelessWidget {
  final String header;
  final int? maxLInes;
  final int? minLines;
  final TextCapitalization? textCapitalization;
  final int? maxLength;
  final bool? readOnly;
  final String? placeHolder;
  final Widget? icon;
  String? errorText;
  final bool? obscureText;
  final String? Function(String?)? validator;
  final void Function(String)? onChange;
  final TextEditingController controller;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool restrictEmojis; // New parameter to control emoji restriction

  AppTextFormField({
    super.key,
    required this.controller,
    this.validator,
    this.maxLInes,
    this.readOnly,
    this.icon,
    this.obscureText,
    this.maxLength,
    this.minLines,
    this.errorText,
    this.onChange,
    this.textCapitalization,
    this.placeHolder,
    required this.header,
    this.textInputType,
    this.inputFormatters,
    this.restrictEmojis = false, // Default to false to maintain backward compatibility
  });

  @override
  Widget build(BuildContext context) {
    // Combine existing formatters with emoji restriction if needed
    List<TextInputFormatter> combinedFormatters = [];

    if (inputFormatters != null) {
      combinedFormatters.addAll(inputFormatters!);
    }

    if (restrictEmojis) {
      combinedFormatters.add(NoEmojiFormatter());
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        header.isNotEmpty
            ? Column(
          children: [
            Text(
              header.tr,
              style:
              TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 7.sp,
            )
          ],
        )
            : const SizedBox(),
        TextFormField(
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: controller,
          textCapitalization: textCapitalization ?? TextCapitalization.none,
          style: TextStyle(
              fontSize: 16.sp,
              color: (readOnly ?? false) ? AppColors.black : AppColors.grey93),
          readOnly: readOnly ?? false,
          validator: validator,
          obscureText: obscureText ?? false,
          onChanged: onChange,
          inputFormatters: combinedFormatters.isNotEmpty ? combinedFormatters : null,
          keyboardType: textInputType,
          smartDashesType: SmartDashesType.enabled,
          maxLines: maxLInes ?? 1,
          minLines: minLines ?? 1,
          maxLength: maxLength,
          decoration: InputDecoration(
            isDense: false,
            suffixIcon: Container(
              padding: EdgeInsets.only(right: 13.sp),
              child: icon,
            ),
            suffixIconConstraints: BoxConstraints(
              maxHeight: 25.sp,
              maxWidth: 80.sp,
            ),
            counterText: "",
            hintText: placeHolder,
            hintStyle: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.grey122),
            contentPadding:
            EdgeInsets.symmetric(horizontal: 15.sp, vertical: 13.sp),
            alignLabelWithHint: true,
            errorText: (errorText ?? "").isEmpty ? null : errorText,
            filled: true,
            fillColor: (readOnly ?? false)
                ? Get.theme.indicatorColor.withOpacity(.1)
                : Get.theme.primaryColor,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.sp),
                borderSide: BorderSide(
                    color: (readOnly ?? false)
                        ? AppColors.grey249
                        : AppColors.grey155)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.sp),
                borderSide: BorderSide(
                    color: (readOnly ?? false)
                        ? AppColors.grey249
                        : AppColors.grey155)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.sp),
                borderSide: BorderSide(
                    color: (readOnly ?? false)
                        ? AppColors.grey249
                        : AppColors.grey155)),
            disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.sp),
                borderSide: BorderSide(
                    color: (readOnly ?? false)
                        ? AppColors.grey249
                        : AppColors.grey155)),
          ),
        )
      ],
    );
  }
}
// ignore: must_be_immutable
class AppDropDownFormField<T> extends StatelessWidget {
  final String header;
  final String? placeHolder;
  final String? errorText;
  final bool? validationNeeded;
  final double? width;
  final bool? readOnly;
  final String? Function(T) label;
  T? value;
  final String? Function(T?)? validator;
  void Function(T?)? onChange;
  final List<T> itemList;

  AppDropDownFormField(
      {super.key,
      required this.header,
      required this.onChange,
      required this.value,
      required this.itemList,
      this.errorText,
      this.width,
      this.readOnly,
      this.placeHolder,
      required this.label,
      this.validationNeeded,
      this.validator});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            header,
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 7.sp,
          ),
          AbsorbPointer(
            absorbing: readOnly ?? false,
            child: DropdownButtonFormField<T>(
                iconSize: 0,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: validator ??
                    (value) {
                      if (value == null) {
                        return errorText ?? "This field is required";
                      } else {
                        return null;
                      }
                    },
                itemHeight: null,
                isExpanded: true,
                hint: Text(
                  placeHolder ?? "Select",
                  style: TextStyle(color: AppColors.grey122, fontSize: 14.sp),
                ),
                style: TextStyle(
                  fontSize: 16.sp,
                ),
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(
                        horizontal: 15.sp, vertical: 13.sp),
                    floatingLabelAlignment: FloatingLabelAlignment.start,
                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                    filled: true,
                    counterText: "",
                    fillColor: (readOnly ?? false)
                        ? Get.theme.indicatorColor.withOpacity(.1)
                        : Get.theme.primaryColor,
                    border: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: (readOnly ?? false)
                                ? AppColors.grey249
                                : AppColors.grey155),
                        borderRadius: BorderRadius.circular(8.sp)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: (readOnly ?? false)
                                ? AppColors.grey249
                                : AppColors.grey155),
                        borderRadius: BorderRadius.circular(8.sp)),
                    focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: (readOnly ?? false)
                                ? AppColors.grey249
                                : AppColors.grey155),
                        borderRadius: BorderRadius.circular(8.sp)),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: (readOnly ?? false)
                                ? AppColors.grey249
                                : AppColors.grey155),
                        borderRadius: BorderRadius.circular(8.sp))),
                isDense: true,
                iconEnabledColor: AppColors.grey122,
                iconDisabledColor: AppColors.grey122,
                items: itemList
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(
                            label(e) ?? "",
                            style: TextStyle(
                                fontSize: 16.sp, color: AppColors.grey93),
                          ),
                        ))
                    .toList(),
                value: value,
                onChanged: onChange),
          ),
        ],
      ),
    );
  }
}

Map<String, Color> themeColors = {
  "Black": Get.testMode ? AppColors.black : AppColors.white
};

extension ThemeColorChange on String {
  Color get theme => themeColors[this] ?? Colors.white;
}
