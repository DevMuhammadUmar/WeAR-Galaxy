import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:ionicons/ionicons.dart';
import 'package:weargalaxy/root_screen.dart';
import 'package:weargalaxy/services/weargalaxy_app_methods.dart';

class GoogleButton extends StatelessWidget {
  const GoogleButton({super.key});

Future<void> _googleSignIn({required BuildContext context})async{
  final googleSignIn = GoogleSignIn();
  final googleAccount = await googleSignIn.signIn();
  if(googleAccount!=null){
    final googleAuth=await googleAccount.authentication;
    if(googleAuth.accessToken!=null && googleAuth.idToken != null){
      try{
        final authResult = await FirebaseAuth.instance.signInWithCredential(GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken
        ));
        if(authResult.additionalUserInfo!.isNewUser){
        
          
         await FirebaseFirestore.instance.collection('users').doc(authResult.user!.uid).set({
          'userId': authResult.user!.uid,
          'userName': authResult.user!.displayName,
          'userImage': authResult.user!.photoURL,
          'userEmail': authResult.user!.email,
          'createdAt': Timestamp.now(),
          'userWish': [],
          'userCart': [],
         });

        }
        
          WidgetsBinding.instance.addPostFrameCallback((_) async{
          Navigator.pushReplacementNamed(context, RootScreen.routeName);

        });

      }on FirebaseException catch (error){
         WidgetsBinding.instance.addPostFrameCallback((_) async{
         await WeargalaxyAppMethods.showErrorOrWarningDialog(context: context, subtitle: 'An error has been occured ${error.message}', fct: (){});});

      } catch (error){
        WidgetsBinding.instance.addPostFrameCallback((_) async{
         await WeargalaxyAppMethods.showErrorOrWarningDialog(context: context, subtitle: 'An error has been occured $error', fct: (){});});
      }
    }
     
  }
}
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(12),
        backgroundColor: const Color.fromARGB(255, 44, 44, 44),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        )
      ),
      onPressed: (){
        _googleSignIn(context: context);

    },icon: Icon(Ionicons.logo_google), label: Text("Sign in with Google"));
  }
}