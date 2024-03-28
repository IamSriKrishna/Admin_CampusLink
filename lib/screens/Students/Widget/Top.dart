
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';

import '../../../constants.dart';
class StudentTop extends StatefulWidget {
  const StudentTop({
    Key? key,
  }) : super(key: key);

  @override
  State<StudentTop> createState() => _StudentTopState();
}

class _StudentTopState extends State<StudentTop> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Search Students",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
      ],
    );
  }
}