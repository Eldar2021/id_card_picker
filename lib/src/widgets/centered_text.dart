import 'package:flutter/material.dart';

class CenteredText extends StatelessWidget {
  const CenteredText(
    this.error, {
    super.key,
  });

  final Object? error;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Error: $error'),
    );
  }
}
