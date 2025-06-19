import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/models/cart_model.dart';
import 'package:weargalaxy/providers/cart_provider.dart';
import 'package:weargalaxy/widgets/subtitles_text.dart';

class QuantityBottomSheetWidget extends StatelessWidget {
  final CartModel cartModel;
  const QuantityBottomSheetWidget({super.key, required this.cartModel});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Column(
      children: [
        const SizedBox(
          height: 20,
        ),
        Container(
          height: 6,
          width: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: Colors.grey,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Expanded(
          child: Center(
            // Centers the content within the available space
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: 300, // Set maximum height for the list
                maxWidth: 200, // Set maximum width for the list
              ),
              child: ListView.builder(
                shrinkWrap: true, // Ensures the list only takes up needed space
                itemCount: 30,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      cartProvider.updateQuantity(productId: cartModel.productId, quantity: index + 1);
                      Navigator.pop(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Center(
                        // Ensures each item is also centered horizontally
                        child: SubtitleTextWidget(
                          label: '${index + 1}',
                          fontSize: 20,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
