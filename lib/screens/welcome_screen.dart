import 'package:chat_app_flutter/screens/login_screen.dart';
import 'package:chat_app_flutter/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_flutter/components/round_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: Duration(seconds: 1), vsync: this);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white)
        .animate(controller);
    // CurvedAnimation(parent: controller, curve: Curves.easeIn);
    controller.forward();
    // animation.addStatusListener((status) {
    //   if (status == AnimationStatus.completed) {
    //     controller.reverse(from: 1.0);
    //   } else if (status == AnimationStatus.dismissed) {
    //     controller.forward();
    //   }
    // });
    controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Hero(
                  tag: 'logo',
                  child: SizedBox(
                    height: 60.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
                AnimatedTextKit(
                  animatedTexts: [
                    TypewriterAnimatedText('Messager',
                        textStyle: TextStyle(
                            fontSize: 45.0,
                            fontWeight: FontWeight.w500,
                            color: Colors.orange),
                        speed: const Duration(milliseconds: 60)),
                  ],
                  repeatForever: true,
                )
              ],
            ),
            SizedBox(
              height: 40.0,
            ),
            RoundButton(
                title: 'LogIn',
                colour: Colors.lightBlueAccent,
                onPressed: () {
                  Navigator.pushNamed(context, LoginScreen.id);
                }),
            RoundButton(
                title: 'Register',
                colour: Colors.red,
                onPressed: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                }),
          ],
        ),
      ),
    );
  }
}
