import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyPage extends StatelessWidget {
  final String? text;
  const EmptyPage({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Text("No Data found",
            style: TextStyle(fontSize: 25.sp, fontWeight: FontWeight.bold)));
  }
}
