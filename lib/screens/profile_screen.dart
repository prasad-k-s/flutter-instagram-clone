import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/resources/auth_methods.dart';
import 'package:flutter_instagram_clone/resources/firestore_methods.dart';
import 'package:flutter_instagram_clone/screens/login_screen.dart';
import 'package:flutter_instagram_clone/utlis/colors.dart';
import 'package:flutter_instagram_clone/utlis/responsive.dart';
import 'package:flutter_instagram_clone/utlis/snackbar.dart';
import 'package:flutter_instagram_clone/widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key, required this.uid});
  final String uid;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  Map<String, dynamic> userData = {};
  int postLength = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async {
    try {
      setState(() {
        isLoading = true;
      });
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(
            widget.uid,
          )
          .get();

      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where(
            'uid',
            isEqualTo: widget.uid,
          )
          .get();

      userData = (userSnapshot.data()!) as Map<String, dynamic>;
      postLength = postSnap.docs.length;
      followers = ((userSnapshot.data()! as Map<String, dynamic>)['followers'] as List).length;
      following = ((userSnapshot.data()! as Map<String, dynamic>)['following'] as List).length;

      isFollowing = ((userSnapshot.data()! as Map<String, dynamic>)['followers'] as List)
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: Text(userData['username']),
        ),
        body: SafeArea(
          child: Responsive(
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage: NetworkImage(userData['photoUrl']),
                            radius: 40,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    buildColumn(postLength, 'posts'),
                                    buildColumn(followers, 'followers'),
                                    buildColumn(following, 'following'),
                                  ],
                                ),
                                if (kIsWeb)
                                  const SizedBox(
                                    height: 20,
                                  ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    FirebaseAuth.instance.currentUser!.uid == widget.uid
                                        ? FollowButton(
                                            backgroundColor: mobileBackgroundColor,
                                            borderColor: Colors.grey,
                                            text: 'Sign Out',
                                            textColor: primaryColor,
                                            onPress: () async {
                                              await AuthMethods().signOUT();
                                              if (context.mounted) {
                                                Navigator.of(context).pushReplacement(
                                                  MaterialPageRoute(
                                                    builder: (context) {
                                                      return const LoginScreen();
                                                    },
                                                  ),
                                                );
                                              }
                                            },
                                          )
                                        : isFollowing
                                            ? FollowButton(
                                                backgroundColor: Colors.white,
                                                borderColor: Colors.grey,
                                                text: 'Unfollow',
                                                textColor: Colors.black,
                                                onPress: () async {
                                                  await FireStoreMethods().followUser(
                                                    uid: FirebaseAuth.instance.currentUser!.uid,
                                                    folllowId: userData['uid'],
                                                    context: context,
                                                  );
                                                  setState(() {
                                                    isFollowing = false;
                                                    followers--;
                                                  });
                                                },
                                              )
                                            : FollowButton(
                                                backgroundColor: Colors.blue,
                                                borderColor: Colors.blue,
                                                text: 'Follow',
                                                textColor: Colors.white,
                                                onPress: () async {
                                                  await FireStoreMethods().followUser(
                                                    uid: FirebaseAuth.instance.currentUser!.uid,
                                                    folllowId: userData['uid'],
                                                    context: context,
                                                  );
                                                  setState(() {
                                                    isFollowing = true;
                                                    followers++;
                                                  });
                                                },
                                              ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 15),
                        child: Text(
                          userData['username'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: const EdgeInsets.only(top: 1),
                        child: Text(
                          userData['bio'],
                        ),
                      )
                    ],
                  ),
                ),
                const Divider(),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: FutureBuilder(
                    future: FirebaseFirestore.instance.collection('posts').where('uid', isEqualTo: widget.uid).get(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                      if (snapshot.hasError) {
                        return Text(
                          snapshot.error.toString(),
                        );
                      }
                      return GridView.builder(
                        itemCount: snapshot.data!.docs.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 1.5,
                        ),
                        itemBuilder: (context, index) {
                          return Image.network(
                            snapshot.data!.docs[index]['postUrl'],
                            fit: BoxFit.cover,
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}

Column buildColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      ),
    ],
  );
}
