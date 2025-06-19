import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/Screens/Internal_screens/Product_details.dart';
import 'package:weargalaxy/Screens/Internal_screens/viewed_recently.dart';
import 'package:weargalaxy/Screens/Internal_screens/wishlist_screen.dart';
import 'package:weargalaxy/Screens/authentication/forgot_password.dart';
// ignore: unused_import
import 'package:weargalaxy/Screens/authentication/login.dart';
import 'package:weargalaxy/Screens/authentication/register.dart';
import 'package:weargalaxy/Screens/cart/payment.dart';
import 'package:weargalaxy/Screens/search_screen.dart';
import 'package:weargalaxy/consts/weargalaxy_constants.dart';
import 'package:weargalaxy/consts/weargalaxy_theme.dart';
import 'package:weargalaxy/providers/cart_provider.dart';
import 'package:weargalaxy/providers/product_provider.dart';
import 'package:weargalaxy/providers/theme_provider.dart';
import 'package:weargalaxy/providers/user_provider.dart';
import 'package:weargalaxy/providers/viewed_products_provider.dart';
import 'package:weargalaxy/providers/wishlist_provider.dart';
import 'package:weargalaxy/root_screen.dart';


void main() {
    runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    
    return FutureBuilder(
      future: Firebase.initializeApp(
        options: FirebaseOptions(apiKey: AppConstants.apiKey, appId: AppConstants.appID, messagingSenderId: AppConstants.messagingSenderId, projectId: AppConstants.projectId,storageBucket: AppConstants.storagebucket)
      ) ,
      builder: (context, snapshot) {
       if (snapshot.connectionState == ConnectionState.waiting) {
            return const MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            );
          } else if (snapshot.hasError) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              home: Scaffold(
                body: Center(
                  child: SelectableText(snapshot.error.toString()),
                ),
              ),
            );
          }
      return MultiProvider(providers: [
        ChangeNotifierProvider(create: (context)=> ThemeProvider(),),
         ChangeNotifierProvider(create: (context)=> ProductProvider(),),
           ChangeNotifierProvider(create: (context)=> CartProvider(),),
           ChangeNotifierProvider(create: (context)=> WishlistProvider(),),
            ChangeNotifierProvider(create: (context)=> ViewedProductsProvider(),),
            ChangeNotifierProvider(create: (context)=> UserProvider(),),
      ],
       child:Consumer<ThemeProvider>(builder: (context,themeProvider,child){
        return MaterialApp(
          title: "WeAR Galaxy",
          theme: Styles.themeData(isDarkTheme: themeProvider.getIsDarkTheme,context:context),
          home: const LoginScreen(),
          routes: {
            ProductDetails.routeName : (context)=> const ProductDetails(),
            WishlistScreen.routeName : (context)=> const WishlistScreen(),
            ViewedRecently.routName : (context)=> const ViewedRecently(),
            Register.routName : (context)=> const Register(),
            LoginScreen.routeName : (context)=> const LoginScreen(),
            RootScreen.routeName : (context)=> const RootScreen(),
            ForgotPasswordScreen.routeName:(context)=> const ForgotPasswordScreen(),
            SearchScreen.routeName :(context) => SearchScreen(),  
            Payment.routeName :(context) => Payment(),  
         },
        );
       }
       )
      );
  });
  }
 
}
