import 'package:weargalaxy/models/categories_model.dart';
import 'package:weargalaxy/services/assets_manager.dart';

class AppConstants {
  // ignore: non_constant_identifier_names
  static String ProductImageUrl = 'https://images.pexels.com/photos/14461331/pexels-photo-14461331.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1';

static List<String> bannerImages = [
  AssetsManager.banner1,
  AssetsManager.banner2,
];

static List<CategoryModel> categoriesList=[
  CategoryModel(
    id: "Mens",
    images: AssetsManager.mobiles,
    name: "Mens"),
    CategoryModel(
    id: "Womens",
    images: AssetsManager.watch,
    name: "Womens"),
    CategoryModel(
    id: "Kids",
    images: AssetsManager.book,
    name: "Kids"),
    // CategoryModel(
    // id: "Sunglasses",
    // images: AssetsManager.cosmetics,
    // name: "Sunglasses"),
    CategoryModel(
    id: "unisex",
    images: AssetsManager.pc,
    name: "Unisex"),
    CategoryModel(
    id: "sale",
    images: AssetsManager.electronics,
    name: "Sale"),

    // CategoryModel(
    // id: "Chatbot",
    // images: AssetsManager.shoes,
    // name: "ChatBot"),
];

static String apiKey = ' ';
static String appID = ' ';
static String messagingSenderId = '';
static String projectId =' ';
static String storagebucket = ' ';


}