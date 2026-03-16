part of 'post_bloc.dart';

abstract class PostEvent {}

class PostInitialRequested extends PostEvent {}

class PostMoreRequested extends PostEvent {}
