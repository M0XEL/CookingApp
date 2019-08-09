import 'package:CookingApp/TrendingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'SearchPage.dart';

class LogInWithEmailPage extends StatefulWidget {
  @override
  _LogInWithEmailPageState createState() => _LogInWithEmailPageState();
}

class _LogInWithEmailPageState extends State<LogInWithEmailPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Container(
      padding: EdgeInsets.all(32.0),
      child: ListView(
        children: <Widget>[
          Container(height: 96),
          FlutterLogo(
            size: 112.0,
          ),
          Container(height: 96.0),
          TextFormField(
            controller: emailController,
            decoration: InputDecoration(
              icon: Icon(Icons.email),
              hintText: 'Email',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          Container(height: 24.0),
          TextFormField(
            controller: passwordController,
            decoration: InputDecoration(
              icon: Icon(Icons.lock),
              hintText: 'Password',
            ),
            obscureText: true,
          ),
          Container(height: 48),
          MaterialButton(
            child: Container(
              height: 48.0,
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(40.0),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(),
                  Text('Login',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                Container(),
                ],
              )
            ),
            onPressed: () {
              FirebaseAuth.instance.signInWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
              ).then((user) {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchPage()));
              });
            },
          ),
          Container(height: 24),
          MaterialButton(
            child: Container(
              height: 48.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(),
                  Text('Signup',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                Container(),
                ],
              )
            ),
            onPressed: () {
              FirebaseAuth.instance.createUserWithEmailAndPassword(
                email: emailController.text,
                password: passwordController.text,
              ).then((user) {
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchPage()));
              });
            }
          ),
        ],
      ),
    ), 
  );
}