import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class ImagePickerWidget extends StatefulWidget {
  @override
  _ImagePickerWidget createState() => _ImagePickerWidget();
}

class _ImagePickerWidget extends State<ImagePickerWidget> {
  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [ Center(
        child: _image == null
            ? ClipRRect(
        borderRadius: BorderRadius.circular(200),
    child: Image.asset('assets/images/chimo.png', height: 160,),
    )
            : ClipRRect(
          borderRadius: BorderRadius.circular(200),
          child: Image.file(_image, height: 160,),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 0, top: 100, right: 0, bottom: 0),
        child: FloatingActionButton(
          onPressed: getImage,
          tooltip: 'Pick Image',
          child: Icon(Icons.add_a_photo),
        ),
      ), ]
    );
  }
}