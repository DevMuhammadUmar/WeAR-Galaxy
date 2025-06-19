import 'package:dynamic_height_grid_view/dynamic_height_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';
import 'package:weargalaxy/models/products_model.dart';
import 'package:weargalaxy/providers/product_provider.dart';
import 'package:weargalaxy/services/assets_manager.dart';
import 'package:weargalaxy/widgets/products/products_widget.dart';
import 'package:weargalaxy/widgets/titles_text.dart';

class SearchScreen extends StatefulWidget {
  static const routeName = "/SearchScreen";
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late TextEditingController searchTextController;

   List<ProductModel> productListSearch = [];
  @override
  void initState() {
    searchTextController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    String? passedCategory = ModalRoute.of(context)!.settings.arguments as String?;
    final List<ProductModel> productList = passedCategory==null ? 
    productProvider.getProducts 
    : productProvider.findByCategory(categoryName: passedCategory);
    return GestureDetector(
      onTap: () {
        searchTextController.clear();
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Image.asset(
            AssetsManager.wgb,
            height: 120,
          ),
          centerTitle: true,
        ),
        body: productList.isEmpty 
        ? const Center( child: TitleTextWidget(label: 'No Glasses Found !'),)
        :Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Search Field
              TextFormField(
                controller: searchTextController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: "Search...",
                  hintStyle: const TextStyle(color: Colors.black54),
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 10),
                    child: Icon(
                      IconlyLight.search,
                      color: Colors.black,
                    ),
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        searchTextController.clear();
                      });
                    },
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 10),
                      child: Icon(
                        IconlyLight.closeSquare,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Colors.grey,
                      width: 1.5,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: const BorderSide(
                      color: Color.fromARGB(255, 32, 32, 32),
                      width: 2,
                    ),
                  ),
                ),
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                onFieldSubmitted: (value) {
                  setState(() {
                    productListSearch = productProvider.searchQuery(searchText: searchTextController.text, passedList: productList);
                  });
                },
                onChanged: (value){
                    setState(() {
                    productListSearch = productProvider.searchQuery(searchText: searchTextController.text, passedList: productList);
                  });
                },
              ),

              const SizedBox(height: 10), // Space between search field and grid

              // Expanded Grid View
              if(searchTextController.text.isNotEmpty && productListSearch.isEmpty)...[
                const Center(child: TitleTextWidget(label: 'No Results Found !',fontSize: 30,),),
              ],
              Expanded(
                child: DynamicHeightGridView(
                  builder: (context, index) {
                    return ProductsWidget(productId: 
                    searchTextController.text.isNotEmpty 
                    ? productListSearch[index].productId
                    :productList[index].productId,
                    
                    );
                  },
                  itemCount: searchTextController.text.isNotEmpty ? productListSearch.length:productList.length,
                  crossAxisCount: 2,
                  mainAxisSpacing: 0, // Adjust spacing between rows
                  crossAxisSpacing: 0, // Adjust spacing between columns
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
