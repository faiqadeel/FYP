import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app/components/Colors.dart';
import 'package:my_app/components/textFieldComponent.dart';

class CreatePost extends StatefulWidget {
  final String name;
  const CreatePost({super.key, required this.name});
  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePost> {
  File? _media;
  final ImagePicker _picker = ImagePicker();
  final TextEditingController _descriptionController = TextEditingController();

  Future<void> _pickMedia() async {
    final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery); // or use pickVideo for video
    if (pickedFile != null) {
      setState(() {
        _media = File(pickedFile.path);
      });
    }
  }

  // Future<void> _postToFirestore() async {
  //   if (_media != null && _descriptionController.text.isNotEmpty) {
  //     // Upload media to Firebase Storage
  //     // String fileName = basename(_media!.path);
  //     Reference storageRef =
  //         FirebaseStorage.instance.ref().child('post_media/$fileName');

  //     try {
  //       // Start upload
  //       UploadTask uploadTask = storageRef.putFile(_media!);

  //       // Await completion of upload
  //       TaskSnapshot snapshot = await uploadTask;

  //       // Get the URL of the uploaded media
  //       String mediaUrl = await snapshot.ref.getDownloadURL();

  //       // Post information to Firestore
  //       await FirebaseFirestore.instance.collection('Posts').add({
  //         'photo/video url': mediaUrl,
  //         'posted by': 'User', // Replace with actual user identifier
  //         'likes': 0,
  //         'Description': _descriptionController.text,
  //       });

  //       // Clear the fields after posting
  //       setState(() {
  //         _media = null;
  //         _descriptionController.clear();
  //       });
  //     } catch (e) {
  //       print("Error uploading media: $e");
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Post", style: AppBarTextStyle()),
        centerTitle: true,
        backgroundColor: AppBarBackground(),
      ),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _media != null
                ? Image.file(_media!)
                : const SizedBox(
                    height: 200,
                    child: Center(child: Text('No media selected'))),
            ElevatedButton(
              onPressed: _pickMedia,
              style: ElevatedButton.styleFrom(
                  backgroundColor: button1(), fixedSize: const Size(200, 50)),
              child: const Text(
                'Select Photo/Video',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _descriptionController,
                decoration: InputDecoration(
                    hintText: 'Say something about the post...',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5))),
                maxLines: 4,
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  backgroundColor: button1(), fixedSize: const Size(100, 40)),
              onPressed: () {},
              child: const Text('Post',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
