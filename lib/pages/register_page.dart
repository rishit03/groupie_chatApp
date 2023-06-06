import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final formKey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullName = "";
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
              children: <Widget>[
                const Text("Groupie", style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 10),
                const Text(
                    "Create your account now to chat and explore", style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                )),
                Image.asset("assets/register.png"),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    prefixIcon: const Icon(
                        Icons.person, color: Color(0xFFee7b64)),
                    hintText: "Full Name",
                  ),
                  onChanged: (val) {
                    setState(() {
                      fullName = val;
                    });
                  },
                  validator: (val){
                    if(val!.isNotEmpty){
                      return null;
                    }
                    else{
                      return "Name cannot be empty";
                    }
                  },
                ),
                const SizedBox(height: 15),
                TextFormField(
                  decoration: textInputDecoration.copyWith(
                    prefixIcon: const Icon(
                        Icons.email, color: Color(0xFFee7b64)),
                    hintText: "Email",
                  ),
                  onChanged: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) {
                    return RegExp(
                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                        .hasMatch(val!)
                        ? null : "Please enter a valid email";
                  },
                ),
                const SizedBox(
                  height: 15,
                ),

                TextFormField(
                  obscureText: true,
                  decoration: textInputDecoration.copyWith(
                    prefixIcon: const Icon(
                        Icons.lock, color: Color(0xFFee7b64)),
                    hintText: "Password",
                  ),
                  onChanged: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  validator: (val) {
                    if (val!.length < 6) {
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
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () {
                      register();
                    },
                    child: const Text(
                      "Register", style: TextStyle(color: Colors.white, fontSize: 15)),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Text.rich(
                  TextSpan(
                    text: "Already have an account? ",
                    children: <TextSpan>[
                      TextSpan(
                          text: "Login now",
                          style: const TextStyle(
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              nextScreen(context, const LoginPage());
                            }
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

  register(){
    if (formKey.currentState!.validate()) {}
  }

}


