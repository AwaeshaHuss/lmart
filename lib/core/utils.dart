import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';


AppLocalizations getLoc(BuildContext context)=> AppLocalizations.of(context)!;

extension WidgetMargin on num{
  SizedBox get height => SizedBox(height: toDouble(),);
  SizedBox get width => SizedBox(width: toDouble(),);
  Size get size => Size(height.height ?? toDouble(), width.width ?? toDouble());
}

class ShowToastSnackBar {
  static Future<bool?> displayToast({
    required String? message,
    bool isError = false,
    bool isSuccess = false,
  }) {
    return Fluttertoast.showToast(
        msg: message!,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 2,
        textColor: Colors.white,
        backgroundColor: const Color(0xff7A3FE1),
        fontSize: 14.0);

  }

  static void showSnackBars(BuildContext context,
      {required String? message,
        bool isError = false,
        bool isSuccess = false,
        Duration? duration,
        SnackBarAction? snackBarAction}) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message!,
      ),
      duration: duration ?? const Duration(seconds: 3),
      action: snackBarAction,
      backgroundColor: isError
          ? Colors.red[800]
          : isSuccess
          ? Colors.green[800]
          : null,
    ));
  }
}

void setDefaultAppOrientation(){
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp
  ]);
}


// ---------------------------------------
// Payment Integration Helper (Stripe)
// ---------------------------------------

/// Processes a payment using Stripe.
/// [amount] is the payment amount, and [paymentData] should include necessary info
/// such as the client secret.
Future<void> processStripePayment({
  required double amount,
  required Map<String, dynamic> paymentData,
}) async {
  try {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentData['clientSecret'] ?? 'secret',
        merchantDisplayName: 'Lmart',
      ),
    );
    await Stripe.instance.presentPaymentSheet();
    log('Payment completed');
  } catch (e) {
    log('Payment failed: $e');
    rethrow;
  }
}


// ---------------------------------------
// Image Picking and Cropping Helper
// ---------------------------------------

/// Allows the user to pick an image from the gallery and crop it.
Future<File?> pickAndCropImage(context) async {
    // Requesting permissions before picking image
    PermissionStatus status = await Permission.photos.request();
    if (!status.isGranted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Permission denied. Please allow access to photos.")),
      );
      return null;
    }

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return null;

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Crop Image',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
        ),
        IOSUiSettings(title: 'Crop Image'),
      ],
    );
    if (croppedFile == null) return null;
    return File(croppedFile.path);
  }
// ---------------------------------------
// In-App Reviews Helper
// ---------------------------------------

/// Requests an in-app review if available.
Future<void> requestInAppReview() async {
  final InAppReview inAppReview = InAppReview.instance;
  if (await inAppReview.isAvailable()) {
    await inAppReview.requestReview();
  }
}

Future<void> checkAndRequestPhotosPermissions() async {
  var status = await Permission.photos.status;
  if (status.isDenied) {
    await Permission.photos.request();
  }
}

