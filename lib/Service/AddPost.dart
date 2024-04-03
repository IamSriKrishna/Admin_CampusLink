// ignore_for_file: avoid_print, use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:admin/models/post.dart';
import 'package:admin/uri.dart';
import 'package:animated_snack_bar/animated_snack_bar.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AddPostService {


  Future<void> uploadPost({
    required BuildContext context,
    required String description,
    required String title,
    required String link,
    required List<File> images,
  }) async {
    try {
      final cloudinary = CloudinaryPublic('dadtmv9ma', 't154mm7k');
      List<String> imageUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: 'Post'),
        );
        imageUrls.add(res.secureUrl);
      }

      Post post = Post(
          id: '',
          name: 'Dr.Cloudin S',
          dp: 'https://img.myloview.com/posters/default-avatar-profile-flat-icon-social-media-user-vector-portrait-of-unknown-a-human-image-400-209987471.jpg',
          image_url: imageUrls,
          link: link,
          likes: [],
          myClass: 'All',
          certified: 'No',
          senderId: 'HoD',
          description: description,
          title: title,
          createdAt: DateTime.now());

      http.Response res = await http.post(
        Uri.parse('$url/post/faculty/createPostData'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token':
              "dHv4COCjSei5mP7B5Xx8SA:APA91bEiwCYvlb7fUq249t73AqXaCYVF4o4hQQeWrm8Xbl2JxIkcziAbJ-yZaGdzSk_U_1-jmoSC0IoIazKwZU3dwyKR5rFLMcxVf3R0DOBX_0TJ8rbvrfhjmZmZIHcQDvVpfjEi5HwU",
        },
        body: post.toJson(),
      );

      if (res.statusCode == 200) {
        print('Successfull');
        AnimatedSnackBar.material(
          'Successfully Posted',
          type: AnimatedSnackBarType.info,
        ).show(context);
      } else {
        print(res.body);
        print(res.request);
        print('--------------------->${res.statusCode}');
      }
    } catch (error) {
      print('Failed:$error');
    }
  }

  Future<List<Post>> DisplayAllForm({
    required BuildContext context,
  }) async {
    List<Post> form = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$url/post/getAllPostData'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      print("response=${res.body}");
      for (int i = 0; i < jsonDecode(res.body).length; i++) {
        form.add(
          Post.fromJson(
            jsonEncode(
              jsonDecode(res.body)[i],
            ),
          ),
        );
      }
    } catch (e) {
      AnimatedSnackBar.material(
        e.toString(),
        type: AnimatedSnackBarType.info,
      ).show(context);
    }
    return form;
  }
}
