import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:waiver_driver/core/themes/assets/icons.dart';


import '../../colors/app_colors.dart';



//
// import '../app_colors/app_colors.dart';
// import '../assets/icons.dart';
// import '../text_style/test_style.dart';
//
// class AppTextFormFieldRangeCalender extends StatelessWidget {
//   final String placeHolder;
//   final String? label;
//
//   final TextEditingController controller;
//
//   const AppTextFormFieldRangeCalender({
//     super.key,
//     required this.placeHolder,
//     required this.controller,
//     this.label,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     DateFormat dateFormat = DateFormat("d / MMM / yyyy");
//     return InkWell(
//       onTap: () async {
//         DateTimeRange? timeRange = await showDateRangePicker(
//             context: context,
//             firstDate: DateTime(1998),
//             initialEntryMode: DatePickerEntryMode.calendarOnly,
//             lastDate: DateTime.now(),
//             helpText: label,
//             builder: (context, child) {
//               return Theme(
//                 data: ThemeData(
//                   colorScheme: ColorScheme.light(
//                     primary: AppColors.black,
//                   ),
//                   textTheme: TextTheme(
//                     headlineSmall: albertSansRegular.copyWith(fontSize: 20.sp),
//                     titleLarge: albertSansRegular.copyWith(fontSize: 20.sp),
//                     labelSmall: albertSansRegular.copyWith(fontSize: 20.sp),
//                     bodyLarge: albertSansRegular.copyWith(fontSize: 20.sp),
//                     titleMedium:
//                         albertSansRegular.copyWith(fontSize: 20.sp), // input
//                     titleSmall: albertSansRegular.copyWith(
//                         fontSize: 10), // month/year picker
//                     bodySmall:
//                         albertSansRegular.copyWith(fontSize: 20.sp), // days
//                   ),
//                 ),
//                 child: child!,
//               );
//             });
//
//         if (timeRange != null) {
//           // dateRange = DateTimeRange(start: DateTime.now(), end: DateTime.now());
//           controller.text =
//               "${dateFormat.format(timeRange.start)}  - ${dateFormat.format(timeRange.end)}";
//         }
//       },
//       child: IgnorePointer(
//         child: TextFormField(
//           autovalidateMode: AutovalidateMode.onUserInteraction,
//           controller: controller,
//           decoration: InputDecoration(
//             isDense: false,
//             suffixIcon: Container(
//               padding: EdgeInsets.all(15.sp),
//               child: SvgPicture.asset(
//                 AppIcons.calender,
//               ),
//             ),
//             counterText: "",
//             contentPadding:
//                 EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
//             label: Text(placeHolder),
//             floatingLabelStyle: albertSansRegular.copyWith(
//                 fontSize: 14.sp, color: AppColors.black),
//             labelStyle: albertSansRegular.copyWith(
//                 fontSize: 14.sp, color: AppColors.black),
//             filled: true,
//             fillColor: AppColors.white,
//             border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.sp),
//                 borderSide: BorderSide(color: AppColors.grey187)),
//             enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.sp),
//                 borderSide: BorderSide(color: AppColors.grey187)),
//             focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.sp),
//                 borderSide: BorderSide(color: AppColors.grey187)),
//             disabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(10.sp),
//                 borderSide: BorderSide(color: AppColors.grey187)),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
class AppDatePickerFormField extends StatelessWidget {
  final String header;
  final String? placeHolder;
  final String? label;
  final bool? readOnly;
  final void Function()? readOnlyCallBack;
  final DateTime? initialDate;
  final Widget? icon;
  final DateTime? lastDate;
  final DateTime? startDate;
  final TextEditingController controller;
  final String? Function(String?)? validator;

  const AppDatePickerFormField(
      {super.key,
      required this.header,
      this.readOnly,
      this.readOnlyCallBack,
      this.placeHolder,
      this.icon,
      this.initialDate,
      this.lastDate,
      this.startDate,
      required this.controller,
      this.label,
      this.validator});

  @override
  Widget build(BuildContext context) {
    DateFormat dateFormat = DateFormat("d / MMM / yyyy");
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          header,
          style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 7.sp,
        ),
        InkWell(
          onTap: (readOnly ?? false)
              ? readOnlyCallBack
              : () async {
                  DateTime? date = await showDatePicker(
                      context: context,
                      firstDate: startDate ?? DateTime(1998),
                      lastDate: lastDate ?? DateTime.now(),
                      helpText: label,
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData(
                            colorScheme: ColorScheme.light(
                              primary: AppColors.black,
                            ),
                          ),
                          child: child!,
                        );
                      },
                      initialDate: initialDate ?? startDate ?? DateTime.now());

                  if (date != null) {
                    controller.text = dateFormat.format(date);
                  }
                },
          child: IgnorePointer(
            child: TextFormField(
              style: TextStyle(
                  color: readOnly ?? false ? AppColors.black : AppColors.grey93,
                  fontSize: 14.sp),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              controller: controller,
              readOnly: readOnly ?? false,
              validator: validator,
              decoration: InputDecoration(
                isDense: false,
                suffixIconConstraints: BoxConstraints(
                  maxHeight: 25.sp,
                  maxWidth: 65.sp,
                ),
                suffixIcon: Container(
                  padding: EdgeInsets.only(right: 13.sp),
                  child: icon ??
                      Image.asset(
                        AppIcons.calender,
                      ),
                ),
                hintText: placeHolder ?? "Select",
                hintStyle: TextStyle(fontSize: 14.sp, color: AppColors.grey122),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 15.sp, vertical: 15.sp),
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
            ),
          ),
        ),
      ],
    );
  }
}
