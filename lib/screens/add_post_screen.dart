import 'dart:typed_data';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/user_class.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/resources/firestore_methods.dart';
import 'package:flutter_instagram_clone/utlis/colors.dart';
import 'package:flutter_instagram_clone/utlis/custom_image_picker.dart';
import 'package:flutter_instagram_clone/utlis/snackbar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final TextEditingController captionController = TextEditingController();
  @override
  void dispose() {
    captionController.dispose();
    super.dispose();
  }

  bool isLoading = false;
  Uint8List? image;
  selectImage() {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Create a post'),
          children: [
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Choose from gallery',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List? file = await pickImage(ImageSource.gallery, context);
                if (file != null) {
                  setState(() {
                    image = file;
                  });
                }
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Take a photo',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () async {
                Navigator.pop(context);
                Uint8List? file = await pickImage(ImageSource.camera, context);
                if (file != null) {
                  setState(() {
                    image = file;
                  });
                }
              },
            ),
            SimpleDialogOption(
              padding: const EdgeInsets.all(20),
              child: const Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  void postImage({
    required String uid,
    required String userName,
    required String profileImage,
  }) async {
    try {
      if (image == null) {
        showSnackbar(
          context: context,
          text: 'Please pick an image',
          contentType: ContentType.warning,
          title: 'Select image',
        );
        return;
      }
      setState(() {
        isLoading = true;
      });
      String res = await FireStoreMethods().uploadPost(
        file: image!,
        description: captionController.text,
        uid: uid,
        username: userName,
        profileImage: profileImage,
      );
      setState(() {
        isLoading = false;
      });
      bool status = res == 'success';
      if (status) {
        if (context.mounted) {
          showSnackbar(
            context: context,
            text: 'Posted successfully',
            contentType: ContentType.success,
            title: 'Post',
          );
          clearImage();
        }
      }
    } catch (e) {
      if (context.mounted) {
        showSnackbar(
          context: context,
          text: e.toString(),
          contentType: ContentType.failure,
          title: 'Oh snap!',
        );
      }
    }
  }

  void clearImage() {
    setState(() {
      image = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final UserModel user = Provider.of<UserProvider>(context).getUser!;
    if (image == null) {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: mobileBackgroundColor,
          title: const Text('Post'),
          centerTitle: true,
        ),
        body: Center(
          child: IconButton(
            onPressed: () {
              selectImage();
            },
            icon: const Icon(
              Icons.upload,
              size: 60,
            ),
          ),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: mobileBackgroundColor,
          title: const Text('Post to'),
          centerTitle: true,
          leading: IconButton(
            onPressed: clearImage,
            icon: const Icon(
              Icons.arrow_back,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                postImage(
                  uid: user.uid,
                  userName: user.username,
                  profileImage: user.photoUrl,
                );
              },
              child: const Text(
                'Post',
                style: TextStyle(
                  color: Colors.blueAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            )
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              if (isLoading)
                const Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  child: LinearProgressIndicator(),
                ),
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(user.photoUrl),
                      radius: 35,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: captionController,
                        decoration: const InputDecoration(
                          filled: true,
                          hintText: 'Write a caption...',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 45,
                      height: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: image == null
                                  ? const AssetImage(
                                      'assets/anonymous_avatars_grey_circles.jpg',
                                    )
                                  : Image.memory(image!).image,
                              fit: BoxFit.cover,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    }
  }
}
