import 'package:flutter/material.dart';
import 'package:flutter_gram/providers/user_provider.dart';
import 'package:flutter_gram/resources/firestore_methods.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/user.dart';

class CommentCard extends StatefulWidget {
  final snap;
  const CommentCard({Key? key, required this.snap}) : super(key: key);

  @override
  State<CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    print(widget.snap['likes']);
    print(user.uid);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(children: [
        CircleAvatar(
          radius: 18,
          backgroundImage: NetworkImage(widget.snap['profilePic']),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(children: [
                      TextSpan(
                          text: widget.snap['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: "   ${widget.snap['text']}",
                      )
                    ]),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd()
                          .format(widget.snap['datePublished'].toDate()),
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  )
                ]),
          ),
        ),
        Stack(children: [
          Container(
            padding: const EdgeInsets.all(8),
            child: IconButton(
              onPressed: () async {
                FirestoreMethods().likeComment(widget.snap['postId'],
                    widget.snap['commentId'], user.uid, widget.snap['likes']);
              },
              icon: widget.snap['likes'].contains(user.uid)
                  ? const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    )
                  : const Icon(
                      Icons.favorite_outline,
                    ),
            ),
          ),
          Positioned(
              left: 29,
              top: 43,
              child: Text(
                '${widget.snap['likes'].length}',
                style: TextStyle(fontSize: 12),
              )),
        ])
      ]),
    );
  }
}
