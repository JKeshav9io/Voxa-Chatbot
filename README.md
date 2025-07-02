# 🧠 Voxa – AI-Powered Emotional Chat Assistant

![Flutter](https://img.shields.io/badge/Flutter-3.8-blue?logo=flutter)
![Platform](https://img.shields.io/badge/platform-Android%20%7C%20iOS%20%7C%20Web-blue)

**Voxa** is a beautifully designed, emotionally intelligent AI chatbot built with **Flutter**. It delivers sentiment-aware responses, audio playback, and session-based chat history in a modern, responsive UI — perfect for mobile, tablet, and web.

---

## 🚀 Features

- 💬 **Emotion-Aware Chatbot** – Understands emotional tone & confidence
- 🔊 **Audio Playback** – Text-to-speech for bot replies
- 🕓 **Chat History** – Saved session logs
- 🌗 **Light & Dark Modes** – Adaptive UI based on system
- 📱 **Responsive Design** – Optimized for all screen sizes

---

## 🛠️ Tech Stack

| Layer         | Technology                                      |
|---------------|--------------------------------------------------|
| 💻 Frontend   | Flutter (Dart)                                  |
| ☁️ Cloud      | Firebase (Auth, Firestore)                      |
| 🎧 Audio      | audioplayers plugin                             |
| 🎨 Theming    | Custom Light and Dark themes                    |
| 📦 Packages   | `http`, `uuid`, `fluttertoast`, `google_fonts` |

---

## 📦 Installation

### 🔧 Prerequisites

- Flutter SDK ≥ 3.8

### ⚙️ Setup & Run

```bash
# Clone the repository
git clone https://github.com/yourusername/voxa.git
cd voxa

# Install dependencies
flutter pub get

# Run the app
flutter run
````

---

## ⚙️ Usage

1. **Login or Sign Up** (Firebase Auth)
2. Tap **New Chat** to begin a conversation
3. Emotion, confidence & audio playback enrich bot replies
4. Access **Chat History** from the drawer
5. Logout with a single tap

---

## 🧪 Testing

Currently manually tested on:

* ✅ Android Emulator
* ✅ Android Real Devices
* ✅ Web (Chrome)

Includes testing for:

* Theme responsiveness
* Firebase Auth & Firestore connection
* Audio playback from external URLs

---

## 🗂️ Project Structure

```
lib/
├── main.dart
├── themes/
│   ├── app_theme.dart
│   ├── light_theme.dart
│   └── dark_theme.dart
├── screens/
│   ├── login_screen.dart
│   ├── chat_screen.dart
│   ├── history_screen.dart
├── widgets/
│   ├── chat_input_field.dart
│   ├── message_bubble.dart
│   └── app_drawer.dart
```

---

## 🛡️ Error Handling

* ⚠️ Graceful `SnackBar` messages on API/audio failure
* 🔁 Audio retry supported
* 🔐 FirebaseAuth error messages mapped to user-friendly output

---

## 🎨 UI & UX

* 🎯 Dynamic scaling via `MediaQuery`
* 🌈 Light & Dark Material 3 themes
* ✨ Smooth animations:

  * Chat bubble fade-in
  * Send button press feedback
* 🧼 Clean UI using `Roboto` + `RobotoSlab`

---

## 🔗 Links

* 🔥 [Flutter](https://flutter.dev/)
* 📚 [Firebase Docs](https://firebase.google.com/)
* 🌐 [Backend Repo](https://github.com/yourusername/voxa-backend) *(Flask API)*
* 🎥 Demo: [Demo Video YouTube](https://youtu.be/-KRv7ohp9BU)

---

> 🧠 Voxa – Where AI meets emotional intelligence.

```

---
