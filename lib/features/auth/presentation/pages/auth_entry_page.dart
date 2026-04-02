import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controllers/auth_controller.dart';
import '../widgets/auth_action_button.dart';
import '../widgets/auth_background.dart';

class AuthEntryPage extends ConsumerWidget {
  const AuthEntryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authControllerProvider);

    return Scaffold(
      backgroundColor: const Color(0xFF040404),
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: AuthBackground()),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 430),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 850),
                    curve: Curves.easeOutCubic,
                    builder:
                        (BuildContext context, double progress, Widget? child) {
                          return Opacity(
                            opacity: progress,
                            child: Transform.translate(
                              offset: Offset(0, 26 * (1 - progress)),
                              child: child,
                            ),
                          );
                        },
                    child: Column(
                      children: <Widget>[
                        const Spacer(flex: 3),
                        ShaderMask(
                          shaderCallback: (Rect bounds) {
                            return const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Color(0xFFE5EEFF),
                                Color(0xFF8FF8FF),
                                Color(0xFF16D5FF),
                              ],
                              stops: <double>[0.0, 0.5, 1.0],
                            ).createShader(bounds);
                          },
                          child: Text(
                            'TAP SPEED',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontSize: 34,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 2.5,
                                  color: Colors.white,
                                  shadows: <Shadow>[
                                    Shadow(
                                      color: const Color(
                                        0xFF16D5FF,
                                      ).withValues(alpha: 0.5),
                                      blurRadius: 18,
                                    ),
                                  ],
                                ),
                          ),
                        ),
                        const Spacer(flex: 4),
                        Text(
                          'READY TO\nRACE?',
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge
                              ?.copyWith(
                                fontSize: 42,
                                height: 0.9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.2,
                                color: const Color(0xFF7AF0FF),
                                fontStyle: FontStyle.italic,
                                shadows: <Shadow>[
                                  Shadow(
                                    color: const Color(
                                      0xFF16D5FF,
                                    ).withValues(alpha: 0.4),
                                    blurRadius: 12,
                                  ),
                                  const Shadow(
                                    color: Color(0xFF040A1A),
                                    offset: Offset(2, 2),
                                  ),
                                ],
                              ),
                        ),
                        const SizedBox(height: 34),
                        AuthActionButton.primary(
                          label: 'PLAY AS GUEST',
                          isBusy: authState.isBusy,
                          onPressed: () {
                            ref
                                .read(authControllerProvider.notifier)
                                .signInAsGuest();
                          },
                        ),
                        const SizedBox(height: 22),
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Divider(
                                color: const Color(
                                  0xFF16D5FF,
                                ).withValues(alpha: 0.2),
                                thickness: 1,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                              ),
                              child: Text(
                                'OR',
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: const Color(0xFF7AF0FF),
                                      fontSize: 10,
                                      fontWeight: FontWeight.w800,
                                      letterSpacing: 2.0,
                                    ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: const Color(
                                  0xFF16D5FF,
                                ).withValues(alpha: 0.2),
                                thickness: 1,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 18),
                        AuthActionButton.secondary(
                          label: 'SIGN IN WITH GOOGLE',
                          isBusy: authState.isBusy,
                          leading: const _GoogleGlyph(),
                          onPressed: () {
                            ref
                                .read(authControllerProvider.notifier)
                                .signInWithGoogle();
                          },
                        ),
                        const Spacer(flex: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF040A1A,
                            ).withValues(alpha: 0.6),
                            border: Border.all(
                              color: const Color(
                                0xFF16D5FF,
                              ).withValues(alpha: 0.3),
                            ),
                          ),
                          child: Text(
                            '[ SYSTEM: FAIR PLAY STRICTLY ENFORCED ]',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontSize: 8,
                                  letterSpacing: 1.5,
                                  color: const Color(
                                    0xFF16D5FF,
                                  ).withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w700,
                                ),
                          ),
                        ),
                        const SizedBox(height: 26),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GoogleGlyph extends StatelessWidget {
  const _GoogleGlyph();

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w900,
          letterSpacing: -0.2,
        ),
        children: <InlineSpan>[
          TextSpan(
            text: 'G',
            style: TextStyle(color: Color(0xFF4285F4)),
          ),
          TextSpan(
            text: '',
            style: TextStyle(color: Color(0xFF34A853)),
          ),
        ],
      ),
    );
  }
}
