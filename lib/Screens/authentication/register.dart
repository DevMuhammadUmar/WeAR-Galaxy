import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:weargalaxy/Screens/authentication/login.dart';
import 'package:weargalaxy/Screens/loading_manager.dart';
import 'package:weargalaxy/consts/weargalaxy_validator.dart';
import 'package:weargalaxy/services/assets_manager.dart';
import 'package:weargalaxy/services/weargalaxy_app_methods.dart';
import 'package:weargalaxy/widgets/titles_text.dart';


class Register extends StatefulWidget {
  static const routName = "/RegisterScreen";
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  late final FocusNode _confirmpasswordFocusNode;
  late final FocusNode _nameFocusNode;
  late final _formkey = GlobalKey<FormState>();
  bool obsecureText = true;
  bool isLoading = false;
  // XFile? _pickedImage;

  final auth = FirebaseAuth.instance;
  

@override
  void initState() {
    // TODO: implement initState
    _emailController=TextEditingController();
    _passwordController=TextEditingController();
    _nameController=TextEditingController();
    _confirmPasswordController = TextEditingController();

    _emailFocusNode = FocusNode();
    _passwordFocusNode=FocusNode();
    _nameFocusNode = FocusNode();
    _confirmpasswordFocusNode=FocusNode();
    super.initState();
  }
@override
  void dispose() {
    if (mounted) {
      _nameController.dispose();
      _emailController.dispose();
      _passwordController.dispose();
      _confirmPasswordController.dispose();
      // Focus Nodes
      _nameFocusNode.dispose();
      _emailFocusNode.dispose();
      _passwordFocusNode.dispose();
      _confirmpasswordFocusNode.dispose();
    }
    super.dispose();
  }

  Future<void> _registerFct() async { 
    final isValid = _formkey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if(isValid){
      _formkey.currentState!.save();

      try{
        
         setState(() {
            isLoading = true;
         });

         await auth.createUserWithEmailAndPassword(email: _emailController.text.trim(), password: _passwordController.text.trim());
         User? user = auth.currentUser;
         final uid = user!.uid;
         await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'userId': uid,
          'userName': _nameController.text,
          'userEmail': _emailController.text.toLowerCase(),
          'userImage': "https://img.freepik.com/free-vector/blue-circle-with-white-user_78370-4707.jpg",
          'createdAt': Timestamp.now(),
          'userWish': [],
          'userCart': [],
         });
         Fluttertoast.showToast(
        msg: "Account created Successfully !",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
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
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, LoginScreen.routeName);



    }
  }



  
//    Future<void> localImagePicker() async {
//   final ImagePicker imagePicker = ImagePicker();

//   // Check and request permissions
//   if (await Permission.camera.request().isGranted &&
//       await Permission.storage.request().isGranted) {
//     await WeargalaxyAppMethods.imagePickerDialog(
//       context: context,
//       cameraFCT: () async {
//         _pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
//         if (_pickedImage != null) {
//           setState(() {});
//         }
//       },
//       galleryFCT: () async {
//         _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
//         if (_pickedImage != null) {
//           setState(() {});
//         }
//       },
//       removeFCT: () {
//         setState(() {
//           _pickedImage = null;
//         });
//       },
//     );
//   } else {
//     // If permissions are denied, show a dialog or prompt
//     await openAppSettings();
//   }
// }

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
                alignment: Alignment.center,
                child: Column(
                  children: [
                    TitleTextWidget(
                      label: 'Welcome '),
                      Text("Register to Get Full Access to WeAR Galaxy!",),
                      
                  ],
                ),
                
                  ),
                  const SizedBox(
                height: 10.0,
               ),
             
        
        
               const SizedBox(
                height: 10.0,
               ),
               
               Form(
                key: _formkey,
                child:
               Column(
                children: [
        
                  TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocusNode,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      hintText: "Full Name",
                      prefixIcon: Icon(IconlyLight.message),
                    ),
                    validator: (value){
                      return MyValidators.displayNamevalidator(value);
                    },
                    onFieldSubmitted: (value) {
                      FocusScope.of(context).requestFocus(_emailFocusNode);
        
                    },
                  ),
                  const SizedBox(
                height: 10.0,
               ),
        
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
                    
        
                    },
                  ),
                     const SizedBox(
                height: 10.0,
               ),
                TextFormField(
                            controller: _confirmPasswordController,
                            focusNode: _confirmpasswordFocusNode,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.visiblePassword,
                            obscureText: obsecureText,
                            decoration: InputDecoration(
                              hintText: "********",
                              prefixIcon: const Icon(
                                IconlyLight.lock,
                              ),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    obsecureText = !obsecureText;
                                  });
                                },
                                icon: Icon(
                                  obsecureText
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                ),
                              ),
                            ),
                            onFieldSubmitted: (value) {
                            
                            },
                            validator: (value) {
                              return MyValidators.repeatPasswordValidator(
                                value: value,
                                password: _passwordController.text,
                              );
                            },
                          ),
        
        
                          SizedBox(
                            height: 20,
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
                  onPressed: () async{
                    await _registerFct();
                  },
                  icon: Icon(IconlyLight.addUser),
                  label: Text("Register"))
                ),
                 TextButton(
                  onPressed: () {
                   
                    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
                  },
                  child: Text(
                    "Already have an account? Sign in",
                    style: TextStyle(
                      color: Colors.blue,
                      fontSize: 16,
                    ),
                  ),
                ),
        
                 
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