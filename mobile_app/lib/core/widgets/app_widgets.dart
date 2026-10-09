import 'package:flutter/material.dart';
import 'package:mobile_app/core/theme/app_theme.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Color? backgroundColor;
  final Color? textColor;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.backgroundColor,
    this.textColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor ?? AppTheme.primaryLime,
        foregroundColor: textColor ?? AppTheme.darkCharcoal,
        disabledBackgroundColor: (backgroundColor ?? AppTheme.primaryLime).withValues(alpha: 0.6),
      ),
      child: isLoading
          ? const SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(AppTheme.darkCharcoal),
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 20),
                  const SizedBox(width: 8),
                ],
                Text(
                  text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: textColor ?? AppTheme.darkCharcoal,
                  ),
                ),
              ],
            ),
    );
  }
}

class StatusBadge extends StatelessWidget {
  final String status;
  final String? customLabel;

  const StatusBadge({
    super.key,
    required this.status,
    this.customLabel,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppTheme.getStatusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        customLabel ?? status.replaceAll('_', ' '),
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
        ),
      ),
    );
  }
}

class ErrorBanner extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorBanner({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.errorRed.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.errorRed.withValues(alpha: 0.3)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, color: AppTheme.errorRed, size: 36),
          const SizedBox(height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppTheme.darkCharcoal,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 12),
            TextButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh, color: AppTheme.darkCharcoal),
              label: const Text(
                'Reintentar',
                style: TextStyle(color: AppTheme.darkCharcoal, fontWeight: FontWeight.bold),
              ),
              style: TextButton.styleFrom(
                backgroundColor: AppTheme.primaryLime,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? buttonText;
  final VoidCallback? onAction;

  const EmptyStateWidget({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.buttonText,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryLime.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 48, color: AppTheme.darkCharcoal),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppTheme.darkCharcoal,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: const TextStyle(fontSize: 14, color: AppTheme.textMuted),
              textAlign: TextAlign.center,
            ),
            if (buttonText != null && onAction != null) ...[
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.darkCharcoal,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(200, 46),
                ),
                child: Text(buttonText!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
