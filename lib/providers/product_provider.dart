import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:weargalaxy/models/products_model.dart';

class ProductProvider with ChangeNotifier{
List<ProductModel> get getProducts { 
  return _products;
}

ProductModel? findByProdId(String productId) {
    if (_products.where((element) => element.productId == productId).isEmpty) {
      return null;
    }
   return _products.firstWhere((element) => element.productId == productId);
      
  }

  List<ProductModel> findByCategory({required categoryName}){
    List<ProductModel> categoryList = _products.where((element)=>element.productCategory
    .toLowerCase()
    .contains(categoryName.toLowerCase()))
    .toList();

    return categoryList;
  }


  List<ProductModel> searchQuery({required String searchText, required List<ProductModel> passedList }){
    List<ProductModel> searchList = passedList.where((element)=> element.productTitle.
    toLowerCase().
    contains(searchText.toLowerCase())).
    toList();
  
  return searchList;
  }

final List<ProductModel> _products=[
        ProductModel(
  //1
  productId: const Uuid().v4(),
  productTitle: "Ray-Ban Wayfarer: The Iconic Original",
  productPrice: "2500",
  productCategory: "Mens",
  productDescription:
      "Step up your style with the legendary Ray-Ban Wayfarer sunglasses. Known for their timeless design, these sunglasses feature a durable metal frame and polarized lenses that reduce glare while enhancing visual clarity. The lightweight construction ensures comfort throughout the day, making them perfect for both casual outings and formal occasions. With UV400 protection, your eyes are shielded from harmful sun rays. Available in limited quantity—only 5 pieces left!",
  productImage: "https://fonepro.pk/wp-content/uploads/t39-640x640.png",
  productQuantity: "5",
),

ProductModel(
  //2
  productId: const Uuid().v4(),
  productTitle: "Pinhole Glasses for Eye Strain Relief & Vision Improvement",
  productPrice: "4500",
  productCategory: "Mens",
  productDescription:
      "Designed to help alleviate eye strain, these pinhole glasses are perfect for those looking to improve vision and reduce fatigue from prolonged screen time. The unique design helps stimulate the eyes and improves focus naturally. Lightweight and durable, these glasses are ideal for anyone who spends long hours reading, working, or using digital devices. Available in a limited quantity of 5.",
  productImage: "https://p.turbosquid.com/ts-thumb/KS/3R5yRw/FynoHMno/wireframe1/png/1464673178/1920x1080/fit_q87/3373cb84755a3eb425318f1b25c2dd135f483b06/wireframe1.jpg",
  productQuantity: "5",
),

ProductModel(
  //3
  productId: const Uuid().v4(),
  productTitle: "Reading Glasses Rounded - Classic Style for Men",
  productPrice: "1500",
  productCategory: "Mens",
  productDescription:
      "Classic rounded reading glasses offering superior comfort and style. With a durable frame and lightweight design, these glasses provide all-day comfort while helping you read with ease. Perfect for those who prefer a more subtle yet timeless look. With UV400 protection, your eyes are shielded from harmful rays while you read or work. Only 5 pieces available.",
  productImage: "https://p.turbosquid.com/ts-thumb/R0/UabOyk/Y4EUikoP/glass1/jpg/1597077587/1920x1080/fit_q87/bb2b676fbfefa54879dafb72fcd83851a7b284c6/glass1.jpg",
  productQuantity: "5",
),

ProductModel(
  //4
  productId: const Uuid().v4(),
  productTitle: "Chic & Stylish Cat-Eye Glasses: A Bold Fashion Statement for Women",
  productPrice: "2500",
  productCategory: "Womens",
  productDescription:
      "Make a bold fashion statement with these chic and stylish cat-eye glasses. Designed for those who want to stand out, these glasses feature a sleek, vintage-inspired frame that adds a touch of sophistication to any look. Whether you're dressing up for a night out or keeping it casual, these glasses will elevate your style while providing UV400 protection for your eyes. Limited stock—only 5 pieces available!",
  productImage: "https://p.turbosquid.com/ts-thumb/q5/hCfzK7/Pg/ana/jpg/1694281017/1920x1080/fit_q87/6d68369c9c498cc039171fe39578073deef8986c/ana.jpg",
  productQuantity: "5",
),

ProductModel(
  //5
  productId: const Uuid().v4(),
  productTitle: "Rounded Frame Glasses - Versatile and Timeless",
  productPrice: "800",
  productCategory: "Womens",
  productDescription:
      "These rounded frame glasses offer a versatile and timeless design, perfect for any occasion. With a sleek, modern shape, they provide a comfortable fit and stylish appeal for both men and women. Equipped with UV400 protection, they ensure your eyes are safe from the sun's harmful rays. Available now in limited quantities—only 5 pieces left.",
  productImage: "https://p.turbosquid.com/ts-thumb/Y6/nHwJGW/jR/0p1x1/jpg/1669330544/1920x1080/fit_q87/8c2aff4c7bef18769a0f9af41e034253d64c5c02/0p1x1.jpg",
  productQuantity: "5",
),


ProductModel(
  //7
  productId: const Uuid().v4(),
  productTitle: "Heart-Shaped Glasses for a Fun & Unique Look",
  productPrice: "1200",
  productCategory: "Kids",
  productDescription:
      "Add a fun and unique twist to your look with these heart-shaped glasses. Perfect for those who want to express their playful side, these glasses combine a light-hearted design with durability and comfort. Featuring UV400 protection to shield your eyes from harmful sun rays, they’re a great choice for outdoor events, festivals, or just adding a bit of fun to your everyday style. Only 5 pieces available.",
  productImage: "https://p.turbosquid.com/ts-thumb/uJ/VYs9x1/Er/1000040855/png/1723039234/1920x1080/fit_q87/86bfe4ecf20d52aac3d8c168be8100e6ac70d514/1000040855.jpg",
  productQuantity: "5",
),

ProductModel(
  //8
  productId: const Uuid().v4(),
  productTitle: "Aviator Glasses - Classic Style with Timeless Appeal",
  productPrice: "2200",
  productCategory: "Unisex",
  productDescription:
      "Embrace a classic look with these aviator glasses, designed with a sleek metal frame and polarized lenses to reduce glare. Lightweight and comfortable, these glasses are perfect for both casual and formal occasions. Whether you're driving, walking in the sun, or just out with friends, these aviators will keep you looking sharp while offering UV400 protection for your eyes. Limited stock—only 5 pieces remaining.",
  productImage: "https://p.turbosquid.com/ts-thumb/Xb/hLjYpP/5A/glasses/png/1710675256/1920x1080/fit_q87/bf50c1d038fbde923bff8013ae0188b40da56353/glasses.jpg",
  productQuantity: "5",
),

];

}