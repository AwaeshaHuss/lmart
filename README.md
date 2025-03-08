# Mini E-Commerce App

## Overview
This project is a **mini e-commerce app** that provides essential shopping functionalities, including user authentication, product listing, cart management, and payment integration. The app is built using **Flutter** and leverages **Firebase** for backend services.

---

## Features Implemented

### 1. **User Authentication**
- Firebase Authentication for user sign-in and sign-up.
- Supports **Google Sign-In** and **email/password authentication**.

### 2. **Product Listing**
- Fetches product data dynamically from **Firestore**.
- Displays product images using **cached_network_image**.

### 3. **Product Details**
- Dedicated product details page with complete information.
- Option to add products to the cart.

### 4. **Cart Functionality**
- Users can add, remove, and update product quantities in the cart.

### 5. **User Profile**
- Profile page to view and update user information.
- Uses **Firestore** to store and retrieve user data.

### 6. **Push Notifications**
- Implemented using **Firebase Messaging** to send real-time updates.

### 7. **Payment Integration**
- Integrated **Stripe** for handling secure payments.
- Users can checkout and pay for products in their cart.

---

## Bonus Features

### 1. **Product Search**
- Search functionality to find products easily.

### 2. **Localization**
- Supports multiple languages using the **intl** package.

### 3. **Maps Integration**
- **Google Maps** to display user location and nearby stores.

### 4. **Image Editing**
- Users can pick and crop profile pictures using **image_picker** and **image_cropper**.

### 5. **In-App Reviews**
- Allows users to submit feedback using **in_app_review**.

---

## Tech Stack
- **State Management**: `provider`
- **JSON Parsing**: `json_serializable` and `json_annotation`
- **Backend Services**: Firebase Authentication, Firestore, Firebase Messaging
- **Payment Processing**: Stripe
- **Image Handling**: cached_network_image, image_picker, image_cropper
- **Maps**: google_maps_flutter

---

## Setup and Running the App

### Prerequisites
- **Flutter SDK**: Install from [Flutter's official site](https://flutter.dev/docs/get-started/install).
- **IDE**: Use Android Studio, VS Code, or any Flutter-supported IDE.
- **Emulator/Device**: Configure an emulator or connect a physical device.

### Steps to Run the App
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/your-repo/mini-ecommerce-app.git
   cd mini-ecommerce-app
   ```
2. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
3. **Run the App**:
   ```bash
   flutter run
   ```

---

## Architecture & Design Decisions
- **Uses Clean Architecture principles** for better code maintainability.
- **Provider** is used for state management to separate concerns.
- **Firestore is chosen** for real-time updates and scalability.

---

## Deliverables
- Full source code hosted on **GitHub**.
- **README.md** with setup and project details.
- Proper code documentation and comments.

---

## Contact
For any questions or feedback, feel free to reach out:

- **Email**: your-email@example.com
- **GitHub**: [your-github-profile](https://github.com/your-github-profile)

