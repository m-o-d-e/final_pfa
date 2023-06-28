import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../main.dart';
import 'dart:math';
import '../auth/phone_signin/phone_signin.dart';

class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({Key? key}) : super(key: key);

  @override
  State<WalkthroughPage> createState() => _walkthroughPage();
}

class _walkthroughPage extends State<WalkthroughPage> {
  final PageController _controller = PageController(initialPage: 0);
  int pageIndex = 0;
  String titleText = "Programmez votre \nirrigation";
  String descriptionText = "Planifiez votre irrigationà l'avance pour\néconomiser de l'eau et améliorer votre rendement";

  double animatedPositionWaveImageLeft = 40;

  updatePage(int nextIndex) {
    setState(() {
      pageIndex = nextIndex;

      if (nextIndex == 0) {
        titleText = "Programmez votre \nirrigation";
        descriptionText = "Planifiez votre irrigation à l'avance pour\néconomiser de l'eau et améliorer votre rendement";
        animatedPositionWaveImageLeft = 40;
      } else if (nextIndex == 1) {
        titleText = "Restez informé";
        descriptionText = "Recevez des notifications pour irriguer vos cultures \nau bon moment et éviter les gaspillages";
        animatedPositionWaveImageLeft = -350;
      } else {
        titleText = "Economisez de l'eau";
        descriptionText = "Optimisez votre consommation d'eau en utilisant notre \nsolution d'irrigation intelligente et économe";
        animatedPositionWaveImageLeft = -750;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final Size ds = MediaQuery.of(context).size;
    final bool isTablet = ds.shortestSide >= 600;

    return Scaffold(
      backgroundColor: themeData.scaffoldBackgroundColor,
      body: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(
                top: isTablet ? 80 : 40,
                left: isTablet ? 40 : 20,
                right: isTablet ? 40 : 20,
              ),
              child: SizedBox(
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          MyApp.themeNotifier.value =
                          MyApp.themeNotifier.value == ThemeMode.light
                              ? ThemeMode.dark
                              : ThemeMode.light;
                        });
                      },
                      icon: Icon(
                        MyApp.themeNotifier.value == ThemeMode.light
                            ? CupertinoIcons.sun_max_fill
                            : CupertinoIcons.moon,
                        color: MyApp.themeNotifier.value == ThemeMode.light
                            ? Colors.amber[600]
                            : Colors.blue,
                      ),
                    ),
                    Text(
                      "Mode ${MyApp.themeNotifier.value == ThemeMode.light ? "Clair" : "Sombre"}",
                      style: themeData.textTheme.headline6!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Spacer(),
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 400),
                      child: pageIndex != 2
                          ? GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () {
                          setState(() {
                            _controller.animateToPage(
                              2,
                              duration: const Duration(milliseconds: 600),
                              curve: Curves.easeInOut,
                            );
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Text(
                            "Passer",
                            style: themeData.textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      )
                          : const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            left: animatedPositionWaveImageLeft,
            child: Image.asset(
              'assets/shapes/wh.png',
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(
            height: ds.height * 0.5,
            child: PageView.custom(
              onPageChanged: (nextIndex) {
                updatePage(nextIndex);
              },
              controller: _controller,
              childrenDelegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return AnimatedBuilder(
                    animation:
                    const AlwaysStoppedAnimation(0), // Not used in the animation
                    builder: (BuildContext context, Widget? child) {
                      final double offset = 10 *
                          sin(2 * pi * DateTime.now().millisecondsSinceEpoch / 1000);
                      return Transform.translate(
                        offset: Offset(0, offset),
                        child: child,
                      );
                    },
                    child: Image.asset(
                      'assets/images/v$index.png',
                      width: isTablet ? 60 : 40,
                      fit: BoxFit.contain,
                    ),
                  );
                },
                childCount: 3,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(
                bottom: isTablet ? ds.height * 0.1 : ds.height * 0.05,
              ),
              child: SizedBox(
                width: isTablet ? 120 : 80,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List<Widget>.generate(
                    3,
                        (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 600),
                      height: pageIndex == index ? 15 : 10,
                      width: pageIndex == index ? 25 : 10,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(13),
                        color: pageIndex == index
                            ? themeData.colorScheme.surface
                            : themeData.colorScheme.outline,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 600),
            bottom: pageIndex == 1 ? ds.height / (isTablet ? 1.6 : 1.4) : ds.height / (isTablet ? 6 : 7),
            child: SizedBox(
              width: ds.width,
              child: Padding(
                padding: EdgeInsets.only(left: ds.width * (isTablet ? 0.06 : 0.09)),
                child: Wrap(
                  direction: Axis.vertical,
                  spacing: 10,
                  children: [
                    Text(
                      titleText,
                      style: themeData.textTheme.headline5!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      descriptionText,
                      style: themeData.textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(
                right: isTablet ? ds.width * 0.08 : ds.width * 0.05,
                bottom: isTablet ? ds.height * 0.05 : ds.height * 0.03,
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 400),
                child: pageIndex == 2
                    ? FloatingActionButton(
                  backgroundColor: themeData.colorScheme.surface,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PhoneSigninPage(),
                      ),
                    );
                  },
                  child: const Icon(
                    CupertinoIcons.arrow_right,
                    color: Colors.white,
                  ),
                )
                    : const SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }

}