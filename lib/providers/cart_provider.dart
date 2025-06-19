import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:weargalaxy/models/cart_model.dart';
import 'package:weargalaxy/models/products_model.dart';
import 'package:weargalaxy/providers/product_provider.dart';

class CartProvider with ChangeNotifier{

final Map<String,CartModel> _cartitems={};

Map<String, CartModel> get getCartItems{
  return _cartitems;
}

bool isProductInCart({required String productId}){
  return _cartitems.containsKey(productId);
}
void addProductToCart({required String productId}){
  _cartitems.putIfAbsent(productId,()=>CartModel(
    cartId: Uuid().v4(),
     productId: productId, 
     quantity: 1),
     );
     notifyListeners();
}
void updateQuantity({required String productId,required int quantity}){
  _cartitems.update(productId,
  (item)=>CartModel(
    cartId: item.cartId,
     productId: productId,
      quantity: quantity) );
      
       notifyListeners();
}

double getTotal({required ProductProvider ProductProvider}){

double total=0.0;
_cartitems.forEach((key, value) {
  final ProductModel? getCurrProduct = ProductProvider.findByProdId(value.productId);
  if (getCurrProduct==null){
    total+=0;
  }
  else{
    total += double.parse(getCurrProduct.productPrice) * value.quantity;
  }
},);

return total;
}


int getQuantity(){
  int total=0;
  _cartitems.forEach((key,value){
    total += value.quantity;
  });
  return total;
}

void removeOneItem({required String productId}){
  _cartitems.remove(productId);
  notifyListeners();
}

void clearCart(){
  _cartitems.clear();
  notifyListeners();
}

}