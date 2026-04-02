import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';

import 'package:tap_speed_pattern_race/app.dart';
import 'package:tap_speed_pattern_race/features/splash/presentation/pages/splash_page.dart';

void main() {
  testWidgets('renders branded splash screen first', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TapSpeedApp()));

    expect(find.text('TAP SPEED'), findsOneWidget);
    expect(find.text('PATTERN RACE'), findsOneWidget);
    expect(find.textContaining('LOADING'), findsOneWidget);
    expect(find.text('Made with Replit'), findsNothing);
  });

  testWidgets('transitions from splash into the auth entry screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TapSpeedApp()));

    await tester.pump(SplashPage.animationDuration);
    await tester.pump(SplashPage.handoffDelay);
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('READY TO\nRACE?'), findsOneWidget);
    expect(find.text('PLAY AS GUEST'), findsOneWidget);
    expect(find.text('SIGN IN WITH GOOGLE'), findsOneWidget);
    expect(find.text('Made with Replit'), findsNothing);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('guest sign-in enters the home shell', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TapSpeedApp()));

    await tester.pump(SplashPage.animationDuration);
    await tester.pump(SplashPage.handoffDelay);
    await tester.pump(const Duration(milliseconds: 900));

    await tester.tap(find.text('PLAY AS GUEST'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 900));

    expect(find.text('CREATE ROOM'), findsOneWidget);
    expect(find.text('JOIN ROOM'), findsOneWidget);
    expect(find.text('[ TOP DRIVERS ]'), findsOneWidget);
    expect(find.textContaining('Player_X1'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('play button opens the matchmaking screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TapSpeedApp()));

    await tester.pump(SplashPage.animationDuration);
    await tester.pump(SplashPage.handoffDelay);
    await tester.pump(const Duration(milliseconds: 900));

    await tester.tap(find.text('PLAY AS GUEST'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 900));

    await tester.tap(find.text('PLAY'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('SEARCHING...'), findsOneWidget);
    expect(find.text('CANCEL'), findsOneWidget);
    expect(find.textContaining('Player_X1'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('mock matchmaking handoff opens the gameplay screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TapSpeedApp()));

    await tester.pump(SplashPage.animationDuration);
    await tester.pump(SplashPage.handoffDelay);
    await tester.pump(const Duration(milliseconds: 900));

    await tester.tap(find.text('PLAY AS GUEST'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 900));

    await tester.tap(find.text('PLAY'));
    await tester.pump();
    await tester.pump(const Duration(seconds: 5));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.text('MATCH STARTING'), findsOneWidget);
    expect(find.text('GET READY'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('shop tab renders the redesigned store screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TapSpeedApp()));

    await tester.pump(SplashPage.animationDuration);
    await tester.pump(SplashPage.handoffDelay);
    await tester.pump(const Duration(milliseconds: 900));

    await tester.tap(find.text('PLAY AS GUEST'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 900));

    await tester.tap(find.byIcon(Icons.shopping_cart_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('SHOP'), findsOneWidget);
    expect(find.text('COINS'), findsOneWidget);
    expect(find.text('POWER-UPS'), findsWidgets);
    expect(find.text('\$4.99'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });

  testWidgets('profile tab renders the redesigned profile screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: TapSpeedApp()));

    await tester.pump(SplashPage.animationDuration);
    await tester.pump(SplashPage.handoffDelay);
    await tester.pump(const Duration(milliseconds: 900));

    await tester.tap(find.text('PLAY AS GUEST'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pump(const Duration(milliseconds: 900));

    await tester.tap(find.byIcon(Icons.person_rounded));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('PROFILE'), findsOneWidget);
    expect(find.text('XP PROGRESS'), findsOneWidget);
    expect(find.text('ACHIEVEMENTS'), findsOneWidget);
    expect(find.text('RECENT MATCHES'), findsOneWidget);
    expect(find.textContaining('Player_X1'), findsOneWidget);

    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump();
  });
}
