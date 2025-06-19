import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/Screens/cart/payment.dart';
import 'package:weargalaxy/providers/cart_provider.dart';
import 'package:weargalaxy/providers/product_provider.dart';
import 'package:weargalaxy/widgets/subtitles_text.dart';
import 'package:weargalaxy/widgets/titles_text.dart';

class CartBottomCheckout extends StatefulWidget {
  const CartBottomCheckout({super.key});

  @override
  State<CartBottomCheckout> createState() => _CartBottomCheckoutState();
}

class _CartBottomCheckoutState extends State<CartBottomCheckout> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
     final productProvider = Provider.of<ProductProvider>(context);
     return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        border: Border(
          top: BorderSide(
            width: 1,
            color: Colors.grey,
          ),
        ),
      ),
      child: SizedBox(
       
        height: kBottomNavigationBarHeight + 40,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Making the column flexible so it takes available width
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      child: TitleTextWidget(label: 'Total (${cartProvider.getCartItems.length}Products/${cartProvider.getQuantity()} Items'),
                    ),
                    SubtitleTextWidget(
                      label: '${cartProvider.getTotal(ProductProvider: productProvider)}',
                      color: Colors.blueAccent,
                    ),
                  ],
                ),
              ),
              // Checkout button should take space dynamically
              Expanded(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Payment.routeName);
                    },
                    child: Text('Checkout'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
