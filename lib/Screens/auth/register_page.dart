import 'dart:io';

import 'package:expenz/models/user_model.dart';
import 'package:expenz/services/user_services.dart';
import 'package:expenz/utilities/colors.dart';
import 'package:expenz/utilities/constants.dart';

import 'package:expenz/widgets/custom_button.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  //form Key for the form validations
  final _formKey = GlobalKey<FormState>();

  //controllers for save the states in the inputs
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordContorller = TextEditingController();
  final TextEditingController _confirmPasswordContorller =
      TextEditingController();

  final TextEditingController _imageUrlController = TextEditingController();

  File? _imageFile;

  bool _rememberMe = false;

  // Pick an image from the gallery or camera
  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _createUser(BuildContext context) async {
    try {
      if (_passwordContorller.text != _confirmPasswordContorller.text) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Passwords do not match')));
        return;
      }

      await UserServices().saveUserData(
        UserModel(
          email: _emailController.text.trim(),
          password: _passwordContorller.text,
          name: _usernameController.text.trim(),
          uid: '',
          profileImageUrl: '',
          targetAmount: 0,
          incomes: [],
          expenses: [],
        ),
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User created successfully')),
        );
        context.go('/main');
      }
    } catch (e) {
      print('Error signing up with email and password: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error signing up with email and password: $e'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(kDefalutPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Enter your \nPersonal Details",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 30),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            _imageFile != null
                                ? CircleAvatar(
                                    radius: 64,
                                    backgroundImage: FileImage(_imageFile!),
                                    backgroundColor: kMainColor,
                                  )
                                : const CircleAvatar(
                                    radius: 64,
                                    backgroundImage: AssetImage(
                                      'assets/images/person.png',
                                    ),
                                    backgroundColor: kMainColor,
                                  ),
                            Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                onPressed: () =>
                                    _pickImage(ImageSource.gallery),
                                icon: const Icon(Icons.add_a_photo),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _usernameController,
                        validator: (value) {
                          //check weather the username is entered
                          if (value!.isEmpty) {
                            return "Please Enter Your Name";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Name",
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
                        controller: _emailController,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter Your Email";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Email",
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
                          if (value!.isEmpty) {
                            return "Please Enter A Valid Password";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Password",
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
                        controller: _confirmPasswordContorller,
                        obscureText: true,
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Please Enter A Valid Password";
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 15,
                            horizontal: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Text(
                            "Remember Me for the next time",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: kGrey,
                            ),
                          ),
                          Expanded(
                            child: CheckboxListTile(
                              activeColor: kMainColor,
                              value: _rememberMe,
                              onChanged: (value) {
                                setState(() {
                                  _rememberMe = value!;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      GestureDetector(
                        onTap: () async {
                          if (_formKey.currentState!.validate()) {
                            await _createUser(context);

                            if (context.mounted) {
                              context.go('/main');
                            }
                          }
                        },
                        child: const CustomButton(
                          name: "Register",
                          bgColor: kMainColor,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Center(
                        child: TextButton(
                          onPressed: () => GoRouter.of(
                            context,
                          ).push('/login'), // Navigate to the login page
                          child: Text(
                            "Already have an account? Login",
                            style: TextStyle(color: kMainColor, fontSize: 16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
