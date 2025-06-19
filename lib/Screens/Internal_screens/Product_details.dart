// ignore: file_names
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/providers/cart_provider.dart';
import 'package:weargalaxy/providers/product_provider.dart';

import 'package:weargalaxy/services/assets_manager.dart';
import 'package:weargalaxy/widgets/products/heart_button_widget.dart';
import 'package:weargalaxy/widgets/subtitles_text.dart';
import 'package:weargalaxy/widgets/titles_text.dart';

class ProductDetails extends StatefulWidget {
  static const routeName = "/ProductDetails";
  const ProductDetails({super.key});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
 
  @override
  Widget build(BuildContext context) {
     final size = MediaQuery.of(context).size;
     final productProvider=Provider.of<ProductProvider>(context,listen: false);
     final productId = ModalRoute.of(context)?.settings.arguments as String? ?? "default_product_id";
     final getCurrentProduct = productProvider.findByProdId(productId);
     final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      
       appBar: AppBar(
        title: Image.asset(
          AssetsManager.wgb,
          height: 120,
        ),
        leading: Padding(padding: 
        EdgeInsets.all(8.0),
        child: IconButton(onPressed: (){
          Navigator.canPop(context) ? Navigator.pop(context):null;
        }, icon: Icon(Icons.arrow_back_ios),color: Colors.white,),),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
         
         Image(
          image: NetworkImage(getCurrentProduct!.productImage),
          height: size.height * 0.38,
          width: double.infinity,
          fit: BoxFit.contain,
        ),
        
           Padding(
             padding: const EdgeInsets.all(8.0),
             child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Flexible(child: Text(getCurrentProduct.productTitle,style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
             
                    ),)),
                    SizedBox(
                      width: 10,
                    ),
             
                    SubtitleTextWidget(label:"${getCurrentProduct.productPrice}",color: Colors.green,fontSize: 20,fontWeight: FontWeight.bold,)
                  ],
                ),
        
                 SizedBox(
                      height: 25,
                    ),
             
             Padding(
               padding: const EdgeInsets.symmetric(horizontal: 30),
               child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  HeartButtonWidget(
                    color: const Color.fromARGB(255, 219, 15, 0), productId: getCurrentProduct.productId,
                  ),
                  SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: SizedBox(
                        height: kBottomNavigationBarHeight-6,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 41, 41, 41),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            )
                        
                          ),
                          onPressed: (){
                            if(cartProvider.isProductInCart(productId: getCurrentProduct.productId)){
                              return;
                            }
                            cartProvider.addProductToCart(productId: getCurrentProduct.productId);


                          }, label: Text(
                            cartProvider.isProductInCart(productId: getCurrentProduct.productId)
                            ?"Added to Cart"
                            :"Add to cart",
                            ),
                            
                          icon: Icon(
                            cartProvider.isProductInCart(productId: getCurrentProduct.productId)
                            ?Icons.check
                            :Icons.add_shopping_cart_rounded,color: Colors.white,),),
                      ),
                    )
                ],
               ),
             ),
               SizedBox(
            height: 25,
           ),
           Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TitleTextWidget(label: "About this item"),
              SubtitleTextWidget(label: getCurrentProduct.productCategory)
            ],
           ),
              SizedBox(
            height: 25,
           ),
           SubtitleTextWidget(label:getCurrentProduct.productDescription ,fontSize: 14,fontWeight:FontWeight.normal,)
              ],
             ),
        
             
           ),
         
          ],
        ),
      ),
    );
  }
}