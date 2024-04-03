import 'dart:async';
import 'dart:io';

import 'package:admin/Service/AddPost.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void CustomAddpost(BuildContext context) {
  String? _image;
  bool check = false;
  File? _theImage;
  TextEditingController _title = TextEditingController();
  TextEditingController _description = TextEditingController();
  TextEditingController _link = TextEditingController();
  AddPostService _addPostService = AddPostService();
  Future<void> addPost(BuildContext context, String description, String title,
      String link, List<File> images) async {
    await _addPostService.uploadPost(
        context: context,
        description: description,
        title: title,
        link: link,
        images: images);
  }

  showCupertinoDialog(
    barrierDismissible: true,
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return Center(
            child: CupertinoActionSheet(
              title: Text(
                'Create Post',
                style: TextStyle(color: Colors.white),
              ),
              message: Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                width: MediaQuery.of(context).size.width * 0.8,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        final pickedFile = await ImagePicker()
                            .pickImage(source: ImageSource.gallery);
                        if (pickedFile != null) {
                          setState(() {
                            _image = pickedFile.path;
                            _theImage = File(pickedFile.path);
                          });
                        }
                      },
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.network(
                                _image!,
                                height: 300,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                            )
                          : DottedBorder(
                              color: Colors.grey,
                              borderType: BorderType.RRect,
                              radius: Radius.circular(12),
                              padding: EdgeInsets.all(6),
                              child: Container(
                                height: 300,
                                width: double.infinity,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.image,
                                      size: 80,
                                      color: Colors.grey,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Tap to add an image or video',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                    ),
                    SizedBox(height: 20),
                    CupertinoTextField(
                      controller: _title,
                      padding: EdgeInsets.all(10),
                      minLines: 1,
                      style: TextStyle(color: Colors.white),
                      placeholder: 'Write a caption...',
                      decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                check==true ? Colors.red : Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),
                    CupertinoTextField(
                      controller: _description,
                      padding: EdgeInsets.all(10),
                      minLines: 1,
                      style: TextStyle(color: Colors.white),
                      placeholder: 'Write a Description...',
                      decoration: BoxDecoration(
                        border: Border.all(
                            color:
                                check==true ? Colors.red : Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      maxLines: 3,
                    ),
                    SizedBox(height: 20),
                    CupertinoTextField(
                      controller: _link,
                      padding: EdgeInsets.all(10),
                      minLines: 1,
                      style: TextStyle(color: Colors.blue),
                      placeholder: 'Link',
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
              actions: [
                CupertinoDialogAction(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Cancel'),
                ),
                CupertinoDialogAction(
                  onPressed: () {
                    if (_title.text.isEmpty || _description.text.isEmpty) {
                      setState(() {
                        check = true;
                      });
                    } else {
                      setState(() {
                        check = false;
                      });
                      addPost(
                          context,
                          _title.text,
                          _description.text,
                          _link.text.isEmpty || _title.text == ''
                              ? 'null'
                              : _link.text,
                          [_theImage!]).then((value) => Navigator.pop(context));
                    }
                  },
                  child: Text('Post'),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}
