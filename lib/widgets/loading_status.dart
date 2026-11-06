import 'package:flutter/material.dart';

class LoadingStatus extends StatelessWidget {
  const LoadingStatus({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) => Center(
        child: Semantics(
          liveRegion: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const ExcludeSemantics(
                child: CircularProgressIndicator(),
              ),
              const SizedBox(height: 12),
              Text(message, textAlign: TextAlign.center),
            ],
          ),
        ),
      );
}
