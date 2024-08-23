import 'package:client/core/theme/app_pallete.dart';
import 'package:client/core/utils.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/auth/view/pages/login_page.dart';
import 'package:client/features/auth/view/widgets/custom_form_field.dart';
import 'package:client/features/auth/view/widgets/gradient_button.dart';
import 'package:client/features/auth/viewmodel/auth_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final name = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
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
              'Account created successfully! Please  login.',
            );
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
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
      resizeToAvoidBottomInset: false,
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
            _signUpText(),
            const SizedBox(height: 30),
            CustomFormField(
              hintText: "Name",
              controller: name,
            ),
            const SizedBox(height: 15),
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
              buttonText: "Sign Up",
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  await ref.read(authViewModelProvider.notifier).signUpUser(
                        email: email.text,
                        password: password.text,
                        name: name.text,
                      );
                }
              },
            ),
            const SizedBox(height: 20),
            _signInText(),
          ],
        ),
      ),
    );
  }

  Widget _signUpText() {
    return const Text(
      'Sign Up',
      style: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _signInText() {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/login");
      },
      child: RichText(
          text: const TextSpan(
        style: TextStyle(
          fontSize: 18,
        ),
        children: [
          TextSpan(text: "Already have an account? "),
          TextSpan(
            text: "Sign In",
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
