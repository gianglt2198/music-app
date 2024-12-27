import 'package:client/core/themes/app_pallete.dart';
import 'package:client/core/utils/util.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/screens/signup_screen.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/features/auth/widgets/form_container.dart';
import 'package:client/features/auth/widgets/loading_button.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
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
      await ref.read(authViewModelProvider.notifier).logInUser(
          email: _emailController.text, password: _passwordController.text);
    } else {
      showSnackBar(context, "Missing field!");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(authViewModelProvider.select((val) => val?.isLoading == true));

    ref.listen(authViewModelProvider, (_, next) {
      next?.when(
          data: (data) {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
                (_) => false);
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {});
    });

    return Scaffold(
        appBar: AppBar(),
        body: isLoading
            ? const Loader()
            : FormContainer(
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
                        children: [
                          TextSpan(
                              text: 'Sign Up',
                              style: const TextStyle(
                                color: Pallete.gradient2,
                                fontWeight: FontWeight.bold,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const SignUpScreen()))),
                        ]),
                  )
                ],
              ));
  }
}
