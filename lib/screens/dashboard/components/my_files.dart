
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:admin/responsive.dart';
import 'package:flutter/material.dart';
import 'package:admin/models/MyFiles.dart';
import '../../../constants.dart';
import 'file_info_card.dart';

class MyFiles extends StatelessWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "My Files",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            ElevatedButton.icon(
              style: TextButton.styleFrom(
                padding: EdgeInsets.symmetric(
                  horizontal: defaultPadding * 1.5,
                  vertical:
                      defaultPadding / (Responsive.isMobile(context) ? 2 : 1),
                ),
              ),
              onPressed: () {},
              icon: Icon(Icons.add),
              label: Text("Add New"),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 ? 1.3 : 1,
          ),
          tablet: FileInfoCardGridView(),
          desktop: FileInfoCardGridView(
            childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
          ),
        ),
      ],
    );
  }
}

class FileInfoCardGridView extends StatefulWidget {
  const FileInfoCardGridView({
    Key? key,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  State<FileInfoCardGridView> createState() => _FileInfoCardGridViewState();
}

class _FileInfoCardGridViewState extends State<FileInfoCardGridView> {
  List<dynamic> data = [];
  late Timer _timer; // Define the timer

  void FetchODForm() async {
    final Uri uri = Uri.parse("http://65.2.137.77:3000/kcg/student/form");
    try {
      final http.Response res =
          await http.get(uri, headers: {"content-type": "application/json"});
      if (res.statusCode == 200) {
        setState(() {
          data = jsonDecode(res.body);
        });
      } else {
        print("Status Code ------------> ${res.statusCode}");
      }
    } catch (e) {
      print(e);
    }
  }
Set<int> exportedIds = Set<int>();
  @override
  void initState() {
    FetchODForm();
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      FetchODForm();
    });
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: data.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) => FileInfoCard(
        onTap: () {
          
        },
        color: Colors.black, maxLengthOfForm: "100", title: data[1]['formtype'], totalLengthOfForm: data.length,percentage: data.length,),
    );
  }
}
