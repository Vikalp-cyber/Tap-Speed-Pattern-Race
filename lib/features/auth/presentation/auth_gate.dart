import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/neon_panel.dart';
import 'controllers/auth_controller.dart';

class AuthGate extends ConsumerWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authControllerProvider);
    final String displayName = authState.session?.displayName ?? 'Guest Racer';
    final String accessMode =
        authState.session?.providerLabel ?? 'Guest Access';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: NeonPanel(
        child: Row(
          children: <Widget>[
            Icon(
              authState.session?.isGuest ?? true
                  ? Icons.person_outline_rounded
                  : Icons.verified_user_outlined,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    displayName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    accessMode,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: () {
                ref.read(authControllerProvider.notifier).signOut();
              },
              child: const Text('Exit'),
            ),
          ],
        ),
      ),
    );
  }
}
