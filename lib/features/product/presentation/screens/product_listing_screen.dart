import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lmart/config/cache/cache_helper.dart';
import 'package:lmart/config/providers/bottom_nav_bar_provider.dart';
import 'package:lmart/core/colors/app_colors.dart';
import 'package:lmart/core/data/firebase_service.dart';
import 'package:lmart/core/data/models/product.dart';
import 'package:lmart/core/fonts/app_fonts.dart';
import 'package:lmart/core/utils.dart';
import 'package:lmart/features/auth/presentation/screens/profile_screen.dart';
import 'package:lmart/features/product/presentation/screens/product_details_screen.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  _ProductListingScreenState createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  String searchQuery = '';
  late Future<List<Product>> _productsFuture;
  List<Product> allProducts = [];
  List<Product> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _productsFuture = FirebaseService().fetchProducts();
    onAppLaunch();
  }

  Future<void> onAppLaunch() async {
    await CacheHelper().incrementLaunchCount();
    int launchCount = CacheHelper().getLaunchCount();
    if (launchCount <=3) {
      // ! THE SHOULD BE INSTALLED ON THE PLAY STORE FOR INAPPREVIEW TO FUNCTION[REGARD TO THE DOCS]
      await requestInAppReview();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(getLoc(context).productsTitle),
        centerTitle: false,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsetsDirectional.only(end: 8.0),
            child: IconButton.outlined(
              onPressed: () {
                BottomNavBarProvider.read(context).setSelectedIndex(2);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(builder: (context) => ProfileScreen()),
                // );
              },
              icon: const Icon(Icons.person),
            ),
          )
        ],
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(strokeWidth: 1, color: AppColors.primaryColor),
            );
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text(getLoc(context).noProductsAvailable));
          }
          allProducts = snapshot.data!;
          filteredProducts = allProducts
              .where((product) => product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                  product.description.toLowerCase().contains(searchQuery.toLowerCase()))
              .toList();

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.deepPurple.shade50, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            padding: const EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, // Two columns
                childAspectRatio: 0.7,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
              ),
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ProductDetailsScreen(product: product)),
                    );
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product image with rounded top corners
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(16),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              placeholder: (context, url) => Container(
                                color: Colors.grey.shade300,
                                child: const Center(
                                  child: CircularProgressIndicator(strokeWidth: 1, color: AppColors.primaryColor),
                                ),
                              ),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                        // Product details section
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            product.name,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Text(
                            product.description,
                            style: AppFonts.proximaNova12Regular.copyWith(fontWeight: FontWeight.w200),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showSearchDialog();
        },
        backgroundColor: AppColors.primaryColor,
        child: const Icon(Icons.search),
      ),
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(getLoc(context).searchProductsTitle),
          content: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: getLoc(context).searchHint,
            ),
            onChanged: (value) {
              setState(() {
                searchQuery = value;
                filteredProducts = allProducts
                    .where((product) => product.name.toLowerCase().contains(searchQuery.toLowerCase()) ||
                        product.description.toLowerCase().contains(searchQuery.toLowerCase()))
                    .toList();
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text(getLoc(context).cancelButton),
            ),
          ],
        );
      },
    );
  }
}
