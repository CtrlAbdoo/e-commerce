import 'package:flutter/material.dart';
import 'package:shop_app/screens/init_screen.dart';

class LoginSuccessScreen extends StatelessWidget {
  static String routeName = "/login_success";

  const LoginSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        title: const Text("Login Success"),
      ),
      body: SingleChildScrollView( // Wrap Column with SingleChildScrollView
        child: SizedBox(
          height: screenHeight, // Ensure the content fits the screen height
          child: Column(
            children: [
              SizedBox(height: screenHeight * 0.02), // 2% of the screen height
              Image.asset(
                "assets/images/success.png",
                height: screenHeight * 0.4, // 40% of the screen height
                width: screenWidth * 0.8, // 80% of the screen width
                fit: BoxFit.contain,
              ),
              SizedBox(height: screenHeight * 0.02), // 2% of the screen height
              Text(
                "Login Success",
                style: TextStyle(
                  fontSize: screenWidth * 0.075, // Adjust font size based on screen width (7.5% of width)
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1), // 10% of screen width for padding
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, InitScreen.routeName);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02), // 2% of screen height for padding
                      textStyle: TextStyle(
                        fontSize: screenWidth * 0.05, // 5% of screen width for button text size
                      ),
                    ),
                    child: const Text("Back to home"),
                  ),
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
