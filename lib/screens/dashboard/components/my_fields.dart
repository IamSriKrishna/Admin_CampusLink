import 'dart:async';
import 'dart:convert';
import 'package:admin/Api/Leave.dart';
import 'package:admin/Api/OnDuty.dart';
import 'package:admin/Api/gatepass.dart';
import 'package:admin/Util/customSnackbar.dart';
import 'package:admin/models/sheet_User.dart';
import 'package:admin/responsive.dart';
import 'package:admin/uri.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../../../constants.dart';
import 'file_info_card.dart';

class MyFiles extends StatefulWidget {
  const MyFiles({
    Key? key,
  }) : super(key: key);

  @override
  State<MyFiles> createState() => _MyFilesState();
}

class _MyFilesState extends State<MyFiles> {
  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Computer Science and Engineering",
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
              label: Text("Add Students"),
            ),
          ],
        ),
        SizedBox(height: defaultPadding),
        Responsive(
          mobile: FileInfoCardGridView(
            crossAxisCount: _size.width < 650 ? 2 : 4,
            childAspectRatio: _size.width < 650 && _size.width > 350 ? 1.3 : 1,
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

  void fetchData() async {
    final Uri uri = Uri.parse("$url/kcg/student/form");
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

  Future<void> _deleteFormRequests(String formType) async {
    final String apiUrl =
        '$url/forms/$formType/accepted'; // Update with your API endpoint

    try {
      final http.Response response = await http.delete(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json',
          // Add your authentication token here if required
          // 'x-auth-token': 'YOUR_AUTH_TOKEN',
        },
        body: jsonEncode(<String, String>{
          'formType': formType,
        }),
      );

      if (response.statusCode == 200) {
        // Request successful
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        print(responseData['message']);
      } else {
        // Request failed
        print('Failed to delete form requests: ${response.reasonPhrase}');
      }
    } catch (e) {
      // Exception occurred during request
      print('Exception occurred: $e');
    }
  }

  Set<int> exportedIds = Set<int>();
  @override
  void initState() {
    fetchData();
    _timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
      fetchData();
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
    int leaveFormLength =
        data.where((element) => element['formtype'] == 'Leave').length;
    int ondutyFormLength =
        data.where((element) => element['formtype'] == 'On Duty').length;
    int gatepassFormLength =
        data.where((element) => element['formtype'] == 'Gate Pass').length;
    return GridView.builder(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: 3, // Display 3 types of forms: leave, onduty, gatepass
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: widget.crossAxisCount,
        crossAxisSpacing: defaultPadding,
        mainAxisSpacing: defaultPadding,
        childAspectRatio: widget.childAspectRatio,
      ),
      itemBuilder: (context, index) {
        if (index == 0) {
          //Leave Pass
          return FileInfoCard(
            onTap: () async {
              final List<SheetStudent> acceptedUsers = [];
              for (var i = 0; i < data.length; i++) {
                if (data[data.length - i - 1]['response'] == "Accepted" &&
                    data[data.length - i - 1]['formtype'] == "Leave") {
                  final user = SheetStudent(
                    name: data[data.length - i - 1]['name'],
                    Studentclass: data[data.length - i - 1]['Studentclass'],
                    from: data[data.length - i - 1]['from'],
                    to: data[data.length - i - 1]['to'],
                    formtype: data[data.length - i - 1]['formtype'],
                    reason: data[data.length - i - 1]['reason'],
                    response: data[data.length - i - 1]['response'],
                  );
                  acceptedUsers.add(user);
                }
              }
              if (acceptedUsers.isNotEmpty) {
                await LeaveUserSheetApi.insert(
                    acceptedUsers.map((user) => user.toJson()).toList()).then((value) => _deleteFormRequests('Leave'));

                showSnackBar(context: context, text: "Added To Sheet");
              } else {
                showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text("Exporting To Google Sheet"),
                    content: Text("No Users Exported"),
                    actions: [
                      CupertinoDialogAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Ok"))
                    ],
                  ),
                );
              }
            },
            color: Colors.yellow,
            maxLengthOfForm: "100",
            title: "Leave",
            totalLengthOfForm: leaveFormLength,
            percentage: leaveFormLength,
          );
        } else if (index == 1) {
          //On Duty Pass
          return FileInfoCard(
            onTap: () async {
              final List<SheetStudent> acceptedUsers = [];
              for (var i = 0; i < data.length; i++) {
                if (data[data.length - i - 1]['response'] == "Accepted" &&
                    data[data.length - i - 1]['formtype'] == "On Duty") {
                  final user = SheetStudent(
                    name: data[data.length - i - 1]['name'],
                    Studentclass: data[data.length - i - 1]['Studentclass'],
                    from: data[data.length - i - 1]['from'],
                    to: data[data.length - i - 1]['to'],
                    formtype: data[data.length - i - 1]['formtype'],
                    reason: data[data.length - i - 1]['reason'],
                    response: data[data.length - i - 1]['response'],
                  );
                  acceptedUsers.add(user);
                }
              }
              if (acceptedUsers.isNotEmpty) {
                await OnDutyUserSheetApi.insert(
                    acceptedUsers.map((user) => user.toJson()).toList()).then((value) => _deleteFormRequests('On Duty'));

                showSnackBar(context: context, text: "Added To Sheet");
              } else {
                showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text("Exporting To Google Sheet"),
                    content: Text("No Users Exported"),
                    actions: [
                      CupertinoDialogAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Ok"))
                    ],
                  ),
                );
              }
            },
            color: Colors.blue,
            maxLengthOfForm: "100",
            title: "On Duty",
            totalLengthOfForm: ondutyFormLength,
            percentage: ondutyFormLength,
          );
        } else {
          //Gate Pass
          return FileInfoCard(
            onTap: () async {
              final List<SheetStudent> acceptedUsers = [];
              for (var i = 0; i < data.length; i++) {
                if (data[data.length - i - 1]['response'] == "Accepted" &&
                    data[data.length - i - 1]['formtype'] == "Gate Pass") {
                  final user = SheetStudent(
                    name: data[data.length - i - 1]['name'],
                    Studentclass: data[data.length - i - 1]['Studentclass'],
                    from: data[data.length - i - 1]['from'],
                    to: data[data.length - i - 1]['to'],
                    formtype: data[data.length - i - 1]['formtype'],
                    reason: data[data.length - i - 1]['reason'],
                    response: data[data.length - i - 1]['response'],
                  );
                  acceptedUsers.add(user);
                }
              }
              if (acceptedUsers.isNotEmpty) {
                await GatePassUserSheetApi.insert(
                    acceptedUsers.map((user) => user.toJson()).toList()).then((value) => _deleteFormRequests('Gate Pass'));

                showSnackBar(context: context, text: "Added To Sheet");
              } else {
                showCupertinoDialog(
                  barrierDismissible: true,
                  context: context,
                  builder: (context) => CupertinoAlertDialog(
                    title: Text("Exporting To Google Sheet"),
                    content: Text("No Users Exported"),
                    actions: [
                      CupertinoDialogAction(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Ok"))
                    ],
                  ),
                );
              }
            },
            color: Colors.green,
            maxLengthOfForm: "100",
            title: "Gate Pass",
            totalLengthOfForm: gatepassFormLength,
            percentage: gatepassFormLength,
          );
        }
      },
    );
  }
}
