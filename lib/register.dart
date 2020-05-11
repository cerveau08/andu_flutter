import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:andu/home.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({Key key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
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
class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  TextEditingController firstNameInputController;
  TextEditingController lastNameInputController;
  TextEditingController emailInputController;
  TextEditingController pwdInputController;
  TextEditingController confirmPwdInputController;

  @override
  initState() {
    firstNameInputController = new TextEditingController();
    lastNameInputController = new TextEditingController();
    emailInputController = new TextEditingController();
    pwdInputController = new TextEditingController();
    confirmPwdInputController = new TextEditingController();
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
              key: _registerFormKey,
              child: Column(
                children: <Widget>[
                  Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: Image.asset("assets/images/logo.jpeg"),
                        ),
                      ),
                      SizedBox(
                        height: 45,
                      ),
                      Text(
                        "Inscrivez-vous",
                        style: TextStyle(
                          color: '#18D09D'.toColor(),
                          fontSize: 26,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                  TextFormField(
                    
                    decoration: InputDecoration(
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(top: 0.1), // add padding to adjust icon
                          child: Icon(Icons.person),
                        ),
                        hintText: "Prenom",
                        
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(const Radius.circular(50))
                        )
                    ),
                    controller: firstNameInputController,
                    validator: (value) {
                      if (value.length < 3) {
                        return "Please enter a valid first name.";
                      }
                    },
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11.0,
                    ),
                  ),
                  
                    SizedBox(
                        height: 5,
                      ),
                  TextFormField(
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.all(20.0),
                        hintText: "Adresse mail",
                        border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(const Radius.circular(50))
                        )
                    ),
                    controller: emailInputController,
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11.0,
                    ),
                  ),
                  SizedBox(
                        height: 5,
                      ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Mot de passe",
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(const Radius.circular(50))
                        )
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11.0,
                    ),
                    controller: pwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  SizedBox(
                        height: 5,
                      ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Confirmer votre mot de passe",
                      border: OutlineInputBorder(
                          borderRadius: const BorderRadius.all(const Radius.circular(50))
                        )
                    ),
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 11.0,
                    ),
                    controller: confirmPwdInputController,
                    obscureText: true,
                    validator: pwdValidator,
                  ),
                  SizedBox(
                        height: 30,
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
                            'S\'inscrire',
                            
                          )),
                        ),
                    onPressed: () {
                      if (_registerFormKey.currentState.validate()) {
                        if (pwdInputController.text ==
                            confirmPwdInputController.text) {
                          FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailInputController.text,
                                  password: pwdInputController.text)
                              .then((authResult) => Firestore.instance
                                  .collection("users")
                                  .document(authResult.user.uid)
                                  .setData({
                                    "uid": authResult.user.uid,
                                    "fname": firstNameInputController.text,
                                    "surname": lastNameInputController.text,
                                    "email": emailInputController.text,
                                  })
                                  .then((result) => {
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => HomePage(
                                                      title:
                                                          firstNameInputController
                                                                  .text +
                                                              "'s Tasks",
                                                      uid: authResult.user.uid,
                                                    )),
                                            (_) => false),
                                        firstNameInputController.clear(),
                                        lastNameInputController.clear(),
                                        emailInputController.clear(),
                                        pwdInputController.clear(),
                                        confirmPwdInputController.clear()
                                      })
                                  .catchError((err) => print(err)))
                              .catchError((err) => print(err));
                        } else {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Error"),
                                  content: Text("The passwords do not match"),
                                  actions: <Widget>[
                                    FlatButton(
                                      child: Text("Close"),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    )
                                  ],
                                );
                              });
                        }
                      }
                    },
                  ),
                  SizedBox(
                        height: 25,
                      ),
                  Row (
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text("Deja inscrit ?"),
                      FlatButton(
                    
                    onPressed: () {
                      Navigator.pushNamed(context, "/login");
                    },
                    child: Text(
                              "Se connecter",
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