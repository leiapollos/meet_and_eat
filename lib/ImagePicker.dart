import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:meet_and_eat/authentication_service.dart';
import 'package:provider/provider.dart';


class ImagePickerWidget extends StatefulWidget {
  final String uid;

  const ImagePickerWidget ({ Key key, this.uid }): super(key: key);
  @override
  _ImagePickerWidget createState() => _ImagePickerWidget();
}

class _ImagePickerWidget extends State<ImagePickerWidget> {
  File _image;
  String _uploadedFileURL;
  final picker = ImagePicker();
  CollectionReference users = FirebaseFirestore.instance.collection('profiles');

  Future<void> saveImage() async {
      String imageURL = await uploadFile();
  }

  Future sleep1() {
    return new Future.delayed(const Duration(seconds: 1), () => "1");
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_pictures/${widget.uid}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    //uploadTask.
    _showMaterialDialog(uploadTask);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        users
            .doc(widget.uid)
            .update({
          'url': _uploadedFileURL
        })
            .then((value) => {
          print("Image Reference added" + _uploadedFileURL),})
            .catchError((error) => print("Failed to add image reference: $error"));
      });
    });
  }
  String _bytesTransferred(StorageTaskSnapshot snapshot) {
    double res = snapshot.bytesTransferred / 1024.0;
    double res2 = snapshot.totalByteCount / 1024.0;
    return '${res.truncate().toString()}/${res2.truncate().toString()}';
  }
  _showMaterialDialog(StorageUploadTask task) {
    showDialog(
        context: context,
        builder: (_) => new StreamBuilder(
      stream: task.events,
      builder: (BuildContext context, snapshot) {
        Widget subtitle;
        if (snapshot.hasData) {
          final StorageTaskEvent event = snapshot.data;
          final StorageTaskSnapshot snap = event.snapshot;
          subtitle = Text('${_bytesTransferred(snap)} KB sent');
        } else {
          subtitle = const Text('Starting...');
        }
        return AlertDialog(
          title: task.isComplete && task.isSuccessful
              ? new Text(
            'Done',
          )
              : new Text(
            'Uploading',
          ),
          content: subtitle,
          actions: <Widget>[
            FlatButton(
              child: Text('Close me!'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    )
    );
  }
 /* Widget _uploadStatus(StorageUploadTask task) {
    return StreamBuilder(
      stream: task.events,
      builder: (BuildContext context, snapshot) {
        Widget subtitle;
        if (snapshot.hasData) {
          final StorageTaskEvent event = snapshot.data;
          final StorageTaskSnapshot snap = event.snapshot;
          subtitle = Text('${_bytesTransferred(snap)} KB sent');
        } else {
          subtitle = const Text('Starting...');
        }
        return ListTile(
          title: s.isComplete && s.isSuccessful
              ? Text(
            'Done',
            style: detailStyle,
          )
              : Text(
            'Uploading',
            style: detailStyle,
          ),
          subtitle: subtitle,
        );
      },
    );
  }*/

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        saveImage();
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> downloadURLExample() async {
   // String downloadURL = await users.doc(widget.uid)['url'];// Within your widgets:
    // Image.network(downloadURL);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot>(
        future: users.doc(widget.uid).get(),
    builder:
    (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

      if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data.data();
          if(snapshot.data.exists && data['url'] != null && data['url'].toString().isNotEmpty){
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ Center(
                child: _image == null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.network(data['url'], height: 160, width: 160,),//Image.asset('assets/images/chimo.png', height: 160,),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.file(_image, height: 160, width: 160,),
                ),
              ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 100, right: 0, bottom: 0),
                  child: FloatingActionButton(
                    onPressed: getImage,
                    tooltip: 'Pick Image',
                    child: Icon(Icons.add_a_photo),
                  ),
                ),
              ]
            );
        }
      }


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
              padding: const EdgeInsets.only(
                  left: 0, top: 100, right: 0, bottom: 0),
              child: FloatingActionButton(
                onPressed: getImage,
                tooltip: 'Pick Image',
                child: Icon(Icons.add_a_photo),
              ),
            ),
          ]
      );
    }
    );
    }
}

/*
*   Future<void> saveImages(List<File> _images, DocumentReference ref) async {
    _images.forEach((image) async {
      String imageURL = await uploadFile(image);
      ref.update({"images": FieldValue.arrayUnion([imageURL])});
    });
  }

  Future<String> uploadFile(File _image) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('profile_pictures/${Path.basename(_image.path)}');
    UploadTask uploadTask = storageReference.putFile(_image);
    await uploadTask.onComplete;
    print('File Uploaded');
    String returnURL;
    await storageReference.getDownloadURL().then((fileURL) {
      returnURL =  fileURL;
    });
    return returnURL;
  }
* */