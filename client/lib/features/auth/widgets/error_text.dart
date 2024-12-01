import 'package:flutter/material.dart';

class ErrorText extends StatelessWidget {
  final String? error;
  const ErrorText({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    if (error == null) return const SizedBox.shrink();
    return Text(
      error!,
      style: const TextStyle(color: Colors.red),
    );
  }
}