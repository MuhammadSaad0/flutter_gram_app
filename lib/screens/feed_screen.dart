import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gram/utils/colors.dart';
import 'package:flutter_gram/utils/global_variables.dart';
import 'package:flutter_gram/widgets/logout_dialog.dart';
import 'package:flutter_gram/widgets/post_card.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';
import '../providers/user_provider.dart';

class FeedScreen extends StatefulWidget {
  const FeedScreen({Key? key}) : super(key: key);

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).getUser;
    if (user == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return Scaffold(
      appBar: MediaQuery.of(context).size.width > WebScreenSize
          ? null
          : AppBar(
              backgroundColor: MediaQuery.of(context).size.width > WebScreenSize
                  ? webBackgroundColor
                  : mobileBackgroundColor,
              centerTitle: false,
              title: SvgPicture.asset(
                'assets/ic_instagram.svg',
                color: primaryColor,
                height: 32,
              ),
              actions: [
                IconButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) => const LogOutDialog());
                    },
                    icon: const Icon(Icons.logout)),
              ],
            ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('posts')
              .orderBy('datePublished', descending: true)
              .snapshots(),
          builder: (context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting ||
                !snapshot.hasData ||
                snapshot.data == null) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                setState(() {});
              },
              child: ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) => Container(
                    margin: EdgeInsets.symmetric(
                        horizontal:
                            MediaQuery.of(context).size.width > WebScreenSize
                                ? MediaQuery.of(context).size.width * 0.3
                                : 0,
                        vertical:
                            MediaQuery.of(context).size.width > WebScreenSize
                                ? 15
                                : 0),
                    child: PostCard(
                      snap: snapshot.data!.docs[index].data(),
                    )),
              ),
            );
          }),
    );
  }
}
