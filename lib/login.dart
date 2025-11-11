import 'package:flutter/material.dart';

class loginPage extends StatefulWidget {
  const loginPage({Key? key}) : super(key: key);

  @override
  State<loginPage> createState() => _loginPageState();
}

class _loginPageState extends State<loginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obsecurePassword = true;

  @override
  void dispose() {}

  void _handleSignIn() {}

  void _handleForgotPassword() {}

  void _handleSignUp() {}

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
                  // SizedBox(height: 4,),
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
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 50.0),
        child: Container(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 25),
              // Container(),
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
                decoration: InputDecoration(
                  hintText: "Enter your email",
                  prefixIcon: Icon(Icons.email_outlined),
                  // filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(color: Colors.grey[300]!),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
                      onTap: _handleForgotPassword,
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
                decoration: InputDecoration(
                  hintText: "Enter your password",
                  prefixIcon: Icon(Icons.lock_clock_outlined),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        _obsecurePassword = !_obsecurePassword;
                      });
                    },
                    icon: Icon(_obsecurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                  ),
                  // filled: true,
                  fillColor: Colors.grey[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      color: Colors.grey[300]!,
                    ),
                  ),
                ),
                // style: ,
              ),
              SizedBox(height: 38,),
              ElevatedButton(
                onPressed: _handleSignIn,
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
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
              SizedBox(height: 24,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account?",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black54,
                    ),
                  ),
                  SizedBox(width: 5,),
                  GestureDetector(
                    onTap: _handleSignUp,
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
      ),
    );
  }
}
