import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

import 'package:weargalaxy/models/wishlist_model.dart';


class WishlistProvider with ChangeNotifier{

final Map<String,WishlistModel> _wishlistItem={};

Map<String, WishlistModel> get getWishlistItems{
  return _wishlistItem;
}

bool isProductInWishlist({required String productId}){
  return _wishlistItem.containsKey(productId);
}
void addOrRemoveProductToWishlist({required String productId}){
 if (_wishlistItem.containsKey(productId)){
  _wishlistItem.remove(productId);
 }
 else{
  _wishlistItem.putIfAbsent(productId,()=>WishlistModel(id: const Uuid().v4(), productId: productId));
 }
 notifyListeners();
}



void clearWishlist(){
  _wishlistItem.clear();
  notifyListeners();
}

}