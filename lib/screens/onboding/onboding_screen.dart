import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:rive_animation/screens/onboding/walkthrough.dart';
import '../../animations/fade_animation.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({Key? key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  late RiveAnimationController _btnAnimationController;

  @override
  void initState() {
    _btnAnimationController = OneShotAnimation(
      "active",
      autoplay: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = MediaQuery.of(context).size.shortestSide >= 600;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const RiveAnimation.asset("assets/RiveAssets/shapes.riv"),
          Positioned(
            width: MediaQuery.of(context).size.width * 1.7,
            bottom: isTablet ? 400 : 200,
            left: isTablet ? 500 : 100,
            child: Stack(
              children: [
                Image.asset("assets/Backgrounds/Spline.png"),
                Positioned.fill(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 20, sigmaY: 10),
                    child: const SizedBox(),
                  ),
                ),
              ],
            ),
          ),
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: const SizedBox(),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: isTablet ? 64 : 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(),
                  SizedBox(
                    width: isTablet ? 600 : 400,
                    child: Column(
                      children: [
                        FadeAnimation(
                          1.4,
                          Text(
                            "Cultiver avec confiance",
                            style: TextStyle(
                              fontSize: isTablet ? 65 : 55,
                              fontFamily: "Poppins",
                              height: 1.2,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        FadeAnimation(
                          1.4,
                          Text(
                            "Optimisez votre production agricole grâce à notre système intelligent d'irrigation et prenez des décisions éclairées en toute confiance pour votre exploitation.",
                            style: TextStyle(
                              fontSize: isTablet ? 20 : 16,
                              height: 1.5,
                              color: Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 2),
                  InkWell(
                    onTap: () async {
                      _btnAnimationController.isActive = true;
                      await Future.delayed(const Duration(milliseconds: 900));
                      navigateToNextScreen(context);
                    },
                    child: SizedBox(
                      height: isTablet ? 80 : 64,
                      width: isTablet ? 320 : 260,
                      child: FadeAnimation(
                        2,
                        Stack(
                          children: [
                            FadeAnimation(
                              2,
                              RiveAnimation.asset(
                               Theme.of(context).brightness == Brightness.light
                                    ?  "assets/RiveAssets/button_dark.riv"
                                    :  "assets/RiveAssets/button.riv",
                                controllers: [_btnAnimationController],
                              ),
                            ),
                            Positioned.fill(
                              top: 8,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    CupertinoIcons.arrow_right,
                                    color: Theme.of(context).brightness == Brightness.light
                                        ? Colors.black
                                        : Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Commencer",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w800,
                                      fontSize: 17,
                                      color: Theme.of(context).brightness == Brightness.light
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),

                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: FadeAnimation(
                      2.3,
                      Text(
                        "⚠ Les informations fournies par cette application sont destinées à titre informatif uniquement. Elles ne doivent pas être utilisées pour prendre des décisions critiques sans consulter un expert en la matière",
                        style: TextStyle(
                          fontSize: isTablet ? 14 : 11,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }



  void navigateToNextScreen(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).animate(animation),
          child: const WalkthroughPage(),
        ),
      ),
    );
  }
}
