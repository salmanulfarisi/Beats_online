class LikeButtonState {
  final bool isLiked;
  const LikeButtonState(this.isLiked);
  factory LikeButtonState.initial() => const LikeButtonState(false);

  LikeButtonState copyWith({bool? isLiked}) {
    return LikeButtonState(isLiked ?? this.isLiked);
  }
}
