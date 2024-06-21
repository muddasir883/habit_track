import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';

class MyHome extends StatefulWidget {
  final FacebookLogin plugin;

  const MyHome({Key? key, required this.plugin}) : super(key: key);

  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {
  String? _sdkVersion;
  FacebookAccessToken? _token;
  FacebookUserProfile? _profile;
  String? _email;
  String? _imageUrl;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
    });
    await _getSdkVersion();
    await _updateLoginInfo();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLogin = _token != null && _profile != null;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login via Facebook example'),
      ),
      body: Column(
        children: [
          if (_isLoading) const LinearProgressIndicator(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 8.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (_sdkVersion != null) Text('SDK v$_sdkVersion'),
                    if (isLogin)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: _buildUserInfo(context, _profile!, _token!, _email),
                      ),
                    OutlinedButton(
                      child: Text(isLogin ? 'Log Out' : 'Log In'),
                      onPressed: _isLoading ? null : (isLogin ? _onPressedLogOutButton : _onPressedLogInButton),
                    ),
                    if (!isLogin && Platform.isAndroid)
                      OutlinedButton(
                        child: const Text('Express Log In'),
                        onPressed: _isLoading ? null : () => _onPressedExpressLogInButton(context),
                      )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, FacebookUserProfile profile, FacebookAccessToken accessToken, String? email) {
    final avatarUrl = _imageUrl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (avatarUrl != null)
          Center(
            child: Image.network(avatarUrl),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const Text('User: '),
            Text(
              '${profile.firstName} ${profile.lastName}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Text('AccessToken: '),
        Text(
          accessToken.token,
          softWrap: true,
        ),
        if (email != null) Text('Email: $email'),
      ],
    );
  }

  Future<void> _onPressedLogInButton() async {
    setState(() {
      _isLoading = true;
    });
    await widget.plugin.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    await _updateLoginInfo();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _onPressedExpressLogInButton(BuildContext context) async {
    setState(() {
      _isLoading = true;
    });
    final res = await widget.plugin.expressLogin();
    if (res.status == FacebookLoginStatus.success) {
      await _updateLoginInfo();
    } else {
      await showDialog<Object>(
        context: context,
        builder: (context) => const AlertDialog(
          content: Text("Can't make express log in. Try regular log in."),
        ),
      );
    }
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _onPressedLogOutButton() async {
    setState(() {
      _isLoading = true;
    });
    await widget.plugin.logOut();
    await _updateLoginInfo();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getSdkVersion() async {
    final sdkVersion = await widget.plugin.sdkVersion;
    setState(() {
      _sdkVersion = sdkVersion;
    });
  }

  Future<void> _updateLoginInfo() async {
    final plugin = widget.plugin;
    final token = await plugin.accessToken;
    FacebookUserProfile? profile;
    String? email;
    String? imageUrl;

    if (token != null) {
      profile = await plugin.getUserProfile();
      if (token.permissions.contains(FacebookPermission.email.name)) {
        email = await plugin.getUserEmail();
      }
      imageUrl = await plugin.getProfileImageUrl(width: 100);
    }

    setState(() {
      _token = token;
      _profile = profile;
      _email = email;
      _imageUrl = imageUrl;
    });
  }
}
