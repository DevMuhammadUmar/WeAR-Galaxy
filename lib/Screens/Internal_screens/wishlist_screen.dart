import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/providers/wishlist_provider.dart';
import 'package:weargalaxy/services/assets_manager.dart';
import 'package:weargalaxy/services/weargalaxy_app_methods.dart';
import 'package:weargalaxy/widgets/empty_bag_widget.dart';
import 'package:weargalaxy/widgets/products/products_widget.dart';
import 'package:weargalaxy/widgets/titles_text.dart';


class WishlistScreen extends StatelessWidget {
  static const routeName = "/WishlistScreen";
  const WishlistScreen({super.key});
  final bool isEmpty = true;
  @override
  Widget build(BuildContext context) {
    final wishlistProvider = Provider.of<WishlistProvider>(context);

    return wishlistProvider.getWishlistItems.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.bagWish,
              title: "Nothing in ur wishlist yet",
              subtitle:
                  "Looks like your cart is empty add something and make me happy",
              buttonText: "Shop now",
            ),
          )
        : Scaffold(
            appBar: AppBar(
              leading: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  AssetsManager.wgb,
                ),
              ),
              title: TitleTextWidget(color: Colors.white,
                  label: "Wishlist (${wishlistProvider.getWishlistItems.length})"),
              actions: [
                IconButton(
                  onPressed: () {
                    WeargalaxyAppMethods.showErrorOrWarningDialog(
                      isError: false,
                      context: context,
                      subtitle: "Clear Wishlist?",
                      fct: (){wishlistProvider.clearWishlist();}
                    );
                  },
                  icon: const Icon(
                    Icons.delete,
                    color: Color.fromARGB(255, 255, 255, 255),
                  ),
                ),
              ],
            ),
            body: DynamicHeightGridView(
              itemCount: wishlistProvider.getWishlistItems.length,
              mainAxisSpacing: 12,
              crossAxisSpacing: 10,
              builder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: ProductsWidget(
                    productId: wishlistProvider.getWishlistItems.values
                        .toList()[index]
                        .productId,
                  ),
                );
              },
              
              crossAxisCount: 2,
            ),
          );
  }
}
