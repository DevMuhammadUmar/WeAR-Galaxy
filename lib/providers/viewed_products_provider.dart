import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:weargalaxy/models/view_products.dart';


class ViewedProductsProvider with ChangeNotifier{

final Map<String, ViewProducts> _viewedProductItems={};

Map<String, ViewProducts> get getViewedProds{
  return _viewedProductItems;
}

// bool isProductInWishlist({required String productId}){
//   return _viewedProductItems.containsKey(productId);
// }
void addProductToHistory({required String productId}){

  _viewedProductItems.putIfAbsent(productId,
  ()=>ViewProducts(
    id: const Uuid().v4(), 
    productId: productId));
 
 notifyListeners();
}

void clearRecent(){
  _viewedProductItems.clear();
  notifyListeners();
}




}