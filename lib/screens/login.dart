import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:websocket/api/google_sign_in_api.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  String? _idToken;
  String? _accessToken;


  Future signIn()async{
    final user= await GoogleSignInApi.login();
    String? accessToken;
   user!.authentication.then((value)  {

     accessToken = value.accessToken;

     print(user.authHeaders);



   });


  }

  Future<void> _handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {
    }
  }

  Future<String> _getUserName() async {
    try {
      await _googleSignIn.signIn();
      final GoogleSignInAccount? currentUser = _googleSignIn.currentUser;

      final GoogleSignInAuthentication? auth =
          await currentUser?.authentication;
      if (auth!.accessToken!.isEmpty) {
        setState(() {
          _idToken = auth.idToken;
          _accessToken = auth.accessToken;
        });
        return _idToken!;
      }
    } catch (error) {
    }
    return _idToken!;
  }

  void _signOut() async {
    try {
      await GoogleSignInApi.logout();


    } catch (error) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Data',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: const BackButton(
            color: Colors.black, // <-- SEE HERE
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              SelectableText(_idToken.toString()),
              Divider(),
              Text(_accessToken.toString()),
              ElevatedButton(
                child: Text('login'),
                onPressed: signIn,
              ),
              ElevatedButton(
                child: Text('login2'),
                onPressed: _getUserName,
              ),
              ElevatedButton(
                onPressed: _signOut,
                child: Text('Sign Out'),
              ),
            ],
          ),
        ));
  }
}
