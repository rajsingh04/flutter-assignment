import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/post.dart';
import '../repositories/post_repository.dart';

part 'post_event.dart';
part 'post_state.dart';

class PostBloc extends Bloc<PostEvent, PostState> {
  final PostRepository repository;

  static const int _pageSize = 10;
  int _currentPage = 0;
  bool _isFetching = false;

  PostBloc({required this.repository}) : super(const PostState()) {
    on<PostInitialRequested>(_onInitialRequested);
    on<PostMoreRequested>(_onMoreRequested);
  }

  Future<void> _onInitialRequested(
    PostInitialRequested event,
    Emitter<PostState> emit,
  ) async {
    if (_isFetching) return;
    _isFetching = true;

    emit(const PostState(isInitialLoading: true));
    _currentPage = 0;

    try {
      final posts = await repository.fetchPosts(
        page: _currentPage,
        pageSize: _pageSize,
      );

      emit(
        PostState(
          posts: posts,
          isInitialLoading: false,
          hasMore: posts.isNotEmpty,
        ),
      );
    } catch (e) {
      emit(
        PostState(
          posts: const [],
          isInitialLoading: false,
          hasMore: false,
          errorMessage: 'Failed to load posts',
        ),
      );
    } finally {
      _isFetching = false;
    }
  }

  Future<void> _onMoreRequested(
    PostMoreRequested event,
    Emitter<PostState> emit,
  ) async {
    if (_isFetching || !state.hasMore) return;
    _isFetching = true;

    emit(state.copyWith(isLoadingMore: true, errorMessage: null));

    final nextPage = _currentPage + 1;

    try {
      final newPosts = await repository.fetchPosts(
        page: nextPage,
        pageSize: _pageSize,
      );

      if (newPosts.isEmpty) {
        emit(state.copyWith(isLoadingMore: false, hasMore: false));
      } else {
        _currentPage = nextPage;
        final combined = List<Post>.from(state.posts)..addAll(newPosts);
        emit(
          state.copyWith(posts: combined, isLoadingMore: false, hasMore: true),
        );
      }
    } catch (_) {
      emit(state.copyWith(isLoadingMore: false));
    } finally {
      _isFetching = false;
    }
  }
}
