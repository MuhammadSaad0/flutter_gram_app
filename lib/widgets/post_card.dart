import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gram/resources/firestore_methods.dart';
import 'package:flutter_gram/screens/comments_screen.dart';
import 'package:flutter_gram/screens/image_view_screen.dart';
import 'package:flutter_gram/screens/profile_screen.dart';
import 'package:flutter_gram/utils/colors.dart';
import 'package:flutter_gram/utils/utils.dart';
import 'package:flutter_gram/widgets/like_animation.dart';
import 'package:intl/intl.dart';
import 'package:image_cacheing/image_cacheing.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:image_downloader/image_downloader.dart';
import '../models/user.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';

class PostCard extends StatefulWidget {
  final snap;
  const PostCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  bool isDeleting = false;
  bool isDownloading = false;
  var commentLen = 0;
  @override
  void initState() {
    super.initState();
    getComments();
  }

  void getComments() async {
    try {
      QuerySnapshot snap = await FirebaseFirestore.instance
          .collection('posts')
          .doc(widget.snap['postId'])
          .collection('comments')
          .get();
      setState(() {
        commentLen = snap.docs.length;
      });
    } catch (err) {
      if (mounted) {
        showSnackbar(context, err.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;

    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
        vertical: 10,
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16)
                .copyWith(right: 0),
            child: Row(children: [
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfileScreen(
                          uid: widget.snap['uid'], myProf: false)));
                },
                child: CircleAvatar(
                  radius: 16,
                  backgroundImage:
                      CachedNetworkImageProvider(widget.snap['profImage']),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              IconButton(
                onPressed: () {
                  showDialog(
                      context: context,
                      builder: (context) => Dialog(
                            child: ListView(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shrinkWrap: true,
                              children: [
                                'Delete',
                              ]
                                  .map((e) => InkWell(
                                        onTap: () async {
                                          if (widget.snap['uid'] == user.uid) {
                                            FirestoreMethods().deletePost(
                                              widget.snap['postId'],
                                            );
                                            Navigator.of(context).pop();
                                            showSnackbar(context,
                                                "Post deleted successfully");
                                          } else {
                                            Navigator.of(context).pop();
                                            showSnackbar(context,
                                                "You can only delete your own posts");
                                          }
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12, horizontal: 16),
                                          child: Text(e),
                                        ),
                                      ))
                                  .toList(),
                            ),
                          ));
                },
                icon: const Icon(Icons.more_vert),
              ),
            ]),
          ),
          GestureDetector(
            onDoubleTap: () async {
              setState(() {
                isLikeAnimating = true;
              });
              await FirestoreMethods().likePost(
                widget.snap['postId'],
                user.uid,
                widget.snap['likes'],
              );
            },
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      ImageViewScreen(imageurl: widget.snap['postUrl'])));
            },
            child: Stack(alignment: Alignment.center, children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.35,
                width: double.infinity,
                // child: Image.network(
                //   widget.snap['postUrl'],
                //   fit: BoxFit.cover,
                // ),
                child: ImageCacheing(
                  url: widget.snap['postUrl'],
                  fit: BoxFit.cover,
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: isLikeAnimating ? 1 : 0,
                child: LikeAnimation(
                    onEnd: () {
                      setState(() {
                        isLikeAnimating = false;
                      });
                    },
                    duration: const Duration(milliseconds: 400),
                    isAnimating: isLikeAnimating,
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 120,
                    )),
              )
            ]),
          ),
          const SizedBox(
            height: 3,
            width: double.infinity,
          ),
          Row(
            children: [
              LikeAnimation(
                isAnimating: widget.snap['likes'].contains(user.uid),
                smallLike: true,
                child: IconButton(
                    onPressed: () async {
                      await FirestoreMethods().likePost(
                        widget.snap['postId'],
                        user.uid,
                        widget.snap['likes'],
                      );
                    },
                    icon: widget.snap['likes'].contains(user.uid)
                        ? const Icon(
                            Icons.favorite,
                            color: Colors.red,
                          )
                        : const Icon(
                            Icons.favorite_border,
                          )),
              ),
              IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => CommentsScreen(
                            snap: widget.snap,
                          )));
                },
                icon: const Icon(
                  Icons.comment_outlined,
                ),
              ),
              IconButton(
                onPressed: isDownloading
                    ? null
                    : () async {
                        setState(() {
                          isDownloading = true;
                        });
                        await ImageDownloader.downloadImage(
                            widget.snap['postUrl']);
                        setState(() {
                          isDownloading = false;
                        });
                        showSnackbar(context, "Image Downloaded");
                      },
                icon: isDownloading
                    ? const Icon(Icons.downloading_outlined)
                    : const Icon(
                        Icons.download,
                      ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.bookmark_border,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  DefaultTextStyle(
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2!
                        .copyWith(fontWeight: FontWeight.w800),
                    child: Text(
                        '${widget.snap["likes"].length.toString()} likes',
                        style: Theme.of(context).textTheme.bodyText2),
                  ),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(
                      top: 8,
                    ),
                    child: RichText(
                      text: TextSpan(
                          style: const TextStyle(color: primaryColor),
                          children: [
                            TextSpan(
                              text: widget.snap['username'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            TextSpan(
                              text: ':    ${widget.snap["description"]}',
                            ),
                          ]),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              CommentsScreen(snap: widget.snap)));
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Text(
                        'View all $commentLen Comments',
                        style: const TextStyle(
                            fontSize: 16, color: secondaryColor),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style:
                          const TextStyle(fontSize: 13, color: secondaryColor),
                    ),
                  ),
                ]),
          )
        ],
      ),
    );
  }
}
