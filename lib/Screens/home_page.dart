import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/Screens/chatbot_screen.dart';
import 'package:weargalaxy/consts/weargalaxy_constants.dart';
import 'package:weargalaxy/providers/product_provider.dart';
import 'package:weargalaxy/services/assets_manager.dart';
import 'package:weargalaxy/widgets/products/Latest_arrival_products_widget.dart';
import 'package:weargalaxy/widgets/products/category_rounded_widget.dart';
import 'package:weargalaxy/widgets/titles_text.dart';


class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AssetsManager.wgb,
          height: 120,
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: size.height * 0.24,
                child: Swiper(
                  itemBuilder: (context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.asset(
                        AppConstants.bannerImages[index],
                        width: size.width,
                        height: size.height * 0.24,
                        fit: BoxFit.fitWidth,
                      ),
                    );
                  },
                  itemCount: AppConstants.bannerImages.length,
                  autoplay: true,
                  pagination: SwiperPagination(
                    alignment: Alignment.bottomCenter,
                    builder: DotSwiperPaginationBuilder(
                      color: Colors.white,
                      activeColor: const Color.fromARGB(255, 32, 32, 32),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 18,
              ),

              // AI Recommendation Button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to ChatbotScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ChatbotScreen(),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, // Background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12), // Button padding
                  ),
                  icon: const Icon(
                    Icons.remove_red_eye, // Glasses-like icon
                    color: Colors.white,
                  ),
                  label: const Text(
                    "Try AI Recommendation",
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),

              const SizedBox(
                height: 18,
              ),

              TitleTextWidget(label: 'Latest Arrival', fontSize: 22),
              SizedBox(
                height: size.height * 0.2,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: productProvider.getProducts.length,
                              itemBuilder: (context, index) {
                    return ChangeNotifierProvider.value(
                        value: productProvider.getProducts[index],
                        child: LatestArrivalProductsWidget());
                  },
                ),
              ),
              const SizedBox(
                height: 18,
              ),

              const TitleTextWidget(label: "Categories", fontSize: 22),
              const SizedBox(
                height: 15,
              ),
              GridView.count(
                  crossAxisCount: 3,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: List.generate(AppConstants.categoriesList.length,
                      (index) {
                    return CategoryRoundedWidget(
                        image: AppConstants.categoriesList[index].images,
                        name: AppConstants.categoriesList[index].name);
                  })),
            ],
          ),
        ),
      ),
    );
  }
}
