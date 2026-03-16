part of 'post_bloc.dart';

class PostState {
  final List<Post> posts;
  final bool isInitialLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  const PostState({
    this.posts = const [],
    this.isInitialLoading = false,
    this.isLoadingMore = false,
    this.hasMore = true,
    this.errorMessage,
  });

  PostState copyWith({
    List<Post>? posts,
    bool? isInitialLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
  }) {
    return PostState(
      posts: posts ?? this.posts,
      isInitialLoading: isInitialLoading ?? this.isInitialLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: errorMessage,
    );
  }
}
