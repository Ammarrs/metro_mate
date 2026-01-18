import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:second/cubits/user/user_cubit.dart';

import '../cubits/login/login_cubit.dart';
import '../cubits/login/login_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obsecurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    context.read<LoginCubit>().signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
    print("Email: ${_emailController.text}");
    print("Password: ${_passwordController.text}");
  }

  void _handleSignUp() {}
  void _handleForgotPassword() {}

  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      body: BlocConsumer<LoginCubit, LoginState>(
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // Header Section with Gradient - Responsive height
                  Container(
                    height: screenHeight * 0.32, // 32% of screen height
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        stops: [0, 1, 0.56],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          Color(0xFF5A73A1),
                          Color(0xFF45C4E0),
                          Color(0xB800A5FF),
                        ],
                      ),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: Colors.white.withOpacity(0.2),
                                width: 1,
                              ),
                            ),
                            child: Center(
                              child: SizedBox(
                                width: 40,
                                height: 40,
                                child: Image.asset(
                                  "assets/images/train_black.png",
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: screenHeight * 0.03),
                          const Text(
                            "Metro Mate",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 26,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Welcome back!",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Form Section - Responsive padding
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.12, // 12% of screen width
                      vertical: 20,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(height: screenHeight * 0.015),

                        // Email Field
                        const Text(
                          "Email",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            hintText: "Enter your email",
                            prefixIcon: const Icon(Icons.email_outlined),
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: Colors.transparent),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.025),

                        // Password Label & Forgot Password
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Password",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black87,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "ForgetPassword");
                              },
                              child: const Text(
                                "Forgot password?",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),

                        // Password Field
                        TextField(
                          controller: _passwordController,
                          obscureText: _obsecurePassword,
                          decoration: InputDecoration(
                            hintText: "Enter your password",
                            prefixIcon: const Icon(Icons.lock_clock_outlined),
                            suffixIcon: IconButton(
                              onPressed: () {
                                setState(() {
                                  _obsecurePassword = !_obsecurePassword;
                                });
                              },
                              icon: Icon(
                                _obsecurePassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                              ),
                            ),
                            fillColor: Colors.grey[50],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.045),

                        // Sign In Button
                        ElevatedButton(
                          onPressed: _handleSignIn,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4a6190),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50),
                            ),
                            elevation: 1,
                          ),
                          child: const Text(
                            "Sign In",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),

                        SizedBox(height: screenHeight * 0.03),

                        // Sign Up Link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Don't have an account?",
                              style: TextStyle(fontSize: 16, color: Colors.black54),
                            ),
                            const SizedBox(width: 5),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, "Register");
                              },
                              child: const Text(
                                "Sign Up",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xFF4a6190),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: screenHeight * 0.02),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is LoginSuccess) {
            context.read<UserCubit>().setUser(state.user);
            Future.microtask(() => Navigator.pushNamed(context, 'test_page'));
          }
          if (state is LoginFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
      ),
    );
  }
}