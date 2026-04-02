import 'dart:async';

import 'package:flutter/material.dart';

import '../widgets/splash_brand_lockup.dart';
import '../widgets/splash_loading_bar.dart';
import '../widgets/splash_starfield.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({required this.onCompleted, super.key});

  static const Duration animationDuration = Duration(milliseconds: 2800);
  static const Duration handoffDelay = Duration(milliseconds: 420);

  final VoidCallback onCompleted;

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  Timer? _handoffTimer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: SplashPage.animationDuration,
    )..addStatusListener(_handleAnimationStatus);
    _controller.forward();
  }

  @override
  void dispose() {
    _handoffTimer?.cancel();
    _controller
      ..removeStatusListener(_handleAnimationStatus)
      ..dispose();
    super.dispose();
  }

  void _handleAnimationStatus(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }

    _handoffTimer = Timer(SplashPage.handoffDelay, () {
      if (mounted) {
        widget.onCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF040404),
      body: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final double progress = _controller.value;

          return Stack(
            children: <Widget>[
              Positioned.fill(child: SplashStarfield(progress: progress)),
              Positioned.fill(child: _SplashFrame(progress: progress)),
              SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Column(
                    children: <Widget>[
                      const Spacer(flex: 5),
                      Expanded(
                        flex: 5,
                        child: Align(
                          alignment: const Alignment(0, 0.2),
                          child: SplashBrandLockup(progress: progress),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 22),
                        child: SplashLoadingBar(progress: progress),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SplashFrame extends StatelessWidget {
  const _SplashFrame({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    final double opacity = Curves.easeInQuad.transform(
      (progress * 2).clamp(0.0, 1.0),
    );
    final double scale =
        1.05 -
        (0.05 * Curves.easeOutCubic.transform((progress * 2).clamp(0.0, 1.0)));

    return Opacity(
      opacity: opacity,
      child: Transform.scale(
        scale: scale,
        child: Padding(
          padding: const EdgeInsets.all(28.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  _CornerBracket(alignment: Alignment.topLeft),
                  _CornerBracket(alignment: Alignment.topRight),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const <Widget>[
                  _CornerBracket(alignment: Alignment.bottomLeft),
                  _CornerBracket(alignment: Alignment.bottomRight),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CornerBracket extends StatelessWidget {
  const _CornerBracket({required this.alignment});

  final Alignment alignment;

  @override
  Widget build(BuildContext context) {
    final bool isTop = alignment.y < 0;
    final bool isLeft = alignment.x < 0;
    const Color bracketColor = Color(0xFF4FAEFF);

    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        border: Border(
          top: isTop
              ? const BorderSide(color: bracketColor, width: 3)
              : BorderSide.none,
          bottom: !isTop
              ? const BorderSide(color: bracketColor, width: 3)
              : BorderSide.none,
          left: isLeft
              ? const BorderSide(color: bracketColor, width: 3)
              : BorderSide.none,
          right: !isLeft
              ? const BorderSide(color: bracketColor, width: 3)
              : BorderSide.none,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(color: bracketColor.withValues(alpha: 0.3), blurRadius: 10),
        ],
      ),
    );
  }
}
