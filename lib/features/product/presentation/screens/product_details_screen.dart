import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:lmart/config/providers/bottom_nav_bar_provider.dart';
import 'package:lmart/core/colors/app_colors.dart';
import 'package:lmart/core/data/models/cart_item.dart';
import 'package:lmart/core/data/models/product.dart';
import 'package:lmart/core/data/firebase_service.dart';
import 'package:lmart/core/utils.dart';
import 'package:lmart/features/product/presentation/widgets/bottom_nav_bar.dart';

class ProductDetailsScreen extends StatefulWidget {
  final Product product;

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool _isAdding = false;
  String? _errorMessage;

  Future<void> _addToCart() async {
    setState(() {
      _isAdding = true;
      _errorMessage = null;
    });
    try {
      // Call the FirebaseService function to add the product to the cart.
      // This function should be defined in your firebase_service.dart.
      User? user = FirebaseAuth.instance.currentUser;
      CartItem cartItem = CartItem(product: widget.product.toJson(), quantity: 1);
      await FirebaseService().addToCart(user?.uid ?? '', cartItem);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: 
          // Text('${widget.product.name} added to cart!')
          Text(getLoc(context).productAddedToCart(widget.product.name))
          ),
        );
        BottomNavBarProvider.read(context).setSelectedIndex(1);
       await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavBar()));
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isAdding = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
        centerTitle: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            CachedNetworkImage(
              imageUrl: widget.product.imageUrl,
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 250,
                color: AppColors.white_1,
                child: const Center(child: CircularProgressIndicator(strokeWidth: 1, color: AppColors.primaryColor,)),
              ),
              errorWidget: (context, url, error) => Container(
                height: 250,
                color: AppColors.white_1,
                child: const Icon(Icons.error),
              ),
            ),
            const SizedBox(height: 16),
            // Product Name
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.product.name,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 8),
            // Product Description
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                widget.product.description,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
            ),
            const SizedBox(height: 8),
            // Product Price
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                '\$${widget.product.price.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.secondaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),
            if (_errorMessage != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  _errorMessage!,
                  style: const TextStyle(color: AppColors.red),
                ),
              ),
            const SizedBox(height: 12),
            Center(
              child: _isAdding
                  ? const CircularProgressIndicator(strokeWidth: 1, color: AppColors.primaryColor,)
                  : ElevatedButton(
                      onPressed: _addToCart,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        backgroundColor: AppColors.primaryColor,
                      ),
                      child: Text(
                        getLoc(context).addToCartButton,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppColors.white_1,
                        ),
                      ),
                    ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
