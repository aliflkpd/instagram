import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';
import '../providers/user_provider.dart';
import '../resources/firestore_methods.dart';
import 'like_animation.dart';

class CommentCard extends StatefulWidget {
  final dynamic snap;
  final String postId;
  CommentCard({
    Key? key,
    required this.snap,
    required this.postId,
  }) : super(key: key);

  @override
  _CommentCardState createState() => _CommentCardState();
}

class _CommentCardState extends State<CommentCard> {
  bool isLikeAnimating = false;

  @override
  Widget build(BuildContext context) {
    final User user = Provider.of<UserProvider>(context).getUser;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 18,
        horizontal: 16,
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              widget.snap['profilePic'],
            ),
            radius: 18,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RichText(
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: widget.snap['name'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: '  ${widget.snap['text']}',
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      DateFormat.yMMMd().format(
                        widget.snap['datePublished'].toDate(),
                      ),
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          LikeAnimation(
            isAnimating: widget.snap['likes'].contains(user.uid),
            smallLike: true,
            child: IconButton(
              onPressed: () async {
                await FirestoreMethods().likeComment(
                  widget.postId,
                  widget.snap['commentId'],
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
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
