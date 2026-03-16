import 'package:flutter/material.dart';

import '../models/post.dart';
import 'custom_snackbar.dart';
import 'zoomable_post_image.dart';

class PostCard extends StatefulWidget {
  final Post post;

  const PostCard({super.key, required this.post});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  bool isSaved = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: NetworkImage(widget.post.avatarUrl),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  widget.post.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              const Icon(Icons.more_vert),
            ],
          ),
        ),
        ZoomablePostImage(imageUrl: widget.post.imageUrl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              IconButton(
                onPressed: () => setState(() => isLiked = !isLiked),
                icon: Icon(
                  isLiked ? Icons.favorite : Icons.favorite_border,
                  color: isLiked ? Colors.red : Colors.black,
                ),
              ),
              IconButton(
                onPressed: () =>
                    showCustomSnackBar(context, 'Comments feature coming soon'),
                icon: const Icon(Icons.mode_comment_outlined),
              ),
              IconButton(
                onPressed: () =>
                    showCustomSnackBar(context, 'Share feature coming soon'),
                icon: const Icon(Icons.send),
              ),
              const Spacer(),
              IconButton(
                onPressed: () => setState(() => isSaved = !isSaved),
                icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Text(
            '${isLiked ? '1 like — ' : '0 likes — '}'
            '${widget.post.username}: ${widget.post.caption}',
          ),
        ),
        const SizedBox(height: 12),
        const Divider(height: 1),
      ],
    );
  }
}
