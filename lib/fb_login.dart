import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookLoginAuth extends StatefulWidget {
  const FacebookLoginAuth({Key? key}) : super(key: key);

  @override
  State<FacebookLoginAuth> createState() => _FacebookLoginAuthState();
}

class _FacebookLoginAuthState extends State<FacebookLoginAuth> {
  bool isLoggedIn = false;
  bool isLoading = false;
  Map<String, dynamic> userObj = {};

  void _loginWithFacebook() async {
    setState(() {
      isLoading = true;
    });

    print("Attempting to login with Facebook...");
    final LoginResult result = await FacebookAuth.instance
        .login(permissions: ["public_profile", "email"]);

    if (result.status == LoginStatus.success) {
      print("Login successful!");
      final userData = await FacebookAuth.instance.getUserData();
      print("User data retrieved: $userData");

      setState(() {
        isLoggedIn = true;
        userObj = userData;
        isLoading = false;
      });
    } else {
      print("Login failed: ${result.status}");
      print("Error message: ${result.message}");
      setState(() {
        isLoading = false;
      });
    }
  }

  void _logoutFromFacebook() async {
    await FacebookAuth.instance.logOut();
    print("Logged out from Facebook");

    setState(() {
      isLoggedIn = false;
      userObj = {};
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          width: MediaQuery.of(context).size.width,
          child: isLoggedIn
              ? _buildUserProfile()
              : isLoading
              ? Center(child: CircularProgressIndicator())
              : _buildLoginButton(),
        ),
      ),
    );
  }

  Widget _buildUserProfile() {
    print("Displaying user profile: $userObj");
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(userObj['name'] ?? ''),
        Text(userObj['email'] ?? ''),
        TextButton(
          onPressed: _logoutFromFacebook,
          child: Text('Logout'),
        ),
      ],
    );
  }

  Widget _buildLoginButton() {
    print("Displaying login button");
    return Center(
      child: ElevatedButton(
        child: Text("Login with Facebook"),
        onPressed: _loginWithFacebook,
      ),
    );
  }
}


