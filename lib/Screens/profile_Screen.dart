import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/Screens/Internal_screens/viewed_recently.dart';
import 'package:weargalaxy/Screens/Internal_screens/wishlist_screen.dart';
import 'package:weargalaxy/Screens/authentication/login.dart';
import 'package:weargalaxy/Screens/loading_manager.dart';
import 'package:weargalaxy/models/user_model.dart';
import 'package:weargalaxy/providers/theme_provider.dart';
import 'package:weargalaxy/providers/user_provider.dart';
import 'package:weargalaxy/services/assets_manager.dart';
import 'package:weargalaxy/services/weargalaxy_app_methods.dart';
import 'package:weargalaxy/widgets/custom_list_tile.dart';
import 'package:weargalaxy/widgets/subtitles_text.dart';
import 'package:weargalaxy/widgets/titles_text.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
User? user = FirebaseAuth.instance.currentUser;
bool _isLoading = false;
UserModel? userModel;

Future<void> fetchUserInfo() async {
  if(user==null){
    setState(() {
      _isLoading=false;
    });
    return;
  }
  final userProvider = Provider.of<UserProvider>(context,listen: false);
  try{
    userModel = await userProvider.fetchUserInfo();


  } catch(error){
    await WeargalaxyAppMethods.showErrorOrWarningDialog(context: context, subtitle: "An error has been occured $error", fct: (){});
    }
    finally{
      setState(() {
        _isLoading=false;
      });
    }
}
@override
  void initState() {
    fetchUserInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AssetsManager.wgb,
          height: 120,
        ),
        centerTitle: true,
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView( // Added SingleChildScrollView
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 2.0), // Added padding for better alignment
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Visibility(
                  visible: user == null ? true :false  ,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: SubtitleTextWidget(
                        label: 'Please Login to Have the Full Access!'),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                userModel == null ? SizedBox.shrink() : Padding( padding: const EdgeInsets.symmetric(horizontal :8.0),
                  child: Row(
                    children: [
                      Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Theme.of(context).cardColor,
                          border: Border.all(
                            color: Theme.of(context).colorScheme.surface,
                            width: 3,
                          ),
                          image: DecorationImage(
                            image: NetworkImage(
                                userModel!.userImage),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 7,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TitleTextWidget(label: userModel!.userName),
                          SubtitleTextWidget(
                              label: userModel!.userEmail),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 24,
                ),
                TitleTextWidget(label: 'General'),
               
                CustomListTile(
                    imagePath: AssetsManager.wishlistSvg,
                    text: "Wishlist",
                    function: () {
                      Navigator.pushNamed(context,WishlistScreen.routeName );
                    }),
                CustomListTile(
                    imagePath: AssetsManager.recent,
                    text: "Viewed Recently",
                    function: () {
                      Navigator.pushNamed(context, ViewedRecently.routName);
                    }),
              
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                TitleTextWidget(label: 'Settings'),
                SwitchListTile(
                  title: Text(themeProvider.getIsDarkTheme
                      ? "Dark Mode"
                      : "Light Mode"),
                  value: themeProvider.getIsDarkTheme,
                  onChanged: (value) {
                    themeProvider.setDarkTheme(themevalue: value);
                  },
                ),
                const Divider(
                  thickness: 2,
                ),
                const SizedBox(
                  height: 10,
                ),
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () async{
                      if(user==null){
                        Navigator.pushNamed(context, LoginScreen.routeName);
                      }
                      else{
                        await WeargalaxyAppMethods.showErrorOrWarningDialog(context: context, subtitle: 'Are you sure',isError: false, fct: ()async{
                          await FirebaseAuth.instance.signOut();
                          if(!mounted) return;
                          Navigator.pushNamed(context, LoginScreen.routeName);
                        });
                      }
        
                    },
                    icon: Icon(user ==null ?
                      Icons.login : Icons.logout,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black,
                    ),
                    label: Text(user==null ? 'Login' : "Logout"),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
