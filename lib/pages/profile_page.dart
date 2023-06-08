import 'package:chat_app/pages/home_page.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String email;
  const ProfilePage({Key? key, required this.email, required this. userName}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFee7b64),
        title:  const Text("Profile", style: TextStyle(
          color: Colors.white,
          fontSize: 21,
          fontWeight: FontWeight.bold,
        )),
        centerTitle: true,
        elevation: 0,
      ),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Text(widget.userName, textAlign: TextAlign.center, style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
            const SizedBox(height: 30),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: (){
                nextScreenReplace(context, const HomePage());
              },
              selectedColor: const Color(0xFFee7b64),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups", style: TextStyle(
                color: Colors.black,
              )),
            ),
            ListTile(
              onTap: (){},
              selectedColor: const Color(0xFFee7b64),
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person),
              title: const Text("Profile", style: TextStyle(
                color: Colors.black,
              )),
            ),
            ListTile(
              onTap: () {
                showDialog(context: context, builder: (context){
                  return AlertDialog(
                    title: const Text("Logout"),
                    content: const Text("Are you sure you want to logout?"),
                    actions: [
                      IconButton(onPressed: (){
                        Navigator.pop(context);
                      }, icon: const Icon(Icons.cancel),
                          color: Colors.red
                      ),
                      IconButton(onPressed: (){
                        authService.signOut().whenComplete(() async {
                          await Future.delayed(const Duration(seconds: 1));
                          nextScreenReplace(context, const LoginPage());
                        });
                      }, icon: const Icon(Icons.exit_to_app),
                        color: Colors.green,
                      ),
                    ],
                  );
                });
              },
              selectedColor: const Color(0xFFee7b64),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.logout),
              title: const Text("Logout", style: TextStyle(
                color: Colors.black,
              )),
            ),
          ],
        ),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 170),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(Icons.account_circle,
            size: 200,
              color: Colors.grey[700],
            ),
            const SizedBox(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Full Name", style: TextStyle(
                  fontSize: 17,
                  ),
                ),
                Text(widget.userName, style: const TextStyle(
                    fontSize: 17,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 15,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Email", style: TextStyle(
                  fontSize: 17,
                ),
                ),
                Text(widget.email, style: const TextStyle(
                  fontSize: 17,
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
