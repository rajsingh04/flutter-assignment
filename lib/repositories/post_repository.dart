import 'dart:async';

import '../models/post.dart';

class PostRepository {
  const PostRepository();

  static const int _maxPages = 5;

  Future<List<Post>> fetchPosts({
    required int page,
    required int pageSize,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (page >= _maxPages) {
      return [];
    }

    final startIndex = page * pageSize;

    return List.generate(pageSize, (i) {
      final index = startIndex + i;
      return Post(
        id: 'post_$index',
        username: 'user_$index',
        avatarUrl: 'https://i.pravatar.cc/150?img=${(index % 70) + 1}',
        imageUrl: 'https://picsum.photos/seed/${index + 10}/800/800',
        caption: 'Sample caption for post #$index — enjoying Flutter!',
      );
    });
  }
}
