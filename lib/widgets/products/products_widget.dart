import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/Screens/Internal_screens/Product_details.dart';
import 'package:weargalaxy/providers/cart_provider.dart';
import 'package:weargalaxy/providers/product_provider.dart';
import 'package:weargalaxy/providers/theme_provider.dart'; // Import the ThemeProvider
import 'package:weargalaxy/providers/viewed_products_provider.dart';
import 'package:weargalaxy/widgets/products/heart_button_widget.dart';
import 'package:weargalaxy/widgets/titles_text.dart';
import 'package:weargalaxy/widgets/subtitles_text.dart';


class ProductsWidget extends StatefulWidget {
  final String productId;
  const ProductsWidget({super.key, required this.productId});

  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  bool isAddedToCart = false; // Track if the cart icon is pressed

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context); // Access theme provider
    final getCurrentProduct = productProvider.findByProdId(widget.productId);
    final cartProvider = Provider.of<CartProvider>(context);
    final viewedProvider = Provider.of<ViewedProductsProvider>(context);

    // Get the current theme colors
    final isDarkMode = themeProvider.getIsDarkTheme;
    final backgroundColor = isDarkMode
        ? const Color.fromARGB(255, 39, 39, 39) // Dark background color
        : const Color.fromARGB(255, 247, 247, 247); // Light background color
    final textColor = isDarkMode ? Colors.white : Colors.black; // Text color for dark/light mode

    return getCurrentProduct == null
        ? SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                color: backgroundColor, // Set background color based on theme
                borderRadius: BorderRadius.circular(12),
              ),
              child: GestureDetector(
                onTap: () async {
                  
                  viewedProvider.addProductToHistory(productId: getCurrentProduct.productId);
                  await Navigator.pushNamed(
                    context,
                    ProductDetails.routeName,
                    arguments: getCurrentProduct.productId,
                  );
                },
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Column(
                    children: [
                      Image.network(
                        getCurrentProduct.productImage,
                        fit: BoxFit.contain,
                        width: double.infinity,
                        height: 150,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) {
                            return child;
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      (loadingProgress.expectedTotalBytes ?? 1)
                                  : null,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8.0, vertical: 2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Title and price section
                            Flexible(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TitleTextWidget(
                                    label: getCurrentProduct.productTitle,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14, // Adjust as needed
                                    maxlines: 2,
                                    color: textColor, // Set text color based on theme
                                  ),
                                  SubtitleTextWidget(
                                    label: "Rs\ ${getCurrentProduct.productPrice}",
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14, // Adjust as needed
                                    color: Colors.green,
                                  ),
                                ],
                              ),
                            ),
                            // Heart and cart section
                            Column(
                              children: [
                                HeartButtonWidget(productId: getCurrentProduct.productId,),
                                IconButton(
                                  
                                  icon: Icon(
                                    
                                    cartProvider.isProductInCart(productId: getCurrentProduct.productId)? Icons.check:Icons.add_shopping_cart_rounded,
                                    color:  isDarkMode
                                            ? Colors.white
                                            : Colors.black, // Cart icon color based on theme
                                  ),
                                  onPressed: () {
                                    if(cartProvider.isProductInCart(productId: getCurrentProduct.productId)){
                                      return;
                                    }
                                    cartProvider.addProductToCart(productId: getCurrentProduct.productId);
                                  },
                                ),
                              ],
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
