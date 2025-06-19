import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/Screens/Internal_screens/Product_details.dart';
import 'package:weargalaxy/models/products_model.dart';
import 'package:weargalaxy/providers/cart_provider.dart';
import 'package:weargalaxy/providers/theme_provider.dart';
import 'package:weargalaxy/providers/viewed_products_provider.dart';
import 'package:weargalaxy/widgets/products/heart_button_widget.dart';
import 'package:weargalaxy/widgets/titles_text.dart';
import 'package:weargalaxy/widgets/subtitles_text.dart';

class LatestArrivalProductsWidget extends StatefulWidget {
  const LatestArrivalProductsWidget({super.key});

  @override
  State<LatestArrivalProductsWidget> createState() =>
      _LatestArrivalProductsWidgetState();
}

class _LatestArrivalProductsWidgetState extends State<LatestArrivalProductsWidget> {
  bool isAddedToCart = false;
  bool isHeartFilled = false;

  @override
  Widget build(BuildContext context) {
    final productModel = Provider.of<ProductModel>(context);
    final size = MediaQuery.of(context).size;
    final themeProvider = Provider.of<ThemeProvider>(context);
      final cartProvider = Provider.of<CartProvider>(context);
      final viewedProvider = Provider.of<ViewedProductsProvider>(context);
    final isDarkMode = themeProvider.getIsDarkTheme;
  
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        onTap: () async {

          viewedProvider.addProductToHistory(productId: productModel.productId);
  await Navigator.pushNamed(
    context,
    ProductDetails.routeName,
    arguments: productModel.productId, // Pass actual product ID from model
  );
},
        child: Container(
          decoration: BoxDecoration(
            color: themeProvider.getIsDarkTheme
                ? const Color.fromARGB(255, 39, 39, 39)
                : const Color.fromARGB(255, 247, 247, 247), // Background color
            borderRadius: BorderRadius.circular(15), // Rounded corners
          ),
          child: SizedBox(
            width: size.width * 0.90, 
            height: size.height*0.20,// Make the card width responsive
            child: Row(
              children: [
                // Product Image on the left
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.network(
                    productModel.productImage,
                    width: size.width * 0.40,  // Adjust image width
                    height: size.height * 0.28, // Adjust image height
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return const Center(
                        child: Icon(
                          Icons.error,
                          color: Colors.red,
                          size: 20,
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 10), // Add space between image and text

                // Details and Icons on the right side
                Expanded(  // Make sure the right side takes up the remaining space
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title and Heart Icon
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: TitleTextWidget(
                                label: productModel.productTitle, // Example product title
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                maxlines: 2,
                                color: themeProvider.getIsDarkTheme
                                    ? const Color.fromARGB(255, 255, 255, 255)
                                    : const Color.fromARGB(255, 0, 0, 0),  // Title text color based on theme
                              ),
                            ),
                            HeartButtonWidget(productId: productModel.productId)
                          ],
                        ),
                      ),

                      // Price and Cart Icon
                      Padding(
                        padding: const EdgeInsets.only(top: 5.0),
                        child: Row(
                          children: [
                            SubtitleTextWidget(
                              label: " ${productModel.productPrice}",
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.green,
                            ),
                            Spacer(),
                            IconButton(
                              icon: Icon(
                                cartProvider.isProductInCart(productId: productModel.productId)? Icons.check:Icons.add_shopping_cart_rounded,
                                    color:  isDarkMode
                                            ? Colors.white
                                            : Colors.black, 
                              ),
                              onPressed: () {
                                if(cartProvider.isProductInCart(productId: productModel.productId)){
                                      return;
                                    }
                                    cartProvider.addProductToCart(productId: productModel.productId);
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
