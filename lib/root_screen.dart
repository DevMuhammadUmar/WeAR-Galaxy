import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:weargalaxy/Screens/cart/cart_screen.dart';
import 'package:weargalaxy/Screens/home_page.dart';
import 'package:weargalaxy/Screens/profile_Screen.dart';
import 'package:weargalaxy/Screens/search_screen.dart';
import 'package:weargalaxy/Screens/ar_screen.dart';

class RootScreen extends StatefulWidget {
  static const routeName = "/RootScreen";
  const RootScreen({super.key});

  @override
  State<RootScreen> createState() => _RootScreenState();
}

class _RootScreenState extends State<RootScreen> {
  late PageController pageController;
  int currentScreen =0;
  List<Widget> screens = [
         const HomePage(),
         const  SearchScreen(),
         const  ArScreen(),
         const  CartScreen(),
         const  ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    pageController=PageController(
      initialPage: currentScreen,
      
      
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: screens,
      ),
      bottomNavigationBar: NavigationBar(
       selectedIndex: currentScreen,
       backgroundColor: Theme.of(context).scaffoldBackgroundColor ,
       height: kBottomNavigationBarHeight,
       elevation: 2,
       onDestinationSelected: (value){
        setState(() {
          currentScreen = value;
        });
        pageController.jumpToPage(currentScreen);
      },destinations: const [
        NavigationDestination(
          selectedIcon: Icon(IconlyBold.home),
          icon: Icon(IconlyLight.home), 
          label: 'Home',
          ),
          NavigationDestination(
          selectedIcon: Icon(IconlyBold.search),
          icon: Icon(IconlyLight.search), 
          label: 'Explore',
          ),
          NavigationDestination( 
          icon: Icon(IconlyLight.camera), 
          label: 'AR Tryon',
          ),

          NavigationDestination(
          selectedIcon: Icon(IconlyBold.bag2),
          icon: Icon(IconlyLight.bag2), 
          label: 'Cart',
          ),
          NavigationDestination(
          selectedIcon: Icon(IconlyBold.profile),
          icon: Icon(IconlyLight.profile), 
          label: 'Profile',
          ),
      ], ),
    );
  }
}