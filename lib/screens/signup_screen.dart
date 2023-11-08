import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_instagram_clone/utlis/colors.dart';
import 'package:flutter_instagram_clone/widgets/textfield.dart';
import 'package:flutter_svg/svg.dart';
import 'package:regexpattern/regexpattern.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final myKey = GlobalKey<FormState>();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    bioController.dispose();
    userNameController.dispose();
    super.dispose();
  }

  void signUp() {
    final isValid = myKey.currentState!.validate();
    if (isValid) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 32,
              ),
              child: Form(
                key: myKey,
                child: Column(
                  children: [
                    SvgPicture.asset(
                      "assets/ic_instagram.svg",
                      colorFilter: const ColorFilter.mode(
                        primaryColor,
                        BlendMode.srcIn,
                      ),
                      height: 64,
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Stack(
                      children: [
                        const CircleAvatar(
                          radius: 65,
                          backgroundColor: Colors.grey,
                        ),
                        Positioned(
                          bottom: -10,
                          right: 0,
                          child: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.add_a_photo,
                              size: 30,
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    CustomTextField(
                      hintText: 'Username',
                      controller: userNameController,
                      isObscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.name,
                      maxcharacters: 30,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your username';
                        }
                        if (value.length < 4) {
                          return 'Username should have atleast 4 characters';
                        }

                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomTextField(
                      hintText: 'Email',
                      controller: emailController,
                      isObscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (EmailValidator.validate(value) == false) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomTextField(
                      hintText: 'Bio',
                      controller: bioController,
                      isObscureText: false,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      maxcharacters: 100,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your bio';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    CustomTextField(
                      hintText: 'Password',
                      controller: passwordController,
                      isObscureText: true,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter password';
                        }
                        if (value.length < 8) {
                          return 'Password must contain atleast 8 characters';
                        }
                        if (value.isPasswordHardWithspace() == false) {
                          return 'Please enter a valid password';
                        }
                        return null;
                      },
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      width: MediaQuery.of(context).size.width,
                      child: const Text(
                        'Must contain at least: 1 uppercase letter,1 lowecase letter,1 number,1 special character and Minimum 8 characters.',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 24,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      onPressed: signUp,
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Don\'t have an account',
                          style: TextStyle(
                            fontSize: 18,
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Log In',
                            style: TextStyle(
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
