import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/providers/wishlist_provider.dart';

class HeartButtonWidget extends StatefulWidget {
  final double size;
  final Color color;
  final String productId;
  const HeartButtonWidget({super.key, this.size = 22, this.color = Colors.transparent, required this.productId});

  @override
  State<HeartButtonWidget> createState() => _HeartButtonWidgetState();
}

class _HeartButtonWidgetState extends State<HeartButtonWidget> {
  @override
  Widget build(BuildContext context) {

    // Check if the theme is dark or light
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final wishlistProvider = Provider.of<WishlistProvider>(context);
    
    // Determine the icon color based on the theme
    final heartColor = isDarkMode ? Colors.white : Colors.black;

    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: widget.color, // Maintain passed color for background
      ),
      child: IconButton(
        style: IconButton.styleFrom(
          shape: CircleBorder(),
        ),
        onPressed: () {
            wishlistProvider.addOrRemoveProductToWishlist(productId: widget.productId);
        }, // You can implement the onPressed functionality later
        icon: Icon(
          wishlistProvider.isProductInWishlist(productId: widget.productId)?
          IconlyBold.heart
          :IconlyLight.heart, // Keep the heart icon as it is
          size: widget.size,
          color: heartColor, // Set the heart icon color based on the theme
        ),
      ),
    );
  }
}
