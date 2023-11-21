import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/user_class.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/resources/firestore_methods.dart';
import 'package:flutter_instagram_clone/utlis/colors.dart';
import 'package:flutter_instagram_clone/utlis/snackbar.dart';
import 'package:flutter_instagram_clone/widgets/comment_card.dart';
import 'package:provider/provider.dart';

class CommenstScreen extends StatefulWidget {
  const CommenstScreen({super.key, required this.postID});
  final String postID;
  @override
  State<CommenstScreen> createState() => _CommenstScreenState();
}

class _CommenstScreenState extends State<CommenstScreen> {
  final TextEditingController commentController = TextEditingController();
  @override
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  Future<void> postComment(UserModel user) async {
    final res = await FireStoreMethods().postComments(
      postID: widget.postID,
      uid: user.uid,
      name: user.username,
      text: commentController.text,
      profilePic: user.photoUrl,
      context: context,
    );
    if (res) {
      setState(() {
        commentController.clear();
      });
    }
  }

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    UserModel user = Provider.of<UserProvider>(context).getUser!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: const Text('Comments'),
      ),
      body: const SafeArea(
        child: CommentCard(),
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          height: kToolbarHeight,
          margin: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          padding: const EdgeInsets.only(left: 16, right: 8),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.grey,
                backgroundImage: NetworkImage(user.photoUrl),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 8),
                  child: TextField(
                    controller: commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment',
                      filled: true,
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () async {
                  if (commentController.text.isEmpty) {
                    showSnackbar(
                      context: context,
                      text: 'Please enter something',
                      contentType: ContentType.warning,
                      title: "Comment",
                    );
                  } else {
                    setState(() {
                      isLoading = true;
                    });
                    await postComment(user);
                    setState(() {
                      isLoading = false;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text(
                          'Post',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.blueAccent,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
