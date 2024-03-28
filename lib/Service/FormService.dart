// ignore_for_file: prefer_const_declarations, use_build_context_synchronously

import 'dart:convert';
import 'package:admin/Model/Form.dart';
import 'package:admin/uri.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class FormService {
  //Upload Form
  void UploadForm(
      {required BuildContext context,
      required String rollno,
      required String name,
      required String department,
      required String image,
      required String year,
      required String formtype,
      required String studentclass,
      required String reason,
      required int no_of_days,
      required String from,
      required String to,
      required DateTime createdAt,
      required String id,
      required int spent,
      required String fcmtoken}) async {
    try {
      FormModel user = FormModel(
          spent: spent,
          id: '',
          name: name,
          studentid: id,
          rollno: rollno,
          department: department,
          dp: image,
          no_of_days: no_of_days,
          from: from,
          fcmtoken: fcmtoken,
          to: to,
          response: '',
          createdAt: createdAt,
          year: year,
          formtype: formtype,
          studentclass: studentclass,
          reason: reason);

      http.Response res = await http.post(
        Uri.parse('$url/kcg/student/form-upload'),
        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
    } catch (e) {
      print(e.toString());
    }
  }

  //Display AllForm
  Future<List<FormModel>> DisplayAllForm({
    required BuildContext context,
  }) async {
    List<FormModel> form = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$url/kcg/student/form'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print("response=${res.body}");
      if (res.statusCode == 200) {
        for (int i = 0; i < jsonDecode(res.body).length; i++) {
          form.add(
            FormModel.fromJson(
              jsonEncode(
                jsonDecode(res.body)[i],
              ),
            ),
          );
        }
      }
    } catch (e) {
      print(e.toString());
    }
    return form;
  }

  Future<void> formResponse({
    //required BuildContext context,
    required String formid,
    required String response,
  }) async {
    try {
      final Map<String, dynamic> data = {'response': response};
      http.Response res = await http.put(
        Uri.parse('$url/kcg/student/form/$formid/update-form'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(data),
      );
      if (res.statusCode == 200) {
        print('Form updated successfully');
        // You can handle success here
      } else {
        print('Failed to update Form');
        print(res.body);
        // Handle error here
      }
    } catch (e) {
      print(e);
    }
  }
}
