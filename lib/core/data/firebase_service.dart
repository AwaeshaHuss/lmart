import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lmart/core/data/models/cart_item.dart';
import 'package:lmart/core/data/models/product.dart';
import 'package:lmart/features/auth/presentation/screens/sign_in_screen.dart';
import 'package:lmart/features/product/presentation/widgets/bottom_nav_bar.dart';

import 'models/user_profile.dart';

class FirebaseService {
  /// Signs up a new user using email and password.
Future<UserCredential> signUpWithEmail(String email, String password) async {
  return await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email, password: password);
}

/// Signs in an existing user using email and password.
Future<UserCredential> signInWithEmail(String email, String password) async {
  return await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email, password: password);
}
/// Signs in with Google.
Future<void> signInWithGoogle(BuildContext context) async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in aborted');
    }
    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(credential);
    // Navigate to the home screen upon successful sign-in
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => BottomNavBar()));
  } on FirebaseAuthException catch (e) {
    // Handle errors here, such as showing a snackbar or dialog
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Sign-in failed: ${e.message}')),
    );
  }
}

/// Signs out the current user.
Future<void> signOut(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  await GoogleSignIn().signOut();
  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignInScreen()));
}

// ---------------------------------------
// Firestore Product Helpers
// ---------------------------------------

/// Fetches all products from Firestore.
Future<List<Product>> fetchProducts() async {
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('products').get();
    return snapshot.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      return Product.fromJson(data);
    }).toList();
  }

//===

/// Fetches detailed information for a specific product.
Future<Product> fetchProductDetails(String productId) async {
  final doc = await FirebaseFirestore.instance
      .collection('products')
      .doc(productId)
      .get();
  if (!doc.exists) throw Exception('Product not found');
  return Product.fromJson(doc.data()!);
}

// ---------------------------------------
// Cart Management Helpers
// ---------------------------------------

/// Adds a product to the user's cart in Firestore.
Future<void> addToCart(String uid, CartItem cartItem) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('cart')
      .doc(cartItem.product['id'])
      .set(cartItem.toJson(), SetOptions(merge: true));
}

/// Removes a product from the user's cart.
Future<void> removeFromCart(String uid, String productId) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('cart')
      .doc(productId)
      .delete();
}


/// Updates the quantity of a product in the cart.
Future<void> updateCartItemQuantity(
    String uid, String productId, int quantity) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('cart')
      .doc(productId)
      .update({'quantity': quantity});
}

/// Fetches all cart items for the user.
Future<List<CartItem>> fetchCartItems(String uid) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('users')
      .doc(uid)
      .collection('cart')
      .get();
  return snapshot.docs.map((doc) => CartItem.fromJson(doc.data())).toList();
}

// ---------------------------------------
// User Profile Helpers
// ---------------------------------------

/// Retrieves the user's profile from Firestore.
Future<UserProfile> getUserProfile(String uid) async {
  final doc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
  if (!doc.exists) throw Exception('User profile not found');
  return UserProfile.fromJson(doc.data()!);
}

/// Updates the user's profile in Firestore.
Future<void> updateUserProfile(UserProfile profile) async {
  await FirebaseFirestore.instance
      .collection('users')
      .doc(profile.uid)
      .set(profile.toJson(), SetOptions(merge: true));
}


// ---------------------------------------
// Push Notifications Helper
// ---------------------------------------

/// Initializes Firebase Messaging and requests permission.

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // جلب APNS Token (خاص بـ iOS)
  String? apnsToken = await messaging.getAPNSToken();
  log("APNS Token: $apnsToken");

  // طلب إذن الإشعارات (iOS)
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    log('User granted permission for notifications');
  } else {
    log('User declined or has not accepted permission');
  }

  // جلب FCM Token
  String? token = await messaging.getToken();
  log('FCM Token: $token');

  // إعداد الإشعارات المحلية
  await _setupLocalNotifications();

  // الاستماع للإشعارات أثناء تشغيل التطبيق (Foreground)
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    log('Received a message in foreground: ${message.notification?.title}');
    
    // عرض الإشعار محليًا
    _showLocalNotification(message);
  });

  // الاستماع عند النقر على الإشعار (عند تشغيل التطبيق من الخلفية أو الإنهاء)
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    log('User tapped on notification: ${message.notification?.title}');
    // يمكن التنقل إلى شاشة معينة عند الحاجة
  });
}

/// 🔔 تهيئة الإشعارات المحلية
Future<void> _setupLocalNotifications() async {
  const AndroidInitializationSettings androidSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  final DarwinInitializationSettings iosSettings = DarwinInitializationSettings(
    requestSoundPermission: true,
    requestBadgePermission: true,
    requestAlertPermission: true,
  );

  final InitializationSettings settings =
      InitializationSettings(android: androidSettings, iOS: iosSettings);

  await flutterLocalNotificationsPlugin.initialize(settings);
}

/// 🔔 عرض الإشعارات المحلية عند تلقي رسالة
Future<void> _showLocalNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails =
      AndroidNotificationDetails(
    'channel_id', // يجب أن يكون مطابقًا لقناة الإشعارات
    'Notifications',
    importance: Importance.max,
    priority: Priority.high,
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails();

  const NotificationDetails details =
      NotificationDetails(android: androidDetails, iOS: iosDetails);

  await flutterLocalNotificationsPlugin.show(
    0, // رقم فريد للإشعار
    message.notification?.title ?? "No Title",
    message.notification?.body ?? "No Body",
    details,
  );
}


// ---------------------------------------
// Product Search Helper
// ---------------------------------------

/// Searches for products in Firestore that match the [query].
Future<List<Product>> searchProducts(String query) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('products')
      .where('name', isGreaterThanOrEqualTo: query)
      .where('name', isLessThanOrEqualTo: '$query\uf8ff')
      .get();
  return snapshot.docs
      .map((doc) => Product.fromJson(doc.data()))
      .toList();
}


}