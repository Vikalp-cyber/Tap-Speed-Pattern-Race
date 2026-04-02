import 'package:flutter/material.dart';

class AuthActionButton extends StatelessWidget {
  const AuthActionButton.primary({
    required this.label,
    required this.onPressed,
    required this.isBusy,
    super.key,
  }) : isPrimary = true,
       leading = null;

  const AuthActionButton.secondary({
    required this.label,
    required this.onPressed,
    required this.isBusy,
    this.leading,
    super.key,
  }) : isPrimary = false;

  final String label;
  final VoidCallback? onPressed;
  final bool isBusy;
  final bool isPrimary;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final Widget content = AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: isBusy
          ? const SizedBox(
              key: ValueKey<String>('busy'),
              height: 18,
              width: 18,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                color: Colors.white,
              ),
            )
          : Row(
              key: const ValueKey<String>('label'),
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (leading != null) ...<Widget>[
                  leading!,
                  const SizedBox(width: 8),
                ],
                Text(
                  label,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
    );

    final ButtonStyle style = ButtonStyle(
      minimumSize: const WidgetStatePropertyAll<Size>(Size.fromHeight(54)),
      shape: WidgetStatePropertyAll<OutlinedBorder>(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      ),
      padding: const WidgetStatePropertyAll<EdgeInsetsGeometry>(
        EdgeInsets.symmetric(horizontal: 24),
      ),
      backgroundColor: WidgetStatePropertyAll<Color>(
        isPrimary ? Colors.transparent : const Color(0x12000000),
      ),
      side: WidgetStatePropertyAll<BorderSide>(
        isPrimary
            ? BorderSide.none
            : BorderSide(
                color: Colors.white.withValues(alpha: 0.4),
                width: 1.2,
              ),
      ),
      overlayColor: WidgetStatePropertyAll<Color>(
        Colors.white.withValues(alpha: 0.08),
      ),
    );

    if (isPrimary) {
      return DecoratedBox(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: <Color>[Color(0xFF4B8DFF), Color(0xFF7B57FF)],
          ),
          borderRadius: BorderRadius.circular(999),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: const Color(0xFF6A73FF).withValues(alpha: 0.35),
              blurRadius: 18,
              spreadRadius: 1,
            ),
          ],
        ),
        child: FilledButton(
          style: style,
          onPressed: isBusy ? null : onPressed,
          child: content,
        ),
      );
    }

    return OutlinedButton(
      style: style,
      onPressed: isBusy ? null : onPressed,
      child: content,
    );
  }
}
