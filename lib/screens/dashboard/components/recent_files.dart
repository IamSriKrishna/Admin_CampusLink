import 'dart:async';
import 'dart:convert';
import 'package:admin/Api/Leave.dart';
import 'package:admin/Service/FormService.dart';
import 'package:admin/Service/SendFcm.dart';
import 'package:admin/models/sheet_User.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';

class RecentFiles extends StatefulWidget {
  const RecentFiles({
    Key? key,
  }) : super(key: key);

  @override
  State<RecentFiles> createState() => _RecentFilesState();
}

class _RecentFilesState extends State<RecentFiles> {
  FormService _formService = FormService();
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
    return Container(
      padding: EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        color: secondaryColor,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Recent Files",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              columnSpacing: defaultPadding,
              // minWidth: 600,
              columns: [
                DataColumn(
                  label: Text("ID"),
                ),
                DataColumn(
                  label: Text("Student Name"),
                ),
                DataColumn(
                  label: Text("Class"),
                ),
                DataColumn(
                  label: Text("From"),
                ),
                DataColumn(
                  label: Text("To"),
                ),
                DataColumn(
                  label: Text("Form Type"),
                ),
                DataColumn(
                  label: Text("Reason"),
                ),
                DataColumn(
                  label: Text("Status"),
                ),
              ],
              rows: List.generate(
                data.length,
                (index) => DataRow(
                  cells: [
                    DataCell(Text('${index + 1}')),
                    DataCell(Text(data[data.length - index - 1]['name'])),
                    DataCell(
                        Text(data[data.length - index - 1]['Studentclass'])),
                    DataCell(Text(data[data.length - index - 1]['from'])),
                    DataCell(Text(data[data.length - index - 1]['to'])),
                    DataCell(Text(data[data.length - index - 1]['formtype'])),
                    DataCell(
                      Text('Click to View'),
                      onTap: () async {
                        showCupertinoDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: Text(
                                "Reason For ${data[data.length - index - 1]['formtype']}"),
                            content:
                                Text(data[data.length - index - 1]['reason']),
                            actions: [
                              CupertinoDialogAction(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Ok"))
                            ],
                          ),
                        );
                      },
                    ),
                    DataCell(
                      Text(
                        data[data.length - index - 1]['response'],
                        style: TextStyle(
                            color: data[data.length - index - 1]['response'] ==
                                    "Requested"
                                ? Colors.yellow
                                : data[data.length - index - 1]['response'] ==
                                        "Accepted"
                                    ? Colors.green
                                    : data[data.length - index - 1]
                                                ['response'] ==
                                            "OnProcess"
                                        ? Colors.blue
                                        : Colors.red),
                      ),
                      onTap: () {
                        showCupertinoDialog(
                          barrierDismissible: true,
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: Text(
                                "Reason For ${data[data.length - index - 1]['formtype']}"),
                            content:
                                Text(data[data.length - index - 1]['reason']),
                            actions: [
                              CupertinoDialogAction(
                                  textStyle: TextStyle(color: Colors.green),
                                  onPressed: () {
                                    _formService.formResponse(
                                        formid: data[data.length - index - 1]
                                            ['_id'],
                                        response: 'Accepted');
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    "Approve",
                                  )),
                              CupertinoDialogAction(
                                  textStyle: TextStyle(color: Colors.red),
                                  onPressed: () {
                                    _formService.formResponse(
                                        formid: data[data.length - index - 1]
                                            ['_id'],
                                        response: 'Rejected');
                                    FCMNotification().sendNotification(
                                      data[data.length - index - 1]['fcmtoken'],
                                      'HoD ,Approved Your request',
                                    );
                                    Navigator.pop(context);
                                  },
                                  child: Text("Reject"))
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
