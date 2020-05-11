import 'package:andu/home.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

extension ColorExtension on String {
  toColor() {
    var hexColor = this.replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    if (hexColor.length == 8) {
      return Color(int.parse("0x$hexColor"));
    }
  }
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController pwdInputController;

  @override
  initState() {
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    super.initState();
  }

  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String pwdValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        
        body: Container(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
                child: Form(
              key: _loginFormKey,
              child: Column(
                children: <Widget>[
                  Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 70),
                          child: Image.asset("assets/images/logo.jpeg"),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                      Text(
                        "Connectez-vous",
                        style: TextStyle(
                          color: '#18D09D'.toColor(),
                          fontSize: 26,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(
                        height: 50,
                      ),
                  TextFormField(
                    decoration: InputDecoration(
                        hintText: "Adresse mail",
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(const Radius.circular(50))
                        )
                    ),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  SizedBox(
                        height: 10,
                      ),
                  TextFormField(
                    decoration: InputDecoration(
                        
                        hintText: "Mot de pass",
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(const Radius.circular(50))
                        )
                    ),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  SizedBox(
                        height: 10,
                  ),
                  Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Mot de passe oublié ?",
                        ),
                      ),
                      SizedBox(
                        height: 40,
                  ),
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60.0),
                      side: BorderSide(color: '#18D09D'.toColor())
                    ),
                    color: '#18D09D'.toColor(),
                    textColor: Colors.white,
                    child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: '#18D09D'.toColor(),
                          ),
                          child: Center(
                              child: Text(
                            'Se connecter',
                            
                          )),
                        ),
                    onPressed: () {
                      if (_loginFormKey.currentState.validate()) {
                        FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: emailInputController.text,
                                password: pwdInputController.text)
                            .then((authResult) => Firestore.instance
                                .collection("users")
                                .document(authResult.user.uid)
                                .get()
                                .then((DocumentSnapshot result) =>
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => HomePage(
                                                  title:
                                                      "s Tasks",
                                                  uid: authResult.user.uid,
                                                ))))
                                .catchError((err) => print(err)))
                            .catchError((err) => print(err));
                      }
                    },
                  ),
                  SizedBox(
                        height: 50,
                      ),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Pas encore de compte ?"),
                      FlatButton(
                    
                    onPressed: () {
                      Navigator.pushNamed(context, "/register");
                    },
                    child: Text(
                              "\tS'inscrire",
                              style: TextStyle(
                                fontSize: 16,
                                color: '#18D09D'.toColor(),
                              ),
                            ),
                  )
                    ]
                  
                  )
                ],
              ),
            ))));
  }
}
