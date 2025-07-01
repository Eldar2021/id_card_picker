import 'package:flutter/material.dart';

class CenteredProgressingIndicator extends StatelessWidget {
  const CenteredProgressingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(color: Colors.white),
    );
  }
}
