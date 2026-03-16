import 'package:flutter/material.dart';

class HomeFeedShimmer extends StatefulWidget {
  const HomeFeedShimmer({super.key});

  @override
  State<HomeFeedShimmer> createState() => _HomeFeedShimmerState();
}

class _HomeFeedShimmerState extends State<HomeFeedShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 4,
      itemBuilder: (context, index) {
        return _ShimmerItem(animation: _controller);
      },
    );
  }
}

class _ShimmerItem extends StatelessWidget {
  final Animation<double> animation;

  const _ShimmerItem({required this.animation});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                _ShimmerBox(
                  width: 40,
                  height: 40,
                  shape: BoxShape.circle,
                  animation: animation,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _ShimmerBox(
                    width: double.infinity,
                    height: 14,
                    borderRadius: BorderRadius.circular(8),
                    animation: animation,
                  ),
                ),
                const SizedBox(width: 10),
                _ShimmerBox(
                  width: 16,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                  animation: animation,
                ),
              ],
            ),
          ),
          AspectRatio(
            aspectRatio: 1,
            child: _ShimmerBox(
              width: double.infinity,
              height: double.infinity,
              borderRadius: BorderRadius.zero,
              animation: animation,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _ShimmerBox(
              width: double.infinity,
              height: 14,
              borderRadius: BorderRadius.circular(8),
              animation: animation,
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: _ShimmerBox(
              width: 180,
              height: 14,
              borderRadius: BorderRadius.circular(8),
              animation: animation,
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;
  final BoxShape shape;
  final Animation<double> animation;

  const _ShimmerBox({
    required this.width,
    required this.height,
    required this.animation,
    this.borderRadius,
    this.shape = BoxShape.rectangle,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.grey.shade300,
                Colors.grey.shade100,
                Colors.grey.shade300,
              ],
              stops: const [0.1, 0.5, 0.9],
              transform: _SlidingGradientTransform(
                slidePercent: animation.value,
              ),
            ).createShader(rect);
          },
          blendMode: BlendMode.srcATop,
          child: child,
        );
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: shape == BoxShape.circle ? null : borderRadius,
          shape: shape,
        ),
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  final double slidePercent;

  const _SlidingGradientTransform({required this.slidePercent});

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(
      bounds.width * (slidePercent * 2 - 1),
      0.0,
      0.0,
    );
  }
}
