import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:rive_animation/animations/fade_animation.dart';
import 'package:rive_animation/screens/auth/forgot_password/bloc/forgot_password_bloc.dart';
import 'package:rive_animation/screens/auth/login/login.dart';
import '../../../blocs/auth_bloc.dart';
import '../../../widgets/button_widget.dart';

class NewPasswordPage extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;
  const NewPasswordPage({Key? key, required this.phoneNumber, required this.countryCode }) : super(key: key);

  @override
  _NewPasswordPage createState() => _NewPasswordPage();
}

class _NewPasswordPage extends State<NewPasswordPage> {
  bool checkedValue = false;
  String _password = '';
  String confirmPassword = '';
  final _passwordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    var brightness = MediaQuery
        .of(context)
        .platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return BlocProvider(
              create: (context) => ForgotPasswordBloc(),
              child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
                  listener: (context, state) {
                    if(state is ForgotPasswordChangeErrorState) {
                      print(state.message);
                      buildSnackError(state.message, context, MediaQuery.of(context).size);
                      setState(() {
                        _isLoading = false;
                      });
                    }

                    if (state is ForgotPasswordChangeSuccessState) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.success,
                        text: 'Mot de passe changé, redirection dans 3s!',
                        animType: QuickAlertAnimType.slideInUp,
                        title: 'Succès',
                        confirmBtnText: 'OK',
                      );
                      Future.delayed(const Duration(seconds: 3), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginPage(),
                          ),
                        );
                      });
                    }
                    if(state is ForgotPasswordLoadingState) {
                      setState(() {
                        _isLoading = true;
                      });
                    }

                  },
                  builder: (context, state) {
                    return WillPopScope(
                      onWillPop: () => popScreen(state),
                      child: Scaffold(
                        body: SingleChildScrollView(
                          child: Center(
                            child: Container(
                              height: size.height,
                              width: size.height,
                              decoration: BoxDecoration(
                                color: isDarkMode ? const Color(0xff151f2c) : Colors.white,
                              ),
                              child: SafeArea(
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            const SizedBox(height: 10),
                                            Padding(
                                              padding: EdgeInsets.only(top: size.height * 0.02),
                                              child: Align(
                                                child: Text(
                                                  'Changer le mot de passe',
                                                  style: GoogleFonts.poppins(
                                                    color: isDarkMode
                                                        ? Colors.white
                                                        : const Color(0xff1D1617),
                                                    fontSize: size.height * 0.02,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: size.height * 0.015,
                                              left: size.width * 0.05, right: size.width * 0.05),
                                              child: Align(
                                                  child: FadeAnimation(1.5,
                                                    Text(
                                                      'Veuillez saisir le nouveau mot de passe',
                                                      style: GoogleFonts.poppins(
                                                        color: isDarkMode
                                                            ? Colors.white
                                                            : const Color(0xff1D1617),
                                                        fontSize: size.height * 0.03,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),)
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(top: size.height * 0.01),
                                            ),
                                            Container(),
                                            Container(),
                                            SizedBox(
                                              height: size.height * 0.1,
                                            ),
                                            FadeAnimation(1.5,
                                              Column(
                                                children: [
                                                  Form(
                                                    child: buildTextField(
                                                      "Nouveau mot de passe",
                                                      Icons.lock_outline,
                                                      true,
                                                      size,
                                                          (valuepassword) {
                                                        if (valuepassword.length < 6) {
                                                          buildSnackError(
                                                            'le mot de passe doit contenir au moins 6 caractères',
                                                            context,
                                                            size,
                                                          );
                                                          return '';
                                                        }
                                                        return null;
                                                      },
                                                      _passwordKey,
                                                      isDarkMode,
                                                    ),
                                                  ),
                                                  Form(
                                                    child: buildTextField(
                                                      "Confirmer le mot de passe",
                                                      Icons.lock_outline,
                                                      true,
                                                      size,
                                                          (valueConfirmPassword) {
                                                        if (valueConfirmPassword !=
                                                            _password) {
                                                          buildSnackError(
                                                            'les mots de passe ne correspondent pas',
                                                            context,
                                                            size,
                                                          );
                                                          return '';
                                                        }
                                                        return null;
                                                      },
                                                      _confirmPasswordKey,
                                                      isDarkMode,
                                                    ),
                                                  ),
                                                ],
                                              ),),
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: size.width * 0.015,
                                                vertical: size.height * 0.025,
                                              ),
                                            ),
                                            AnimatedPadding(
                                                duration: const Duration(milliseconds: 500),
                                                padding: EdgeInsets.only(top: size.height * 0.085),
                                                child: (_isLoading || state is ForgotPasswordLoadingState)
                                                    ? const SpinKitDoubleBounce(
                                                  color: Color(0xFF4CAF50),
                                                  size: 50.0,
                                                ) : FadeAnimation(1.7,
                                                  ButtonWidget(
                                                    text : 'Confirmer',
                                                    backColor: const [Color(0xFF4BC04B), Color(0xFF4CAF50)],
                                                    textColor: const [
                                                      Colors.white,
                                                      Colors.white,
                                                    ],
                                                    onPressed: () async {
                                                      if(state is! ForgotPasswordLoadingState) {
                                                        submitForm(context);
                                                      }
                                                    },
                                                  ),
                                                )
                                            ),
                                            FadeAnimation(1.7,
                                              AnimatedPadding(
                                                duration: const Duration(milliseconds: 500),
                                                padding: EdgeInsets.only(
                                                  top: size.height * 0.05,
                                                ),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      'Eau',
                                                      style: GoogleFonts.poppins(
                                                        color: isDarkMode ? Colors.white : Colors
                                                            .black,
                                                        fontSize: size.height * 0.045,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Wise',
                                                      style: GoogleFonts.poppins(
                                                        color: const Color(0xFF4CAF50),
                                                        fontSize: size.height * 0.06,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
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
                          ),
                        ),
                      ),
                    );
                  }
              )
          );
        }
    );
  }


  bool pwVisible = false;

  Widget buildTextField(String hintText,
      IconData icon,
      bool password,
      size,
      FormFieldValidator validator,
      Key key,
      bool isDarkMode,) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.025),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.08,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : const Color(0xffF7F8F8),
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Form(
          key: key,
          child: TextFormField(
            style: TextStyle(
                color: isDarkMode ? const Color(0xffADA4A5) : Colors.black),
            onChanged: (value) {
              setState(() {
                if (key == _passwordKey) {
                  _password = value;
                } else if (key == _confirmPasswordKey) {
                  confirmPassword = value;
                }
              });
            },
            validator: validator,
            textInputAction: TextInputAction.next,
            obscureText: password ? !pwVisible : false,
            decoration: InputDecoration(
              errorStyle: const TextStyle(height: 0),
              hintStyle: const TextStyle(
                color: Color(0xffADA4A5),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(
                top: size.height * 0.025,
              ),
              hintText: hintText,
              prefixIcon: Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.005,
                ),
                child: Icon(
                  icon,
                  color: const Color(0xff7B6F72),
                ),
              ),
              suffixIcon: password
                  ? Padding(
                padding: EdgeInsets.only(
                  top: size.height * 0.005,
                ),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      pwVisible = !pwVisible;
                    });
                  },
                  child: pwVisible
                      ? const Icon(
                    Icons.visibility_off_outlined,
                    color: Color(0xff7B6F72),
                  )
                      : const Icon(
                    Icons.visibility_outlined,
                    color: Color(0xff7B6F72),
                  ),
                ),
              ) : null,
            ),
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackError(
      String error, context, size) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(error),
          ),
        ),
      ),
    );
  }


  void submitForm(BuildContext context) {
    if (_passwordKey.currentState!.validate()) {
      if (_confirmPasswordKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        context.read<ForgotPasswordBloc>().add(ForgotPasswordChangePasswordEvent(
          password: _password,
          phoneNumber: widget.phoneNumber,
          countryCode: widget.countryCode,
         ));
      }
    }
  }
  Future<bool> popScreen(state) async {
    return state is! ForgotPasswordLoadingState;
  }
}
