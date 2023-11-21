import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/models/post.dart';
import 'package:flutter_instagram_clone/models/user_class.dart';
import 'package:flutter_instagram_clone/providers/user_provider.dart';
import 'package:flutter_instagram_clone/resources/firestore_methods.dart';
import 'package:flutter_instagram_clone/screens/comment_screen.dart';
import 'package:flutter_instagram_clone/utlis/colors.dart';
import 'package:flutter_instagram_clone/widgets/like_animation.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostCard extends StatefulWidget {
  final QueryDocumentSnapshot<Map<String, dynamic>> snapshot;
  const PostCard({super.key, required this.snapshot});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  String timeUntil(DateTime date) {
    return timeago.format(
      date,
      locale: 'en',
      allowFromNow: true,
    );
  }

  bool isLikeAnimating = false;
  @override
  Widget build(BuildContext context) {
    Post post = Post.fromMap(widget.snapshot.data());
    UserModel user = Provider.of<UserProvider>(context).getUser!;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              vertical: 4,
              horizontal: 16,
            ).copyWith(right: 0),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(post.profileImage),
                  backgroundColor: Colors.grey,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          post.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return Dialog(
                          child: ListView(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(
                              vertical: 16,
                            ),
                            children: [
                              'Delete',
                            ]
                                .map(
                                  (e) => InkWell(
                                    onTap: () {},
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        vertical: 12,
                                        horizontal: 16,
                                      ),
                                      child: Text(
                                        e,
                                        style: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                )
              ],
            ),
          ),
          GestureDetector(
            onDoubleTap: () async {
              await FireStoreMethods().likePost(
                post.postId,
                user.uid,
                post.likes,
              );
              setState(() {
                isLikeAnimating = true;
              });
            },
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  color: Colors.grey,
                  height: MediaQuery.of(context).size.height * 0.35,
                  width: double.infinity,
                  child: Image.network(
                    post.postUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 200),
                  opacity: isLikeAnimating ? 1 : 0,
                  child: LikeAnimation(
                    isAnimating: isLikeAnimating,
                    duration: const Duration(
                      milliseconds: 400,
                    ),
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    child: Icon(
                      Icons.favorite,
                      color: post.likes.contains(user.uid) ? Colors.red : Colors.white,
                      size: 120,
                    ),
                  ),
                )
              ],
            ),
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: post.likes.contains(user.uid),
                smallLike: true,
                child: IconButton(
                  onPressed: () async {
                    await FireStoreMethods().likePost(
                      post.postId,
                      user.uid,
                      post.likes,
                    );
                  },
                  icon: Icon(
                    post.likes.contains(user.uid) ? Icons.favorite : Icons.favorite_border,
                    color: post.likes.contains(user.uid) ? Colors.red : Colors.white,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) {
                      return CommenstScreen(
                        postID: post.postId,
                      );
                    },
                  ),
                ),
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.send,
                ),
              ),
              const Spacer(),
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.bookmark),
              ),
              // Expanded(
              //   child: Container(
              //     color: Colors.amber,
              //     child: Align(
              //       alignment: Alignment.bottomRight,
              //       child: IconButton(
              //         onPressed: () {},
              //         icon: const Icon(Icons.bookmark),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DefaultTextStyle(
                  style: Theme.of(context).textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                  child: Text(
                    "${post.likes.length} Likes",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.only(top: 8),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(color: Colors.white),
                      children: [
                        TextSpan(
                          text: post.username,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: ' ${post.description}',
                        ),
                      ],
                    ),
                  ),
                ),
                InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return CommenstScreen(
                          postID: post.postId,
                        );
                      },
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.only(top: 6),
                    child: const Text(
                      'View all 200 comments',
                      style: TextStyle(
                        fontSize: 16,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Text(
                    timeUntil(
                      post.datePublished,
                    ),
                    style: const TextStyle(
                      fontSize: 16,
                      color: secondaryColor,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
