import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/repositories/auth_remote_repository.dart';
import 'package:client/features/auth/view/widgets/custom_form_field.dart';
import 'package:client/features/auth/view/widgets/gradient_button.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:fpdart/fpdart.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
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
    final isLoading = ref
        .watch(authViewModelProvider.select((val) => val?.isLoading == true));

    ref.listen(
      authViewModelProvider,
      (_, next) {
        next?.when(
          data: (data) {
            showSnackBar(
              context,
              'Login Successfully!',
            );
            Navigator.pushNamedAndRemoveUntil(
              context,
              "/home",
              ModalRoute.withName('/signup'),
            );
          },
          error: (error, st) {
            showSnackBar(context, error.toString());
          },
          loading: () {},
        );
      },
    );

    return Scaffold(
      appBar: AppBar(),
      body: isLoading ? const Loader() : _body(),
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
                if (formKey.currentState!.validate()) {
                  await ref.read(authViewModelProvider.notifier).loginUser(
                        email: email.text,
                        password: password.text,
                      );
                }
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
