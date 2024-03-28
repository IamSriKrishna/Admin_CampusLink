import 'dart:async';
import 'dart:convert';
import 'package:admin/uri.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../../constants.dart';

class TotalStudentList extends StatefulWidget {
  final TextEditingController search;
  const TotalStudentList({
    Key? key,
    required this.search,
  }) : super(key: key);

  @override
  State<TotalStudentList> createState() => _TotalStudentListState();
}

class _TotalStudentListState extends State<TotalStudentList> {
  List<Map<String, dynamic>> searchResults = [];
  bool _searched = false;

Future<void> fetchData() async {
  if (widget.search.text.isEmpty) {
    setState(() {
      _searched = false;
      searchResults = [];
    });
    return;
  }

  final response = await http.get(
    Uri.parse('$url/students/search?name=${Uri.encodeComponent(widget.search.text)}&rollno=${Uri.encodeComponent(widget.search.text)}'),
  );

  if (response.statusCode == 200) {
    setState(() {
      _searched = false;
      searchResults = List<Map<String, dynamic>>.from(jsonDecode(response.body));
    });
  } else {
    setState(() {
      _searched = true;
      searchResults = [];
    });
    throw Exception('Failed to load data');
  }
}


  @override
  void initState() {
    super.initState();
    widget.search.addListener(fetchData); 
  }

  @override
  void dispose() {
    widget.search.removeListener(fetchData); 
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
              columns: [
                DataColumn(label: Text("ID")),
                DataColumn(label: Text("Name")),
                DataColumn(label: Text("Register No")),
                DataColumn(label: Text("Class")),
                DataColumn(label: Text("Department")),
                DataColumn(label: Text("Year")),
              ],
              rows: List.generate(
                _searched ? 1 : searchResults.length,
                (index) {
                  if (_searched) {
                    return DataRow(cells: [
                      DataCell(Text('No data found')),
                      DataCell(Text('')),
                      DataCell(Text('')),
                      DataCell(Text('')),
                      DataCell(Text('')),
                      DataCell(Text('')),
                    ]);
                  }
                  return DataRow(
                    cells: [
                      DataCell(Text('${index + 1}')),
                      DataCell(Text(searchResults[index]['name'] ?? '')),
                      DataCell(Text(searchResults[index]['rollno'] ?? '')),
                      DataCell(Text(searchResults[index]['Studentclass'] ?? '')),
                      DataCell(Text(searchResults[index]['department'] ?? '')),
                      DataCell(Text(searchResults[index]['year'] ?? '')),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
