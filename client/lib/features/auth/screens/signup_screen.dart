import 'package:client/core/themes/app_pallete.dart';
import 'package:client/data/repositories/auth_repository.dart';
import 'package:client/features/auth/controllers/auth_controler.dart';
import 'package:client/features/auth/widgets/custom_text_field.dart';
import 'package:client/features/auth/widgets/error_text.dart';
import 'package:client/features/auth/widgets/form_container.dart';
import 'package:client/features/auth/widgets/loading_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = AuthController(AuthRepository());

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
    // _formKey.currentState!.validate();
  }

  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter name';
    }

    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter email';
    }
    if (!value.contains('@')) {
      return 'Please enter valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter password';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  Future<void> _handleSignUp() async {
    if (_formKey.currentState!.validate()) {
      final success = await _authController.signUp(
        _emailController.text,
        _passwordController.text,
      );

      if (success && mounted) {
        // Navigator.of(context).pushReplacementNamed('/home');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(),
        body: FormContainer(formKey: _formKey, children: [
          const Text('Sign Up.',
              style: TextStyle(
                fontSize: 50,
                fontWeight: FontWeight.bold,
              )),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _nameController,
            hintText: 'Name',
            validator: _validateName,
          ),
          const SizedBox(height: 20),
          CustomTextField(
              controller: _emailController,
              hintText: 'Email',
              validator: _validateEmail),
          const SizedBox(height: 20),
          CustomTextField(
            controller: _passwordController,
            hintText: 'Password',
            isObsured: true,
            validator: _validatePassword,
          ),
          const SizedBox(height: 20),
          ErrorText(error: _authController.error),
          LoadingButton(
              isLoading: _authController.isLoading,
              onPressed: _handleSignUp,
              label: "Sign Up"),
          const SizedBox(height: 20),
          RichText(
              text: TextSpan(
                  text: 'Already have an account? ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: [
                TextSpan(
                    text: 'Sign In',
                    style: const TextStyle(
                      color: Pallete.gradient2,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap =
                          () => Navigator.of(context).pushNamed('/sign-in')),
              ])),
        ]));
  }
}
