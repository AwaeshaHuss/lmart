import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_stripe/flutter_stripe.dart' as fs;
import 'package:lmart/config/network/http_service.dart';
import 'package:lmart/core/colors/app_colors.dart';
import 'package:lmart/core/data/firebase_service.dart';
import 'package:lmart/core/data/models/cart_item.dart';
import 'package:lmart/core/fonts/app_fonts.dart';
import 'package:lmart/core/strings.dart';
import 'package:lmart/core/utils.dart';


class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  late final String uid;
  Map<String, dynamic>? paymentIntent;
  double total = 0;

  @override
  void initState() {
    super.initState();
    // Assumes the user is already authenticated.
    uid = FirebaseAuth.instance.currentUser!.uid;
  }

  Future<List<CartItem>> _fetchCartItems() async {
    // Fetch cart items from Firestore for the given user.
    return await FirebaseService().fetchCartItems(uid);
  }

  Future<void> _updateQuantity(CartItem item, int newQuantity) async {
    if (newQuantity < 1) return;
    await FirebaseService().updateCartItemQuantity(uid, item.product['id'] ?? '', newQuantity);
    setState(() {}); // Refresh the screen after update.
  }

  Future<void> _removeItem(CartItem item) async {
    await FirebaseService().removeFromCart(uid, item.product['id'] ?? '');
    setState(() {}); // Refresh the screen after removal.
  }

  Widget _buildCartItem(CartItem item) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            // Product image with rounded corners.
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: item.product['imageUrl'] ?? '',
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: AppColors.white_1,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            // Product details and quantity controls.
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product['name'] ?? '',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${item.product['price'].toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () {
                          _updateQuantity(item, item.quantity - 1);
                        },
                      ),
                      Text(
                        item.quantity.toString(),
                        style: const TextStyle(fontSize: 16),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () {
                          _updateQuantity(item, item.quantity + 1);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: AppColors.red),
              onPressed: () {
                _removeItem(item);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartList(List<CartItem> items) {
    total = items.fold(0, (sum, item) => sum + (item.product['price'] * item.quantity));
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return _buildCartItem(items[index]);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(getLoc(context).cartTitle),
        centerTitle: false,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<CartItem>>(
              future: _fetchCartItems(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(strokeWidth: 1, color: AppColors.primaryColor,));
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text(getLoc(context).cartEmptyMessage));
                }
                final cartItems = snapshot.data!;
                return _buildCartList(cartItems);
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(onPressed: () async => await payment(), label: Padding(
              padding: EdgeInsets.all(8.0),
              child: Text(getLoc(context).checkoutButton, style: AppFonts.proximaNova22Regular,),
            ), icon: Icon(Icons.paypal),),
          )
        ],
      ),
    );
  }

   Future<void> payment() async {
    try{

      Map<String, dynamic> body = {
        "amount": "${total.toInt()}",
        "currency": "USD"
      };
      var authorization = "Bearer $stripSecret";
      var response = 
      await HttpService().call("https://api.stripe.com/v1/payment_intents", method: HttpMethod.post, headers: {
         "Authorization": authorization,
      }, body: body);
      paymentIntent = json.decode(response.body);
    }catch (error){
      throw Exception(error);
    }

    await fs.Stripe.instance.initPaymentSheet(paymentSheetParameters: fs.SetupPaymentSheetParameters(
      paymentIntentClientSecret: paymentIntent!["client_secret"],
      style: ThemeMode.system,
      merchantDisplayName: "Indigo",
    )).then((value) => {});

    try{
      await fs.Stripe.instance.presentPaymentSheet().then((value) => {
        print("Payment Sucess!")
      });
    }catch (error){
      throw Exception(error);
    }
  }
}
