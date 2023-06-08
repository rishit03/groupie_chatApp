import 'package:chat_app/helper/helper_function.dart';
import 'package:chat_app/pages/login_page.dart';
import 'package:chat_app/service/database_service.dart';
import 'package:chat_app/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthService {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;


  // login
  Future loginUserWithEmailAndPassword(String email, String password) async {
    try{
      User user = (await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;

      if(user!=null){
        return true;
      }
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }




  // register
  Future registerUserWithEmailAndPassword(String fullName, String email, String password) async {

    try{
      User user = (await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;

      if(user!=null){

        await DatabaseService(uid: user.uid).savingUserData(fullName, email);

        return true;
      }
    } on FirebaseAuthException catch (e){
      return e.message;
    }

  }


  // sign out
  Future signOut() async {
    try{
      await HelperFunctions.saveUserLoginStatus(false);
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserEmailSF("");
      await firebaseAuth.signOut();

    } catch(e){
      return null;
    }
  }
}