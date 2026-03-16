import 'package:flutter/material.dart';

class ZoomablePostImage extends StatefulWidget {
  final String imageUrl;

  const ZoomablePostImage({super.key, required this.imageUrl});

  @override
  State<ZoomablePostImage> createState() => _ZoomablePostImageState();
}

class _ZoomablePostImageState extends State<ZoomablePostImage>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  final ValueNotifier<double> _scaleNotifier = ValueNotifier<double>(1.0);
  late final AnimationController _controller;
  Animation<double>? _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  @override
  void dispose() {
    _removeOverlay();
    _controller.dispose();
    _scaleNotifier.dispose();
    super.dispose();
  }

  void _insertOverlay() {
    if (_overlayEntry != null) return;

    _overlayEntry = OverlayEntry(
      builder: (context) {
        return Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: _animateAndRemoveOverlay,
            onScaleUpdate: (details) {
              _scaleNotifier.value = details.scale.clamp(1.0, 3.0);
            },
            onScaleEnd: (_) => _animateAndRemoveOverlay(),
            child: Container(
              color: Colors.black54,
              alignment: Alignment.center,
              child: ValueListenableBuilder<double>(
                valueListenable: _scaleNotifier,
                builder: (context, scale, _) {
                  return Transform.scale(
                    scale: scale,
                    child: Image.network(
                      widget.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[900],
                        child: const Center(
                          child: Icon(Icons.broken_image, color: Colors.white),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
    );

    Overlay.of(context)?.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    _scaleNotifier.value = 1.0;
  }

  void _animateAndRemoveOverlay() {
    _scaleAnimation = Tween<double>(
      begin: _scaleNotifier.value,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    void listener() {
      _scaleNotifier.value = _scaleAnimation!.value;
    }

    void statusListener(AnimationStatus status) {
      if (status == AnimationStatus.completed) {
        _controller.removeListener(listener);
        _controller.removeStatusListener(statusListener);
        _removeOverlay();
      }
    }

    _controller
      ..reset()
      ..addListener(listener)
      ..addStatusListener(statusListener)
      ..forward();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleStart: (_) => _insertOverlay(),
      onScaleUpdate: (details) {
        _scaleNotifier.value = details.scale.clamp(1.0, 3.0);
      },
      onScaleEnd: (_) => _animateAndRemoveOverlay(),
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.network(
          widget.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: const Center(child: Icon(Icons.broken_image)),
          ),
        ),
      ),
    );
  }
}
