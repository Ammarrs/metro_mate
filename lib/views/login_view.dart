import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/login/login_cubit.dart';
import '../cubits/login/login_state.dart';
import '../cubits/user/user_cubit.dart';
import '../utils/validators.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obsecurePassword = true;
  
  // Error state variables
  String? _emailError;
  String? _passwordError;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateAndSignIn() {
    setState(() {
      // Validate using Validators class
      _emailError = Validators.validateEmail(_emailController.text.trim());
      _passwordError = Validators.validatePassword(_passwordController.text);
    });

    // Only proceed if there are no errors
    if (_emailError == null && _passwordError == null) {
      context.read<LoginCubit>().signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );
      print("Email: ${_emailController.text}");
      print("Password: ${_passwordController.text}");
    }
  }

  void _handleSignIn() {
    _validateAndSignIn();
  }

  void _handleSignUp() {}
  void _handleForgotPassword() {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(270),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.5,
          automaticallyImplyLeading: false,
          centerTitle: true,
          flexibleSpace: Container(
            padding: EdgeInsets.only(top: 80),
            decoration: BoxDecoration(
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
              child: Expanded(
                child: Column(
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
                      child: Align(
                        alignment: Alignment.center,
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
                    SizedBox(height: 30),
                    Text(
                      "Metro Mate",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.white,
                      ),
                    ),
                    Padding(padding: EdgeInsets.only(bottom: 2)),
                    Text(
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
          ),
        ),
      ),
      body: BlocConsumer<LoginCubit, LoginState>(
        builder: (context, state) {
          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 50.0),
            child: Container(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(height: 25),
                  
                  // Email Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      SizedBox(height: 8),
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        onChanged: (value) {
                          // Clear error when user starts typing
                          if (_emailError != null) {
                            setState(() {
                              _emailError = null;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your email",
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: _emailError != null ? Colors.red : null,
                          ),
                          fillColor: Colors.grey[50],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: _emailError != null ? Colors.red : Colors.grey[300]!,
                              width: _emailError != null ? 2 : 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: _emailError != null ? Colors.red : Colors.grey[300]!,
                              width: _emailError != null ? 2 : 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: _emailError != null ? Colors.red : Color(0xFF4a6190),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      // Show error message
                      if (_emailError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 8),
                          child: Text(
                            _emailError!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  SizedBox(height: 20),
                  
                  // Password Field
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        constraints: BoxConstraints(minHeight: 0, maxHeight: 100),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
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
                              child: Text(
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
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: _obsecurePassword,
                        onChanged: (value) {
                          // Clear error when user starts typing
                          if (_passwordError != null) {
                            setState(() {
                              _passwordError = null;
                            });
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          prefixIcon: Icon(
                            Icons.lock_clock_outlined,
                            color: _passwordError != null ? Colors.red : null,
                          ),
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
                            borderSide: BorderSide(
                              color: _passwordError != null ? Colors.red : Colors.grey[300]!,
                              width: _passwordError != null ? 2 : 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: _passwordError != null ? Colors.red : Colors.grey[300]!,
                              width: _passwordError != null ? 2 : 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                            borderSide: BorderSide(
                              color: _passwordError != null ? Colors.red : Color(0xFF4a6190),
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      // Show error message
                      if (_passwordError != null)
                        Padding(
                          padding: const EdgeInsets.only(left: 16, top: 8),
                          child: Text(
                            _passwordError!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                  
                  SizedBox(height: 38),
                  
                  // Sign In Button
                  ElevatedButton(
                    onPressed: state is LoginLoading ? null : _handleSignIn,
                    child: state is LoginLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : Text("Sign In", style: TextStyle(fontSize: 16)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF4a6190),
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      elevation: 1,
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // Sign Up Link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(fontSize: 16, color: Colors.black54),
                      ),
                      SizedBox(width: 5),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "Register");
                        },
                        child: Text(
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
                ],
              ),
            ),
          );
        },
        listener: (context, state) {
          if (state is LoginSuccess) {
            // Update the UserCubit with the logged-in user
            context.read<UserCubit>().setUser(state.user);
            
            Future.microtask(() => Navigator.pushNamed(context, 'test_page'));
          }
          if (state is LoginFailure) {
            // Show error on password field for incorrect credentials
            setState(() {
              _passwordError = state.error;
            });
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
      ),
    );
  }
}