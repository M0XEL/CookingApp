import 'package:CookingApp/TrendingPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'LogInWithEmailPage.dart';
import 'SearchPage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  buildButton(String label, Function action) => MaterialButton(
    child: Container(
      height: 48.0,
      decoration: BoxDecoration(
        color: Colors.orange,
        borderRadius: BorderRadius.circular(40.0),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            child: Icon(Icons.person),
          ),
          Text(label,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ],
      ),
    ),
    onPressed: () => action(),
  );

  signInAnonymously() {
    FirebaseAuth.instance.signInAnonymously().then((user) {
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchPage()));
      /*SharedPreferences.getInstance().then((sharedPreferences) {
        sharedPreferences.setString('userId', user.uid).then((next) {
        });
      });*/
    });
  }

  signInWithEmailAndPassword() => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LogInWithEmailPage()));

  signInWithGoogle() {
    GoogleSignIn().signIn().then((user) {
      user.authentication.then((userAuthenticationData) {
        AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: userAuthenticationData.accessToken,
          idToken: userAuthenticationData.idToken,
        );
        FirebaseAuth.instance.signInWithCredential(credential).then((user) {
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchPage()));
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.active:
        
        case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator());
          break;

        case ConnectionState.done:
          //FirebaseAuth.instance.signOut(); // for debugging
          if (snapshot.data == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FlutterLogo(
                  size: 112.0,
                ),
                Container(height: 96.0),
                buildButton('Log in anonymously', signInAnonymously),
                Container(height: 24.0),
                buildButton('Log in with Email', signInWithEmailAndPassword),
                Container(height: 24.0),
                buildButton('Log in with Google', signInWithGoogle),
              ],
            );
          }
          else return SearchPage();
          break;
          
        case ConnectionState.none:
          return Text('Bad state :(');
          break;
      }
    },
    ),
  );
}