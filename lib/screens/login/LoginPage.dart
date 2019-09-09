import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:CookingApp/screens/search/SearchPage.dart';

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
            padding: EdgeInsets.all(4.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('images/google_logo.jpg'),
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 4.0),
            child: Text(label,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    ),
    onPressed: () {
      action();
      showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );
    },
  );

  /*signInAnonymously() {
    FirebaseAuth.instance.signInAnonymously().then((user) {
      updateDatabase(user);
      updateDatabase(user);
      Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchPage()));
      /*SharedPreferences.getInstance().then((sharedPreferences) {
        sharedPreferences.setString('userId', user.uid).then((next) {
        });
      });*/
    });
  }*/

  //signInWithEmailAndPassword() => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => LogInWithEmailPage(updateDatabase)));

  signInWithGoogle() async {
    final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user = await FirebaseAuth.instance.signInWithCredential(credential);
    updateDatabase(user);
    Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchPage()));

    /*GoogleSignIn().signIn().then((user) {
      user.authentication.then((userAuthenticationData) {
        AuthCredential credential = GoogleAuthProvider.getCredential(
          accessToken: userAuthenticationData.accessToken,
          idToken: userAuthenticationData.idToken,
        );
        FirebaseAuth.instance.signInWithCredential(credential).then((user) {
          updateDatabase(user);
          Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => SearchPage()));
        });
      });
    });*/
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    body: FutureBuilder<FirebaseUser>(
      future: FirebaseAuth.instance.currentUser(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.active: return Container();
        
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
                /*buildButton('Log in anonymously', signInAnonymously),
                Container(height: 24.0),
                buildButton('Log in with Email', signInWithEmailAndPassword),
                Container(height: 24.0),*/
                buildButton('Mit Google einloggen', signInWithGoogle),
                Container(height: 24.0),
                Text('Andere Anmeldemethoden in Entwicklung',
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          }
          else return SearchPage();
          break;
          
        case ConnectionState.none:
          return Text('Bad state :(');
          break;
      }
      return Container();
    },
    ),
  );

  updateDatabase(FirebaseUser user) {
    Firestore.instance.collection('users').document().get().then((document) {
      if (!document.exists) {
        Firestore.instance.collection('users').document(user.uid).setData({
          'name': user.displayName,
          'photoUrl': user.photoUrl,
          'emailAddress': user.email,
        });
      }
    });
  }
}