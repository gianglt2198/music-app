import 'package:flutter/material.dart';

class FormContainer extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final List<Widget> children;

  const FormContainer({
    super.key,
    required this.formKey,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        )
      ),
    );
  }
}