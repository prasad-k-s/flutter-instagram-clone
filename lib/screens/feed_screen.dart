// ignore_for_file: deprecated_member_use

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/utlis/colors.dart';
import 'package:flutter_instagram_clone/utlis/responsive.dart';
import 'package:flutter_instagram_clone/widgets/post_card.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({super.key});

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kIsWeb ? webBackgroundColor : mobileBackgroundColor,
      appBar: kIsWeb
          ? null
          : AppBar(
              centerTitle: true,
              backgroundColor: mobileBackgroundColor,
              title: SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 32,
              ),
            ),
      body: Responsive(
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('posts').snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text(
                  snapshot.error.toString(),
                ),
              );
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return const Center(
                  child: Text(
                    'No post to show',
                    style: TextStyle(fontSize: 18),
                  ),
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: kIsWeb ? 15 : 0,
                    ),
                    child: PostCard(
                      snapshot: snapshot.data!.docs[index],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
