import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shop_app/screens/init_screen.dart';
import '../../components/socal_card.dart';
import '../../constants.dart';
import 'components/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  static String routeName = "/sign_up";

  const SignUpScreen({super.key});

  // Method to check if the user already exists or create a new one
  Future<void> _signUpWithGoogle(BuildContext context) async {
    try {
      GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email'],
        signInOption: SignInOption.standard,
      );

      bool isAccountValid = false;
      GoogleSignInAccount? googleUser;

      // Loop until a non-existing account is selected
      while (!isAccountValid) {
        googleUser = await googleSignIn.signIn();

        if (googleUser != null) {
          List<String> signUpMethods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(googleUser.email);

          if (signUpMethods.isEmpty) {
            // The selected account does not exist, so proceed with sign up
            isAccountValid = true;
          } else {
            // User already exists, show a message and let them pick another account
            Fluttertoast.showToast(
              msg: "An account already exists with this email. Please choose another Google account.",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              backgroundColor: Colors.orange,
              textColor: Colors.white,
              fontSize: 14.0,
            );

            // Disconnect the current account to force re-picking of accounts
            await googleSignIn.signOut();
          }
        } else {
          // User canceled the sign-in process, exit the loop
          break;
        }
      }

      if (googleUser != null && isAccountValid) {
        final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // If the user does not exist, create a new user with Google credentials
        final UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);

        // New account created
        Fluttertoast.showToast(
          msg: "Account created successfully! Welcome ${userCredential.user?.displayName}.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.SNACKBAR,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 14.0,
        );

        // Navigate to HomeScreen after sign-up
        Navigator.pushReplacementNamed(context, InitScreen.routeName);
      }
    } catch (e) {
      // Display error if Google sign-up/sign-in fails
      Fluttertoast.showToast(
        msg: "Google sign-up failed. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up"),
      ),
      body: SafeArea(
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),
                  const Text("Register Account", style: headingStyle),
                  const Text(
                    "Complete your details or continue \nwith social media",
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  const SignUpForm(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocalCard(
                        icon: "assets/icons/google-icon.svg",
                        press: () => _signUpWithGoogle(context), // Google Sign-Up method
                      ),
                      SocalCard(
                        icon: "assets/icons/facebook-2.svg",
                        press: () {
                          // Implement Facebook sign-up here
                        },
                      ),
                      SocalCard(
                        icon: "assets/icons/twitter.svg",
                        press: () {
                          // Implement Twitter sign-up here
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'By continuing you confirm that you agree \nwith our Terms and Conditions',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
