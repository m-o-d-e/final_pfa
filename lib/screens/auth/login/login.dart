import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rive_animation/animations/fade_animation.dart';
import 'package:rive_animation/constants.dart';
import 'package:rive_animation/screens/auth/register/signup.dart';
import '../../../blocs/auth_bloc.dart';
import '../../../widgets/button_widget.dart';
import '../../addButtion/add_p_a_g_e_widget.dart';
import '../../home_page/home_page_widget.dart';
import '../forgot_password/forgot_password.dart';
import 'bloc/login_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool checkedValue = false;
  String _email = '';
  String _password = '';

  bool _isLoading = false;

  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;

    return BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
      return BlocProvider(
          create: (context) => LoginBloc(),
          child:
              BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
            if (state is LoginErrorState) {
              buildSnackError(
                  state.message, context, MediaQuery.of(context).size);
              setState(() {
                _isLoading = false;
              });
            }

            if (state is LoginSuccessState) {
              context.read<AuthBloc>().add(
                    AuthAuthenticateEvent(state.user),
                  );
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddPAGEWidget(),
                ),
              );
            }
            if (state is LoginLoadingState) {
              setState(() {
                _isLoading = true;
              });
            }
          }, builder: (context, state) {
            return WillPopScope(
              onWillPop: () => popScreen(state),
              child: Scaffold(
                body: SingleChildScrollView(
                  child: Center(
                    child: Container(
                      height: size.height,
                      width: size.height,
                      decoration: BoxDecoration(
                        color:
                            isDarkMode ? const Color(0xff151f2c) : Colors.white,
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
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          left: size.width * 0.05,
                                          top: size.height * 0.02),
                                      child: Align(
                                        alignment: Alignment.topLeft,
                                        child: GestureDetector(
                                          onTap: () => Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const Signup(),
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.arrow_back_ios_new_sharp,
                                            size: 20,
                                            color: isDarkMode
                                                ? Colors.white
                                                : const Color(0xff1D1617),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: size.height * 0.02),
                                      child: Align(
                                        child: Text(
                                          'Heureux de vous revoir,',
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
                                      padding: EdgeInsets.only(
                                          top: size.height * 0.015),
                                      child: Align(
                                          child: FadeAnimation(
                                        1.5,
                                        Text(
                                          'Connectez-vous',
                                          style: GoogleFonts.poppins(
                                            color: isDarkMode
                                                ? Colors.white
                                                : const Color(0xff1D1617),
                                            fontSize: size.height * 0.03,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      )),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(
                                          top: size.height * 0.01),
                                    ),
                                    Container(),
                                    Container(),
                                    SizedBox(
                                      height: size.height * 0.1,
                                    ),
                                    FadeAnimation(
                                      1.5,
                                      Column(
                                        children: [
                                          Form(
                                            child: buildTextField(
                                              "Email",
                                              Icons.email_outlined,
                                              false,
                                              size,
                                              (valuemail) {
                                                if (valuemail.length < 5) {
                                                  buildSnackError(
                                                    'l\'email doit contenir au moins 5 caractères',
                                                    context,
                                                    size,
                                                  );
                                                  return '';
                                                }
                                                if (!RegExp(
                                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                                                    .hasMatch(valuemail)) {
                                                  buildSnackError(
                                                    'adresse email invalide',
                                                    context,
                                                    size,
                                                  );
                                                  return '';
                                                }
                                                return null;
                                              },
                                              _emailKey,
                                              isDarkMode,
                                            ),
                                          ),
                                          Form(
                                            child: buildTextField(
                                              "Mot de passe",
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
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: size.width * 0.015,
                                        vertical: size.height * 0.025,
                                      ),
                                      child: InkWell(
                                          onTap: () {
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const ForgotPasswordPage()),
                                            );
                                          },
                                          child: FadeAnimation(
                                            1.6,
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushReplacement(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          const ForgotPasswordPage()),
                                                );
                                              },
                                              child: Text(
                                                "Mot de passe oublié",
                                                style: TextStyle(
                                                  color:
                                                      const Color(0xffADA4A5),
                                                  decoration:
                                                      TextDecoration.underline,
                                                  fontSize: size.height * 0.02,
                                                ),
                                              ),
                                            ),
                                          )),
                                    ),
                                    AnimatedPadding(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        padding: EdgeInsets.only(
                                            top: size.height * 0.085),
                                        child: (_isLoading ||
                                                state is LoginLoadingState)
                                            ? const SpinKitDoubleBounce(
                                                color: Color(0xFF4CAF50),
                                                size: 50.0,
                                              )
                                            : FadeAnimation(
                                                1.7,
                                                ButtonWidget(
                                                  text: 'Connexion',
                                                  backColor: const [
                                                    Color(0xFF4BC04B),
                                                    Color(0xFF4CAF50)
                                                  ],
                                                  textColor: const [
                                                    Colors.white,
                                                    Colors.white,
                                                  ],
                                                  onPressed: () async {
                                                    if (state
                                                        is! LoginLoadingState) {
                                                      submitForm(context);
                                                    }
                                                  },
                                                ),
                                              )),
                                    FadeAnimation(
                                      1.7,
                                      AnimatedPadding(
                                        duration:
                                            const Duration(milliseconds: 500),
                                        padding: EdgeInsets.only(
                                          top: size.height * 0.05,
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Eau',
                                              style: GoogleFonts.poppins(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : Colors.black,
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
                                    FadeAnimation(
                                      1.7,
                                      RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text:
                                                  "Vous n'avez pas de compte?",
                                              style: TextStyle(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : const Color(0xff1D1617),
                                                fontSize: size.height * 0.018,
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: InkWell(
                                                onTap: () => setState(() {
                                                  Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const Signup()),
                                                  );
                                                }),
                                                child: Text(
                                                  " Inscrivez-vous",
                                                  style: TextStyle(
                                                    foreground: Paint()
                                                      ..shader =
                                                          const LinearGradient(
                                                        colors: <Color>[
                                                          kPrimaryColor,
                                                          Color(0xFF4CAF50),
                                                        ],
                                                      ).createShader(
                                                        const Rect.fromLTWH(0.0,
                                                            0.0, 200.0, 70.0),
                                                      ),
                                                    // color: const Color(0xffC58BF2),
                                                    fontSize:
                                                        size.height * 0.018,
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
          }));
    });
  }

  bool pwVisible = false;

  Widget buildTextField(
    String hintText,
    IconData icon,
    bool password,
    size,
    FormFieldValidator validator,
    Key key,
    bool isDarkMode,
  ) {
    return Padding(
      padding: EdgeInsets.only(
        top: size.height * 0.025,
      ),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.08,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.black : Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(15)),
        ),
        child: Form(
          key: key,
          child: TextFormField(
            style: TextStyle(
                color: isDarkMode ? const Color(0xffADA4A5) : Colors.black),
            onChanged: (value) {
              setState(() {
                if (key == _emailKey) {
                  _email = value;
                } else if (key == _passwordKey) {
                  _password = value;
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
                    )
                  : null,
            ),
          ),
        ),
      ),
    );
  }

  ScaffoldFeatureController<SnackBar, SnackBarClosedReason> buildSnackError(
      String error, BuildContext context, Size size) {
    final theme = Theme.of(context);
    final isDarkMode = theme.brightness == Brightness.dark;

    final backgroundBrightness =
        ThemeData.estimateBrightnessForColor(theme.backgroundColor);
    final textColor =
        backgroundBrightness == Brightness.dark ? Colors.white : Colors.black;

    final snackBackgroundColor =
        isDarkMode ? Colors.red : theme.backgroundColor;

    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: snackBackgroundColor,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(
              error,
              style: TextStyle(color: textColor),
            ),
          ),
        ),
      ),
    );
  }

  void submitForm(BuildContext context) {
    if (_emailKey.currentState!.validate()) {
      if (_passwordKey.currentState!.validate()) {
        setState(() {
          _isLoading = true;
        });
        context.read<LoginBloc>().add(
              LoginRequestEvent(
                email: _email,
                password: _password,
              ),
            );
      }
    }
  }

  Future<bool> popScreen(state) async {
    return state is! LoginLoadingState;
  }

/**
  _handleLogin() async {
    if (_emailKey.currentState!.validate()) {
      if (_passwordKey.currentState!.validate()) {
        try {

          // Navigator.pushReplacementNamed(context, '/login');
          await AuthService.login(
            email: _email,
            password: _password,
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(seconds: 2),
              backgroundColor: Colors.black,
              content: SizedBox(
                height: MediaQuery.of(context).size.height * 0.02,
                child: const Center(
                  child: Text("Connexion réussie"),
                ),
              ),
            ),
          );
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePageWidget()));
        }
        on FormGeneralException catch (e) {
          buildSnackError(e.message, context, MediaQuery
              .of(context)
              .size);
        }
        on FormFieldsException catch (e) {
          buildSnackError(e.errors.toString(), context, MediaQuery
              .of(context)
              .size);
        }
        on Exception catch (e) {
          buildSnackError(e.toString(), context, MediaQuery
              .of(context)
              .size);
        }
        finally {
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }
**/
}
