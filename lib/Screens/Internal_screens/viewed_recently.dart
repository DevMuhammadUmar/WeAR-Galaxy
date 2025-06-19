import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/providers/viewed_products_provider.dart';
import 'package:weargalaxy/services/assets_manager.dart';
import 'package:weargalaxy/services/weargalaxy_app_methods.dart';
import 'package:weargalaxy/widgets/empty_bag_widget.dart';
import 'package:weargalaxy/widgets/products/products_widget.dart';



class ViewedRecently extends StatelessWidget {
  static const routName = "/ViewedRecently";
  const ViewedRecently({super.key});
  final bool isEmpty = false;
  @override
  Widget build(BuildContext context) {
    final viewedProdProvider = Provider.of<ViewedProductsProvider>(context);
        

    return viewedProdProvider.getViewedProds.isEmpty
        ? Scaffold(
            body: EmptyBagWidget(
              imagePath: AssetsManager.orderBag,
              title: "No viewed products yet",
              subtitle:
                  "Looks like you havent viewd anything",
              buttonText: "View Now",
            ),
          )
        : Scaffold(
        appBar: AppBar(
  title: Image.asset(
    AssetsManager.wgb,
    height: 120,
  ),
  centerTitle: true,
  actions: [
    IconButton(
      onPressed: () {
         WeargalaxyAppMethods.showErrorOrWarningDialog(
                      isError: false,
                      context: context,
                      subtitle: "Clear Viewed Recently Items?",
                      fct: () {
                      viewedProdProvider.clearRecent();
                      },
         );
      },
      icon: Icon(Icons.delete,color: Colors.white,), // You can use any icon here
    ),
  ],
),
        
           body: DynamicHeightGridView(
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              builder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ProductsWidget(
                      productId: viewedProdProvider.getViewedProds.values
                          .toList()[index]
                          .productId),
                );
              },
              itemCount: viewedProdProvider.getViewedProds.length,
              crossAxisCount: 2,
            ),
          );
  }
}
