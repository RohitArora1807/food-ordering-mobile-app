import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:foodapp/screen/widget/my_text_field.dart';

class SignUp extends StatefulWidget {
  static String pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool loading = false;
  RegExp regExp = RegExp(SignUp.pattern);
  GlobalKey<ScaffoldState> globalKey = GlobalKey<ScaffoldState>();
  UserCredential? userCredential;
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController firstName = TextEditingController();
  TextEditingController lastName = TextEditingController();

  Future sendData() async {
    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      await FirebaseFirestore.instance
          .collection('userData')
          .doc(userCredential?.user?.uid)
          .set({
        "firstName": firstName.text.trim(),
        "lastName": lastName.text.trim(),
        "email": email.text.trim(),
        "userid": userCredential?.user?.uid,
        "password": password.text.trim(),
      });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("The password provided is too weak."),
          ),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("The account already exists for that email"),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
        ),
      );
      setState(() {
        loading = false;
      });
    }
    setState(() {
      loading = false;
    });
  }

  void validation() {
    if (firstName.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "firstName is Empty",
          ),
        ),
      );
      return;
    }
    if (lastName.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "lastName is Empty",
          ),
        ),
      );
      return;
    }
    if (email.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Email is Empty",
          ),
        ),
      );
      return;
    } else if (!regExp.hasMatch(email.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please enter vaild Email",
          ),
        ),
      );
      return;
    }
    if (password.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Password is Empty",
          ),
        ),
      );
      return;
    } else {
      setState(() {
        loading = true;
      });
      sendData();
    }
  }

  Widget button({
    required void Function() onTap,
    required String buttonName,
    required Color color,
    required Color textColor,
  }) {
    return Container(
      width: 120,
      child: ElevatedButton(
        // color: color,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.circular(30),
        // ),
        child: Text(
          buttonName,
          style: TextStyle(fontSize: 20, color: textColor),
        ),
        onPressed: onTap,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: globalKey,
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Sign Up",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                ),
              ),
              Container(
                height: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    MyTextField(
                      controller: firstName,
                      obscureText: false,
                      hintText: 'firstName',
                    ),
                    MyTextField(
                      controller: lastName,
                      obscureText: false,
                      hintText: 'lastName',
                    ),
                    MyTextField(
                      controller: email,
                      obscureText: false,
                      hintText: 'Email',
                    ),
                    MyTextField(
                      controller: password,
                      obscureText: true,
                      hintText: 'password',
                    )
                  ],
                ),
              ),
              loading
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        button(
                          onTap: () {
                            // Handle button tap here
                          },
                          buttonName: "Cancel",
                          color: Colors.grey,
                          textColor: Colors.black,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        button(
                          onTap: () {
                            validation();
                          },
                          buttonName: "Register",
                          color: Colors.red,
                          textColor: Colors.white,
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
