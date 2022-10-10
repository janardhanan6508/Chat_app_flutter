import 'package:chat_app_flutter/screens/chart_screen.dart';
import 'package:chat_app_flutter/screens/login_screen.dart';
import 'package:chat_app_flutter/screens/registration_screen.dart';
import 'package:chat_app_flutter/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ChatApp());
}

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black54),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (contexr) => RegistrationScreen(),
        ChatScreen.id: (contexr) => ChatScreen(),
      },
    );
  }
}
