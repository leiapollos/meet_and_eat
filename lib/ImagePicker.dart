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
  final bool isMeal;
  final bool showUploadButton;

  const ImagePickerWidget ({ Key key, this.uid , this.isMeal = false, this.showUploadButton = true}): super(key: key);
  @override
  _ImagePickerWidget createState() => _ImagePickerWidget();
}

class _ImagePickerWidget extends State<ImagePickerWidget> {
  File _image;
  String _uploadedFileURL;
  final picker = ImagePicker();
  CollectionReference users = FirebaseFirestore.instance.collection('profiles');
  CollectionReference meals = FirebaseFirestore.instance.collection('meals');

  Future<void> saveImage() async {
      String imageURL = await uploadFile();
  }

  Future sleep1() {
    return new Future.delayed(const Duration(seconds: 1), () => "1");
  }

  Future uploadFile() async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child(widget.isMeal ? 'meals_pictures/${widget.uid}' : 'profile_pictures/${widget.uid}');
    StorageUploadTask uploadTask = storageReference.putFile(_image);
    //uploadTask.
    _showMaterialDialog(uploadTask);
    await uploadTask.onComplete;
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      setState(() {
        _uploadedFileURL = fileURL;
        if(widget.isMeal){
          meals
              .doc(widget.uid)
              .update({
            'url': _uploadedFileURL
          })
              .then((value) => {
            print("Image Reference added" + _uploadedFileURL),})
              .catchError((error) => print("Failed to add image reference: $error"));
        }
        else{
          users
              .doc(widget.uid)
              .update({
            'url': _uploadedFileURL
          })
              .then((value) => {
            print("Image Reference added" + _uploadedFileURL),})
              .catchError((error) => print("Failed to add image reference: $error"));
        }
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
        future: widget.isMeal ? meals.doc(widget.uid).get() : users.doc(widget.uid).get(),
    builder:
    (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {

      if (snapshot.connectionState == ConnectionState.done){
          Map<String, dynamic> data = snapshot.data.data();
          if(snapshot.data.exists && data['url'] != null && data['url'].toString().isNotEmpty){

            print("f");
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [ Center(
                child: /*_image == null
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.network(data['url'], height: 160, width: 160,),//Image.asset('assets/images/chimo.png', height: 160,),
                )
                    : ClipRRect(
                  borderRadius: BorderRadius.circular(200),
                  child: Image.file(_image, height: 160, width: 160,),
                ),*/
                CircleAvatar(
                  radius: 75,
                  backgroundImage:  (data['url'] != null && data['url'].toString().isNotEmpty) ? NetworkImage(data['url']) : NetworkImage(
                    'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png',
                  ),
                  backgroundColor: Colors.blue,
                ),
              ),
                (widget.showUploadButton) ?
              Padding(
                  padding: const EdgeInsets.only(
                      left: 0, top: 100, right: 100, bottom: 0),
                  child: FloatingActionButton(
                    backgroundColor: Color(0xff3d405b),
                    onPressed: getImage,
                    tooltip: 'Pick Image',
                    child: Icon(Icons.add_a_photo),
                  ),
                )
                : Container(),
              ]
            );
        }
      }

      print("h");
      return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [ Center(
            child: _image == null
                ? ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Image.network(
                'https://cdn.pixabay.com/photo/2013/07/13/12/07/avatar-159236_640.png', height: 160, fit: BoxFit.cover,),
            )
                : ClipRRect(
              borderRadius: BorderRadius.circular(200),
              child: Image.file(_image, height: 160,),
            ),
          ),
            (widget.showUploadButton) ?
            Padding(
              padding: const EdgeInsets.only(
                  left: 0, top: 100, right: 00, bottom: 0),
              child: FloatingActionButton(
                backgroundColor: Color(0xff3d405b),
                onPressed: getImage,
                tooltip: 'Pick Image',
                child: Icon(Icons.add_a_photo),
              ),
            ) : Container()
          ]
      );
    }
    );
    }
}
