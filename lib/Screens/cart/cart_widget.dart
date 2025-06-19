import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/Screens/cart/quantity_bottom_sheet_widget.dart';
import 'package:weargalaxy/models/cart_model.dart';
import 'package:weargalaxy/providers/cart_provider.dart';
import 'package:weargalaxy/providers/product_provider.dart';
import 'package:weargalaxy/widgets/subtitles_text.dart';
import 'package:weargalaxy/widgets/titles_text.dart';
import 'package:weargalaxy/providers/theme_provider.dart';

class CartWidget extends StatelessWidget {
  const CartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cartModelProvider = Provider.of<CartModel>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final getCurrentProduct = productProvider.findByProdId(cartModelProvider.productId);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkTheme = themeProvider.getIsDarkTheme;

    if (getCurrentProduct == null) return const SizedBox.shrink();

    final cartProvider = Provider.of<CartProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0), // Reduce padding
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center, // Align items in the middle
        children: [
          // Smaller image with rounded corners
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              height: 120, // Smaller height
              width: 120, // Smaller width
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                  ),
                ],
              ),
              child: Image.network(
                getCurrentProduct.productImage,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(width: 8), // Smaller spacing between image and text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title with smaller font size and single line
                Row(
                  children: [
                    Expanded(
                      child: TitleTextWidget(
                        label: getCurrentProduct.productTitle,
                        maxlines: 2, // Limit to 1 line
                        fontSize: 14, // Smaller font size
                      ),
                    ),
                    IconButton(
                      onPressed: () {}, // Empty function for favorite icon
                      icon: const Icon(IconlyLight.heart, size: 25),
                      color: isDarkTheme
                          ? const Color.fromARGB(255, 255, 255, 255)
                          : const Color.fromARGB(255, 0, 0, 0),
                      padding: EdgeInsets.zero, // Remove extra padding
                      constraints: const BoxConstraints(),
                    ),
                    IconButton(
                      onPressed: () {
                        cartProvider.removeOneItem(productId: getCurrentProduct.productId);
                      },
                      icon: const Icon(Icons.delete, size: 18),
                      color: isDarkTheme
                          ? const Color.fromARGB(255, 255, 255, 255)
                          : const Color.fromARGB(255, 0, 0, 0),
                      padding: EdgeInsets.zero, // Remove extra padding
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SubtitleTextWidget(
                      label: "\Rs. ${getCurrentProduct.productPrice}",
                      fontSize: 16, // Smaller font size
                      color: isDarkTheme ? Colors.white : Colors.black,
                    ),
                    OutlinedButton.icon(
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(30, 30), // Smaller button size
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        side: const BorderSide(width: 1, color: Colors.blueAccent),
                      ),
                      onPressed: () async {
                        await showModalBottomSheet(
                          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(16.0),
                              topRight: Radius.circular(16.0),
                            ),
                          ),
                          context: context,
                          builder: (context) {
                            return QuantityBottomSheetWidget(
                              cartModel: cartModelProvider,
                            );
                          },
                        );
                      },
                      icon: const Icon(IconlyLight.arrowDown2, size: 16), // Smaller icon
                      label: Text(
                        "${cartModelProvider.quantity}",
                        style: const TextStyle(fontSize: 12), // Smaller text size
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
