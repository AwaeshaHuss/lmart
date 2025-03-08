# Microlearning Platform - Ebtik_tok App

## Overview
This project is a prototype mobile app for a **microlearning platform** that provides a TikTok-style interface for users to browse and engage with short, interactive learning videos, leveraging a vertically scrollable feed, smooth video playback, and interactive features like saving, and sharing videos.

The app is built using **Clean Architecture**, ensuring separation of concerns, testability, and scalability.

---

## App Description
The app is built to mimic the core functionality of TikTok but focuses on educational content. It includes the following key features:
1. **Home Feed**: A vertically scrollable feed displaying video content dynamically.
2. **Search Functionality**: A responsive search bar to filter videos based on keywords.
3. **Bottom Navigation Bar**: Easy navigation between Home and Profile pages.
4. **Profile Page**: A mock user profile with basic statistics and a list of saved videos.

---

## Features Implemented

### 1. **Home Feed**
- **Vertically Scrollable Feed**: Users can scroll through a dynamic list of short learning videos.
- **Video Playback**: Each video card includes play/pause functionality.
- **Video Details**: Displays the title and description of the content.
- **Interactive Icons**: Users can save and share videos directly from the feed.

### 2. **Search Functionality**
- **Responsive Search Bar**: Users can search for videos by typing keywords.
- **Dynamic Filtering**: Displays filtered results in real-time as the user types.

### 3. **Bottom Navigation Bar**
- **Navigation Buttons**: Includes buttons for Home, Search, Saved Videos, and Profile pages.
- **Active Page Highlighting**: Clearly indicates the currently active page.

### 4. **Profile Page**
- **User Profile**: Displays a mock user profile with an avatar, name, and basic statistics (e.g., total videos watched, badges earned).
- **Saved Videos**: Lists all saved videos with navigation to play them.

---

## Clean Architecture Overview
The app follows **Clean Architecture**, which separates the code into layers to ensure modularity, testability, and maintainability. The layers are:

1. **Presentation Layer**:
   - Contains UI components (widgets, screens) and state management (Bloc).
   - Handles user interactions and displays data.

2. **Domain Layer**:
   - Contains business logic and use cases.
   - Defines abstract repositories and entities.

3. **Data Layer**:
   - Implements repositories defined in the Domain Layer.
   - Handles data sources (e.g., APIs, local databases).
---

## Setup and Running the App Locally

### Prerequisites
- **Flutter SDK**: Ensure you have Flutter installed on your machine. If not, follow the official [Flutter installation guide](https://flutter.dev/docs/get-started/install).
- **IDE**: Use Android Studio, VS Code, or any other IDE that supports Flutter development.
- **Emulator/Device**: Set up an Android/iOS emulator or connect a physical device for testing.

### Steps to Run the App
1. **Clone the Repository**:
   ```bash
   git clone https://github.com/AwaeshaHuss/ebtik_tok
   cd ebtik_tok
2. **Run the Project**:
   ```bash
   flutter pub get
   flutter run

---

### Release APK:

- [https://drive.google.com/file/d/11aJ-z5O1xfq8Wq_uUxsku5Z5Xxln5vAM/view?usp=share_link](https://drive.google.com/file/d/11aJ-z5O1xfq8Wq_uUxsku5Z5Xxln5vAM/view?usp=share_link)


---

## Contact

For any questions or feedback, feel free to reach out:

- Email: h.awaesha97@gmail.com
- GitHub: AwaeshaHuss

---

### Note:

Mock User:

- phone: 0790707653
- password: H@2212a
