import 'dart:math';

import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget> [
                const Text("Groupie", style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 10),
                const Text("Login now to see what they are talking!", style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                )),
                Image.asset("assets/login.png"),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    prefixIcon: const Icon(Icons.email, color: Color(0xFFee7b64)),
                    hintText: "Email",
                  ),
                  onChanged: (val){
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) {
                    return RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(val!)
                        ? null : "Please enter a valid email";
                  },
                ),
                const SizedBox(
                  height: 15,
                ),

                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    prefixIcon: const Icon(Icons.lock, color: Color(0xFFee7b64)),
                    hintText: "Password",
                  ),
                  onChanged: (val){
                    setState(() {
                      password = val;
                    });
                  },
                  validator: (val){
                    if(val!.length<6){
                      return "Password must be at least 6 characters";
                    } else {
                      return null;
                    }
                  },
                ),

                const SizedBox(height: 15),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFee7b64),
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: (){
                      login();
                    },
                    child: const Text("Sign In", style: TextStyle(color: Colors.white),),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text.rich(
                  TextSpan(
                    text: "Don't have an account? ",
                    children: <TextSpan>[
                      TextSpan(
                        text: "Register here",
                        style: const TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()..onTap = () {}
                      ),
                    ],
                    style: const TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  login() {
    if (formKey.currentState!.validate()) {}
  }
}
