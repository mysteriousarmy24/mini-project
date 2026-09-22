import 'package:expenz/services/user_services.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/constants.dart';
import 'package:expenz/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordContorller = TextEditingController();

  Future<void> _loginUser(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    try {
      await UserServices.loginUser(
        _emailController.text.trim(),
        _passwordContorller.text,
      );

      if (context.mounted) {
        context.go('/main');
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Login failed: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(kDefalutPadding),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please Enter A Valid Email';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                controller: _passwordContorller,
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please Enter A Valid Password';
                  }
                  return null;
                },
                decoration: InputDecoration(
                  hintText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Forgot password',
                      style: TextStyle(color: kMainColor, fontSize: 16),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              GestureDetector(
                onTap: () => _loginUser(context),
                child: const CustomButton(name: 'Login', bgColor: kMainColor),
              ),
              const SizedBox(height: 15),
              const CustomButton(name: 'Sign with Google', bgColor: kMainColor),
              Center(
                child: TextButton(
                  onPressed: () => GoRouter.of(context).push('/register'),
                  child: Text(
                    'Create an account? Register',
                    style: TextStyle(color: kMainColor, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
