import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/pages/profile_page.dart';
import 'package:chat_app/pages/search_page.dart';
import 'package:chat_app/service/auth_service.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/group_tile.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  Stream? groups;
  bool _isLoading = false;
  String groupName = "";

  @override
  void initState() {
    super.initState();
    gettingUserData();
  }

  // String manipulation
  String getId(String res){
    return res.substring(0, res.indexOf("_"));
  }

  String getName(String res){
    return res.substring(res.indexOf("_")+1);
  }

  gettingUserData() async {
    await HelperFunctions.getUserEmailFromSF().then((value) {
      setState(() {
        email = value!;
      });
    });
    await HelperFunctions.getUserNameFromSF().then((val) {
      userName = val!;
    });

    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).getUserGroups().then((snapshot){
      setState(() {
        groups = snapshot;
      });
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: (){
            nextScreen(context, const SearchPage());
          }, icon: const Icon(Icons.search)),
        ],
        backgroundColor: const Color(0xFFee7b64),
        title:  const Text("Groups", style: TextStyle(
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
            Text(userName, textAlign: TextAlign.center, style: const TextStyle(
              fontWeight: FontWeight.bold,
            )),
            const SizedBox(height: 30),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: (){},
              selectedColor: const Color(0xFFee7b64),
              selected: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text("Groups", style: TextStyle(
                color: Colors.black,
              )),
            ),
            ListTile(
              onTap: (){
                nextScreenReplace(context, ProfilePage(userName: userName, email: email));
              },
              selectedColor: const Color(0xFFee7b64),
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
      body: groupList(),
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: const Color(0xFFee7b64),
        child: const Icon(
            Icons.add,
            color: Colors.white,
            size: 30
        ),
      ),
    );
  }

  groupList(){
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        if(snapshot.hasData){
          if(snapshot.data['groups'] != null){
            if(snapshot.data['groups'].length!=0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {

                    int reverseIndex = snapshot.data['groups'].length-index-1;
                    return GroupTile(
                        groupId: getId(snapshot.data['groups'][reverseIndex]),
                        groupName: getName(snapshot.data['groups'][reverseIndex]),
                        userName: snapshot.data["fullName"]);
                  }
              );
            }
            else{
              return noGroupWidget();
            }
          }
          else{
            return noGroupWidget();
          }
        }
        else{
          return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFee7b64)
            )
          );
        }
      }
    );
  }
  noGroupWidget(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              popUpDialog(context);
            },
            child: Icon(Icons.add_circle,
                color: Colors.grey[700],
                size: 75,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          const Text("You haven't joined any group, tap on the "
              "add icon to create a group or also search from the "
              "top search button.",
          textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
  popUpDialog(BuildContext context){
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Create a group",
                  textAlign: TextAlign.left
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isLoading == true ? const Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFFee7b64),
                    ),
                  ) : TextField(
                    onChanged: (val) {
                      setState(() {
                        groupName = val;
                      });
                    },
                    style: const TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFee7b64)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Color(0xFFee7b64)),
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    if (groupName != "") {
                      setState(() {
                        _isLoading = true;
                      });
                      DatabaseService(uid: FirebaseAuth.instance.currentUser!
                          .uid).createGroup(
                          userName,
                          FirebaseAuth.instance.currentUser!.uid,
                          groupName).whenComplete(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                      showSnackBar(
                          context, Colors.green, "Group created successfully.");
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFee7b64)),
                  child: const Text("CREATE",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                      primary: const Color(0xFFee7b64)),
                  child: const Text("CANCEL",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            );
          }
        );
      },
    );
  }

}



