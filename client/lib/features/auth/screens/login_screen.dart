import 'package:client/core/themes/app_pallete.dart';
import 'package:client/data/repositories/auth_repository.dart';
import 'package:client/features/auth/controllers/auth_controler.dart';
import 'package:client/features/auth/widgets/custom_text_field.dart';
import 'package:client/features/auth/widgets/form_container.dart';
import 'package:client/features/auth/widgets/loading_button.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authController = AuthController(AuthRepository());
  final isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter email';
    }

    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter password';
    }

    return null;
  }

  Future<void> _handleSignIn() async {
    if (_formKey.currentState!.validate()) {
      final success = await _authController.signIn(
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
        body: FormContainer(
          formKey: _formKey,
          children: [
            const Text('Sign In.',
                style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _emailController,
              hintText: "Email",
              validator: _validateEmail,
            ),
            const SizedBox(height: 20),
            CustomTextField(
              controller: _passwordController,
              hintText: "Password",
              isObsured: true,
              validator: _validatePassword,
            ),
            const SizedBox(height: 20),
            LoadingButton(
              isLoading: isLoading,
              onPressed: _handleSignIn,
              label: 'Sign In',
            ),
            const SizedBox(height: 20),
            RichText(
              text: TextSpan(
                  text: 'Don\'t have an account? ',
                  style: Theme.of(context).textTheme.titleMedium,
                  children: const [
                    TextSpan(
                      text: 'Sign Up',
                      style: TextStyle(
                        color: Pallete.gradient2,
                        fontWeight: FontWeight.bold,
                      ),
                      // recognizer: TapGestureRecognizer()
                      //   ..onTap = () =>
                      //       Navigator.of(context).pushNamed('/sign-in')
                    ),
                  ]),
            )
          ],
        ));
  }
}
