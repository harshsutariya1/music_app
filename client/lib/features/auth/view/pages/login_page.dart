import 'package:client/core/theme/app_pallete.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/view/widgets/custom_form_field.dart';
import 'package:client/features/auth/view/widgets/gradient_button.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
    // formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _body(),
    );
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _signInText(),
            const SizedBox(height: 30),
            CustomFormField(
              hintText: "Email",
              controller: email,
            ),
            const SizedBox(height: 15),
            CustomFormField(
              hintText: "Password",
              controller: password,
              isObscured: true,
            ),
            const SizedBox(height: 20),
            GradientButton(
              buttonText: "Sign In",
              onTap: () async {
                final res = await AuthRemoteRepository().login(
                  email: email.text,
                  password: password.text,
                );

                final val = switch (res) {
                  Left(value: final l) => l,
                  Right(value: final r) => r,
                };
                print(val);
              },
            ),
            const SizedBox(height: 20),
            _signUpText(),
          ],
        ),
      ),
    );
  }

  Widget _signInText() {
    return const Text(
      'Sign In',
      style: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _signUpText() {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: RichText(
          text: const TextSpan(
        style: TextStyle(
          fontSize: 18,
        ),
        children: [
          TextSpan(text: "Don't have an account? "),
          TextSpan(
            text: "Sign Up",
            style: TextStyle(
              color: Pallete.gradient2,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      )),
    );
  }
}
