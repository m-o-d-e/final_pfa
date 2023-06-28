import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rive_animation/screens/addSoil/addsoil_widget.dart';
import 'package:rive_animation/screens/auth/register/signup.dart';
import 'package:rive_animation/screens/dashboard/dashboard.dart';
import 'package:rive_animation/screens/home_page/home_page_widget.dart';
import 'package:rive_animation/screens/splash_screen.dart';
import '../constants.dart';
import 'blocs/auth_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static final ValueNotifier<ThemeMode> themeNotifier =
      ValueNotifier(ThemeMode.system);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (BuildContext context, ThemeMode currentMode, Widget? child) {
          return BlocProvider(
            create: (context) => AuthBloc(),
            child: MaterialApp(
                debugShowCheckedModeBanner: false,
                title: 'EauWise',
                theme: lightThemeData,
                darkTheme: darkThemeData,
                themeMode: currentMode,
                home: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoadingState) {
                      return const SplashScreen();
                    } else {
                      return const HomePageWidget();
                    }
                  },
                ),
                routes: {
                  //'/on': (context) => OnboardingScreen(),
                  '/signup': (context) => const Signup(),
                  '/home': (context) => const HomePageWidget(),

                  '/dashboard': (context) => const Dashboard(
                        isDark: false,
                      ),
                  '/soil': (context) => const AddsoilWidget(),
                }),
          );
        });
  }
}
