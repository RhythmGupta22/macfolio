import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

class WindowMinimizeAnimation extends StatefulWidget {
  final Rect startRect;
  final Offset endOffset;
  final Widget child;
  final bool isReversed;
  final VoidCallback? onComplete;

  const WindowMinimizeAnimation({
    Key? key,
    required this.startRect,
    required this.endOffset,
    required this.child,
    this.isReversed = false,
    this.onComplete,
  }) : super(key: key);

  @override
  State<WindowMinimizeAnimation> createState() => _WindowMinimizeAnimationState();
}

class _WindowMinimizeAnimationState extends State<WindowMinimizeAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 350),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: widget.isReversed ? Curves.easeOutBack : Curves.easeInOut,
    );

    if (widget.isReversed) {
      _controller.reverse(from: 1.0);
    } else {
      _controller.forward();
    }

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed ||
          status == AnimationStatus.dismissed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final centerX = screenWidth / 2 - 24.0;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final progress = widget.isReversed ? 1.0 - _animation.value : _animation.value;
        final bezierProgress = Curves.easeInOutCubic.transform(progress);

        final left = lerpDouble(
          widget.startRect.left,
          widget.isReversed ? widget.startRect.left : centerX,
          bezierProgress,
        )!;

        final yOffset = progress < 0.5
            ? progress * 2 * -20
            : (1.0 - progress) * 2 * -20;

        final top = lerpDouble(
          widget.startRect.top,
          widget.endOffset.dy,
          bezierProgress,
        )! + (widget.isReversed ? -yOffset : yOffset);

        final sizeProgress = Curves.easeInOutCubic.transform(progress);
        final width = lerpDouble(widget.startRect.width, 48.0, sizeProgress)!;
        final height = lerpDouble(widget.startRect.height, 48.0, sizeProgress)!;

        final scaleProgress = widget.isReversed
            ? Curves.easeOutBack.transform(progress)
            : Curves.easeInOut.transform(1.0 - progress * 0.15);

        final opacityProgress = widget.isReversed
            ? Curves.easeIn.transform(progress)
            : Curves.easeOut.transform(1.0 - progress * 0.3);

        return Positioned(
          left: left,
          top: top,
          width: width,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12 * (1.0 - sizeProgress)),
            child: Transform.scale(
              scale: scaleProgress,
              child: Opacity(
                opacity: opacityProgress,
                child: child,
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

class WindowCloseAnimation extends StatefulWidget {
  final Rect rect;
  final Widget child;
  final VoidCallback? onComplete;

  const WindowCloseAnimation({
    Key? key,
    required this.rect,
    required this.child,
    this.onComplete,
  }) : super(key: key);

  @override
  State<WindowCloseAnimation> createState() => _WindowCloseAnimationState();
}

class _WindowCloseAnimationState extends State<WindowCloseAnimation> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _controller.forward();
    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final value = _animation.value;
        final scaleProgress = Curves.easeOutCubic.transform(1 - value);
        final opacityProgress = Curves.easeOut.transform(1 - value);

        return Positioned(
          left: widget.rect.left,
          top: widget.rect.top - value * 10,
          width: widget.rect.width,
          height: widget.rect.height,
          child: Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateX(value * 0.05),
            alignment: Alignment.center,
            child: Transform.scale(
              scale: scaleProgress,
              child: Opacity(
                opacity: opacityProgress,
                child: child,
              ),
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

class DesktopOpenAnimation extends StatelessWidget {
  final Widget child;

  const DesktopOpenAnimation({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOut,
      tween: Tween<double>(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return ShaderMask(
          shaderCallback: (rect) {
            return LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withAlpha((value * 255).toInt()),
                Colors.black.withAlpha((value * 0.9 * 255).toInt()),
              ],
            ).createShader(rect);
          },
          blendMode: BlendMode.dstIn,
          child: Transform.scale(
            scale: 0.95 + (value * 0.05),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}
