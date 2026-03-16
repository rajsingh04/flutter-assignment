import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../bloc/post_bloc.dart';
import '../repositories/post_repository.dart';
import '../widgets/home_feed_shimmer.dart';
import '../widgets/post_card.dart';
import '../widgets/stories_tray.dart';

class HomeScreen extends StatelessWidget {
  final PostRepository postRepository;

  const HomeScreen({super.key, this.postRepository = const PostRepository()});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          PostBloc(repository: postRepository)..add(PostInitialRequested()),
      child: const _HomeView(),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  void _maybeLoadMore(BuildContext context, int index, PostState state) {
    if (state.isInitialLoading || state.isLoadingMore || !state.hasMore) return;
    if (index >= state.posts.length - 2) {
      context.read<PostBloc>().add(PostMoreRequested());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: const Padding(
          padding: EdgeInsets.only(left: 12.0),
          child: Icon(Icons.camera_alt_outlined, color: Colors.black),
        ),
        title: const Text(
          'FlutterGram',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.favorite_border, color: Colors.black),
          ),
          Padding(
            padding: EdgeInsets.only(right: 12.0),
            child: Icon(Icons.send, color: Colors.black),
          ),
        ],
      ),
      body: BlocBuilder<PostBloc, PostState>(
        builder: (context, state) {
          if (state.isInitialLoading) {
            return const HomeFeedShimmer();
          }

          if (state.posts.isEmpty) {
            final message = state.errorMessage ?? 'No posts to show';
            return Center(child: Text(message));
          }

          // We'll inject the stories tray as the first item in the list
          final totalItems =
              1 + state.posts.length + (state.isLoadingMore ? 1 : 0);

          return ListView.builder(
            itemCount: totalItems,
            itemBuilder: (context, index) {
              // index 0 -> stories tray
              if (index == 0) {
                // build some sample stories from the first posts
                final stories = state.posts
                    .take(10)
                    .map(
                      (p) => StoryItem(
                        username: p.username,
                        avatarUrl: p.avatarUrl,
                      ),
                    )
                    .toList();
                return StoriesTray(stories: stories);
              }

              final postIndex = index - 1;

              if (postIndex >= state.posts.length) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Center(
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                );
              }

              _maybeLoadMore(context, postIndex, state);
              final post = state.posts[postIndex];
              return PostCard(post: post);
            },
          );
        },
      ),
    );
  }
}
