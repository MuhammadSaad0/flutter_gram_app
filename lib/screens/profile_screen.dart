import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gram/resources/firestore_methods.dart';
import 'package:flutter_gram/utils/colors.dart';
import 'package:flutter_gram/utils/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_gram/widgets/logout_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../widgets/follow_button.dart';

class ProfileScreen extends StatefulWidget {
  String uid;
  bool myProf;
  ProfileScreen({Key? key, required this.uid, required this.myProf})
      : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followers = 0;
  int following = 0;
  bool isFollowing = false;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getData();
    });
  }

  getData() async {
    setState(() {
      isLoading = true;
      if (widget.myProf) {
        FirebaseAuth.instance.currentUser!.reload();
        widget.uid = FirebaseAuth.instance.currentUser!.uid;
      }
    });
    try {
      var userSnap = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.uid)
          .get();
      var postSnap = await FirebaseFirestore.instance
          .collection('posts')
          .where('uid', isEqualTo: widget.uid)
          .get();
      postLen = postSnap.docs.length;
      userData = userSnap.data()!;
      followers = userData['followers'].length;
      following = userData['following'].length;
      isFollowing = userData['followers']
          .contains(FirebaseAuth.instance.currentUser!.uid);
      setState(() {});
    } catch (error) {
      showSnackbar(context, error.toString());
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (userData['username'] == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    //getData();
    return isLoading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: mobileBackgroundColor,
              title: Text(userData['username']),
              centerTitle: false,
            ),
            body: ListView(children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey,
                          backgroundImage: CachedNetworkImageProvider(userData[
                              'photoUrl']), //NetworkImage(userData['photoUrl']),
                        ),
                        Expanded(
                          child: Column(children: [
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildStatColumn(postLen, "Posts"),
                                buildStatColumn(followers, "Followers"),
                                buildStatColumn(following, "Following")
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FirebaseAuth.instance.currentUser!.uid ==
                                        widget.uid
                                    ? FollowButton(
                                        text: "Sign Out",
                                        backgroundColor: mobileBackgroundColor,
                                        textColor: primaryColor,
                                        borderColor: Colors.grey,
                                        function: () async {
                                          showDialog(
                                              context: context,
                                              builder: (context) =>
                                                  const LogOutDialog());
                                        },
                                      )
                                    : isFollowing
                                        ? FollowButton(
                                            text: "Unfolow",
                                            backgroundColor: Colors.white,
                                            textColor: Colors.black,
                                            borderColor: Colors.grey,
                                            function: () async {
                                              setState(() {
                                                isFollowing = false;
                                                followers--;
                                              });
                                              await FirestoreMethods()
                                                  .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid']);
                                            },
                                          )
                                        : FollowButton(
                                            text: "Follow",
                                            backgroundColor: Colors.blue,
                                            textColor: Colors.white,
                                            borderColor: Colors.blue,
                                            function: () async {
                                              setState(() {
                                                isFollowing = true;
                                                followers++;
                                              });
                                              await FirestoreMethods()
                                                  .followUser(
                                                      FirebaseAuth.instance
                                                          .currentUser!.uid,
                                                      userData['uid']);
                                            },
                                          )
                              ],
                            )
                          ]),
                        ),
                      ],
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 15),
                      child: Text(
                        userData['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(top: 3),
                      child: Text(
                        userData['bio'],
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              FutureBuilder(
                  future: FirebaseFirestore.instance
                      .collection('posts')
                      .where('uid', isEqualTo: widget.uid)
                      .get(),
                  builder: ((context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return GridView.builder(
                        shrinkWrap: true,
                        itemCount: (snapshot.data! as dynamic).docs.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 5,
                                mainAxisSpacing: 1.5,
                                childAspectRatio: 1),
                        itemBuilder: (context, index) {
                          DocumentSnapshot snap =
                              (snapshot.data! as dynamic).docs[index];
                          return Container(
                            child: Image(
                              image: NetworkImage(
                                snap['postUrl'],
                              ),
                              fit: BoxFit.cover,
                            ),
                          );
                        });
                  }))
            ]),
          );
  }
}

Column buildStatColumn(int num, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        num.toString(),
        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      ),
      Container(
        margin: const EdgeInsets.only(top: 4),
        child: Text(
          label,
          style: const TextStyle(
              fontSize: 14, fontWeight: FontWeight.w400, color: Colors.grey),
        ),
      ),
    ],
  );
}
