import 'package:flutter/material.dart';

/// Overlay widget that displays a loading indicator over child content
/// Provides a semi-transparent overlay with customizable loading message
class LoadingOverlay extends StatelessWidget {
  final Widget child;
  final bool isLoading;
  final String? message;

  const LoadingOverlay({
    super.key,
    required this.child,
    required this.isLoading,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main content widget
        child,
        // Loading overlay with semi-transparent background
        if (isLoading)
          Container(
            color: Colors.black54,
            child: Center(
              child: Card(
                margin: const EdgeInsets.all(32),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const CircularProgressIndicator(),
                      // Optional loading message
                      if (message != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          message!,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
