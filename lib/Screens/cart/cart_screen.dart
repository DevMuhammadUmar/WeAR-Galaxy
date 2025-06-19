import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/Screens/cart/cart_bottom_checkout.dart';
import 'package:weargalaxy/Screens/cart/cart_widget.dart';
import 'package:weargalaxy/providers/cart_provider.dart';
import 'package:weargalaxy/providers/theme_provider.dart';
import 'package:weargalaxy/services/assets_manager.dart';
import 'package:weargalaxy/services/weargalaxy_app_methods.dart';
import 'package:weargalaxy/widgets/empty_bag_widget.dart';
import 'package:weargalaxy/widgets/titles_text.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkTheme = themeProvider.getIsDarkTheme; // Assuming ThemeProvider has an isDarkTheme property

    return cartProvider.getCartItems.isEmpty
        ? Scaffold(
           appBar: AppBar(
          title: Image.asset(
            AssetsManager.wgb,
            height: 120,
          ),
          centerTitle: true,
        ),
            body: Center(
              child: EmptyBagWidget(
                imagePath: AssetsManager.shoppingCart,
                title: 'Your Cart is Empty!',
                subtitle: "Add something and make me happy.",
                buttonText: 'Shop now',
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
          title: Image.asset(
            AssetsManager.wgb,
            height: 120,
          ),
          centerTitle: true,
        ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Cart Text and Delete Button
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Cart Title
                      TitleTextWidget(
                        label: 'Cart',
                        fontSize: 20,
                        color: isDarkTheme
                            ? const Color.fromARGB(255, 255, 255, 255) // Light text for dark theme
                            : const Color.fromARGB(255, 0, 0, 0), // Dark text for light theme
                      ),
                      // Delete Button
                      IconButton(
                        onPressed: () {
                          WeargalaxyAppMethods.showErrorOrWarningDialog(
                            isError: false,
                            context: context,
                            subtitle: 'Remove all items?',
                            fct: () {
                              cartProvider.clearCart();
                            },
                          );
                        },
                        icon: const Icon(IconlyLight.delete),
                        color: isDarkTheme 
                        ? Colors.white
                        : Colors.black ,
                      ),
                    ],
                  ),
                ),
                // List of Cart Items
                Expanded(
                  child: ListView.builder(
                    itemCount: cartProvider.getCartItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 5,
                        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ChangeNotifierProvider.value(
                          value: cartProvider.getCartItems.values.toList().reversed.toList()[index],
                          child: const CartWidget(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            bottomSheet: CartBottomCheckout(),
          );
  }
}
