import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weargalaxy/Screens/authentication/forgot_password.dart';
import 'package:weargalaxy/Screens/authentication/register.dart';
import 'package:weargalaxy/Screens/loading_manager.dart';
import 'package:weargalaxy/consts/weargalaxy_appcolors.dart';
import 'package:weargalaxy/consts/weargalaxy_validator.dart';
import 'package:weargalaxy/root_screen.dart';
import 'package:weargalaxy/services/assets_manager.dart';
import 'package:weargalaxy/services/weargalaxy_app_methods.dart';
import 'package:weargalaxy/widgets/auth/google_button.dart';
import 'package:weargalaxy/widgets/subtitles_text.dart';
import 'package:weargalaxy/widgets/titles_text.dart';

class LoginScreen extends StatefulWidget {
  static const routeName = "/LoginScreen";
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  bool obsecureText = true;
  bool isLoading =false;
  final auth = FirebaseAuth.instance;

@override
  void initState() {
    // TODO: implement initState
    _emailController=TextEditingController();
    _passwordController=TextEditingController();

    _emailFocusNode = FocusNode();
    _passwordFocusNode=FocusNode();
    super.initState();
  }
@override
  void dispose() {

    // TODO: implement dispose 
    _emailController=TextEditingController();
    _passwordController=TextEditingController();
    _emailFocusNode = FocusNode();
    _passwordFocusNode=FocusNode();
    super.dispose();
  }

  Future<void> _loginFunc()async{
    // final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();
    // if(isValid){}
    try{
        
         setState(() {
            isLoading = true;
         });

         await auth.signInWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
         Fluttertoast.showToast(
        msg: "Login Successful !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 234, 0, 255),
        textColor: Colors.white,
        fontSize: 16.0
    );
     if(!mounted) return;
    Navigator.pushReplacementNamed(context,RootScreen.routeName);
      }on FirebaseAuthException catch(error){
        if(!mounted) return;
        await WeargalaxyAppMethods.showErrorOrWarningDialog(context: context,
         subtitle: "An Error has been occured ${error.message}",
          fct: (){},);
      } catch (error){
        if(!mounted) return;
        await WeargalaxyAppMethods.showErrorOrWarningDialog(context: context, 
        subtitle: "An Error has been occured $error", 
        fct: (){},);
      }finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
     onTap: (){
      FocusScope.of(context).unfocus();
     },
      child: Scaffold(
      body: LoadingManager(
        isLoading: isLoading,
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
               const SizedBox(
                height: 10.0,
               ),
                Image.asset(AssetsManager.wgb,height: 120,),
                const SizedBox(
                height: 10.0,
               ),
               Align(
                alignment: Alignment.centerLeft,
                child: TitleTextWidget(
                  label: 'Welcome Back')
                  ),
                  const SizedBox(
                height: 10.0,
               ),
               
               Form(child:
               Column(
                children: [
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocusNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Email Address",
                      prefixIcon: Icon(IconlyLight.message),
                    ),
                    validator: (value){
                      return MyValidators.emailValidator(value);
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_passwordFocusNode);
        
                    },
                  ),
                    const SizedBox(
                height: 10.0,
               ),
        
                    TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocusNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: obsecureText,
                    decoration: InputDecoration(
                      hintText: "********",
                      prefixIcon: Icon(IconlyLight.lock),
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          obsecureText =!obsecureText;
                        });                                                             
        
        
                      },icon: Icon( obsecureText?
                        Icons.visibility:
                        Icons.visibility_off)
                       )
                    ),
                    validator: (value){
                      return MyValidators.passwordValidator(value);
                    },
                    onFieldSubmitted: (value) {
                     _loginFunc();
        
                    },
                  ),
                     const SizedBox(
                height: 10.0,
               ),
        
               Align(
                alignment: Alignment.centerRight,
                 child: TextButton(onPressed: (){
                  Navigator.pushNamed(context, ForgotPasswordScreen.routeName);
                 }, child: SubtitleTextWidget(label:"Forgot password",textDecoration: TextDecoration.underline,
                 fontSize: 16,
                 color: AppColors.lightCardColor,
                 fontStyle: FontStyle.italic,)),
               ),
                 SizedBox(
                width: 370,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  onPressed: (){
                   _loginFunc();
                  },
                  icon: Icon(Icons.login),
                  label: Text("Login"))
                ),
        
                 const SizedBox(
                height: 20.0,
               ),
        
               SubtitleTextWidget(label:"Or Connect using".toUpperCase(),fontSize: 12,),
        
               Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: kBottomNavigationBarHeight + 10,
            child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 2,
            child: SizedBox(
              height: kBottomNavigationBarHeight,
              child: FittedBox(
                child: GoogleButton(),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0), // Add margin to the right
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, RootScreen.routeName);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                    backgroundColor: const Color.fromARGB(255, 44, 44, 44),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text("Guest"),
                ),
              ),
            ),
          ),
        ],
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Row(  mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SubtitleTextWidget(label: "New here?",fontSize: 16,),
                              TextButton(
                                child: const SubtitleTextWidget(
                                  label: "Sign up",
                                  fontSize: 12,
                                  fontStyle: FontStyle.italic,
                                  textDecoration: TextDecoration.underline,
                                ),
                                onPressed: () {
                                  Navigator.pushNamed(context, Register.routName);
                                },
                              ),
                            ],
                          )
        
                ],
               )
               
               )
              ],
              
            ),
          ),
        ),
      ),
      ),
    );
  }
}