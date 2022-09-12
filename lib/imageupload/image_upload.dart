import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageUpload extends StatefulWidget {
  String? userId;
  ImageUpload({Key? key, required this.userId}) : super(key: key);

  @override
  State<ImageUpload> createState() => _ImageUploadState();
}

class _ImageUploadState extends State<ImageUpload> {
  File? _image;
  final imagePicker = ImagePicker();
  String? downloadUrl;

  //image picker
  Future imagePickerMethod() async {
    //picking the file
    final pick = await imagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pick != null) {
        _image = File(pick.path);
      } else {
        //show snack bar
        showSnackBar(
          'No file selected',
          Duration(milliseconds: 400),
        );
      }
    });
  }

  Future uploadImage() async {
    final postID = DateTime.now().millisecondsSinceEpoch.toString();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    Reference ref = FirebaseStorage.instance
        .ref()
        .child('${widget.userId}/images')
        .child('post_$postID');
    await ref.putFile(_image!);
    downloadUrl = await ref.getDownloadURL();

    await firebaseFirestore
        .collection('user')
        .doc(widget.userId)
        .collection('images')
        .add({'downloadUrl': downloadUrl}).whenComplete(
      () => showSnackBar(
        'Image uploaded successfully',
        Duration(seconds: 2),
      ),
    );
  }

  showSnackBar(String snackText, Duration d) {
    final snackBar = SnackBar(
      content: Text(snackText),
      duration: d,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Upload'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: SizedBox(
              height: 550,
              width: double.infinity,
              child: Column(
                children: [
                  const Text('Upload Image'),
                  const SizedBox(
                    height: 10,
                  ),
                  Expanded(
                    child: Container(
                      width: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.red),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: _image == null
                                  ? const Center(
                                      child: Text('No image selected'),
                                    )
                                  : Image.file(_image!),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                imagePickerMethod();
                              },
                              child: Text('Select image'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                //upload only when the image has some values
                                if (_image != null) {
                                  uploadImage();
                                } else {
                                  showSnackBar(
                                    'Select image first',
                                    Duration(microseconds: 400),
                                  );
                                }
                              },
                              child: Text('Upload image'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
