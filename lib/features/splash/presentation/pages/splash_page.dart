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
              const Positioned.fill(child: _SplashFrame()),
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
  const _SplashFrame();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: const <Widget>[_FrameRail(), _FrameRail()],
      ),
    );
  }
}

class _FrameRail extends StatelessWidget {
  const _FrameRail();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: <Color>[
            const Color(0xFF4FAEFF).withValues(alpha: 0.92),
            const Color(0xFF4FAEFF).withValues(alpha: 0.45),
            const Color(0xFF4FAEFF).withValues(alpha: 0.92),
          ],
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: const Color(0xFF4FAEFF).withValues(alpha: 0.2),
            blurRadius: 12,
          ),
        ],
      ),
    );
  }
}
