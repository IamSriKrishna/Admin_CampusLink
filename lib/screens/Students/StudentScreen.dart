import 'package:admin/screens/Students/Widget/Top.dart';
import 'package:admin/screens/Students/Widget/TotalStudentList.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';


class StudentScreen extends StatelessWidget {
  final TextEditingController search;
  StudentScreen({required this.search});
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        primary: false,
        padding: EdgeInsets.all(defaultPadding),
        child: Column(
          children: [
            StudentTop(),
            TotalStudentList(
              search: search,
            )
          ],
        ),
      ),
    );
  }
}
