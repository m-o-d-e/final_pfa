import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:rive_animation/screens/auth/phone_signin/phone_signin.dart';
import 'package:rive_animation/widgets/about_popup.dart';
import '../../../animations/fade_animation.dart';
import '../../../blocs/auth_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../login/login.dart';
import 'bloc/register_bloc.dart';


class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  _SignupState createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool checkedValue = false;

  List textfieldsStrings = [
    "", //firstName
    "", //lastName
    "", //email
    "", //password
    "", //confirmPassword
    "", //phoneNumber
  ];

  final _firstnamekey = GlobalKey<FormState>();
  final _lastNamekey = GlobalKey<FormState>();
  final _phoneNumberkey = GlobalKey<FormState>();
  final _emailKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormState>();
  final _confirmPasswordKey = GlobalKey<FormState>();

  ButtonState stateTextWithIcon = ButtonState.idle;


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    final bool isTablet = size.shortestSide >= 600;
    var brightness = MediaQuery
        .of(context)
        .platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;




    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return BlocProvider<RegisterBloc>(
              create: (context) => RegisterBloc(),
              child: BlocConsumer<RegisterBloc, RegisterState>(
                  listener: (context, state) {
                    if(state is RegisterErrorState) {
                      stateTextWithIcon = ButtonState.fail;
                      buildSnackError(state.message, context, MediaQuery.of(context).size, false);
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          stateTextWithIcon = ButtonState.idle;
                        });
                      });
                    }
                    else if(state is RegisterLoadingState) {
                      stateTextWithIcon = ButtonState.loading;
                    }
                    else if (state is RegisterSuccessState) {
                      stateTextWithIcon = ButtonState.success;
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                        );
                      });
                    }
                    else {
                      stateTextWithIcon = ButtonState.idle;
                    }
                  },
                  builder: (context, state) {
                    return WillPopScope(
                      onWillPop: () => popScreen(state),
                      child:
                      Scaffold(
                        body: SingleChildScrollView(
                          child: Center(
                            child: Container(
                              height: size.height,
                              width: size.height,
                              decoration: BoxDecoration(
                                color: isDarkMode ? const Color(0xff151f2c) : Colors.white,
                              ),
                              child: SafeArea(
                                child: Stack(
                                  children: [
                                    SingleChildScrollView(
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(left:isTablet?0 :  size.width * 0.05, top: size.height * 0.02),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: GestureDetector(
                                                onTap: () => Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => const PhoneSigninPage()),
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
                                            padding: EdgeInsets.only(top: size.height * 0.02),
                                            child: Align(
                                              child: Text(
                                                'Bienvenue,',
                                                style: GoogleFonts.poppins(
                                                  color: isDarkMode
                                                      ? Colors.white
                                                      : const Color(0xff1D1617),
                                                  fontSize: size.height * 0.02,
                                                ),
                                              ),
                                            ),
                                          ),
                                          FadeAnimation(
                                            1.5, Padding(
                                            padding: EdgeInsets.only(top: size.height * 0.015),
                                            child: Align(
                                                child:
                                                Text(
                                                  'Créez votre compte',
                                                  style: GoogleFonts.poppins(
                                                    color: isDarkMode
                                                        ? Colors.white
                                                        : const Color(0xff1D1617),
                                                    fontSize: size.height * 0.025,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                            ),
                                          ),
                                          ),
                                          FadeAnimation(
                                            1.5, Column(
                                            children: [
                                              buildTextField(
                                                "Prénom",
                                                Icons.person_outlined,
                                                false,
                                                false,
                                                size,
                                                    (valuename) {
                                                  if (valuename.length <= 2) {
                                                    buildSnackError(
                                                        'Le prénom doit contenir au moins 3 caractères',
                                                        context,
                                                        size,
                                                        isDarkMode
                                                    );
                                                    return '';
                                                  }
                                                  return null;
                                                },
                                                _firstnamekey,
                                                0,
                                                isDarkMode,
                                              ),
                                              buildTextField(
                                                "Nom",
                                                Icons.person_outlined,
                                                false,
                                                false,
                                                size,
                                                    (valuesurname) {
                                                  if (valuesurname.length <= 2) {
                                                    buildSnackError(
                                                        'Le nom doit contenir au moins 3 caractères',
                                                        context,
                                                        size,
                                                        isDarkMode
                                                    );
                                                    return '';
                                                  }
                                                  return null;
                                                },
                                                _lastNamekey,
                                                1,
                                                isDarkMode,
                                              ),
                                              Form(
                                                child: buildTextField(
                                                  "Email",
                                                  Icons.email_outlined,
                                                  false,
                                                  false,
                                                  size,
                                                      (valuemail) {
                                                    if (valuemail.length < 5) {
                                                      buildSnackError(
                                                          'l\'email doit contenir au moins 6 caractères',
                                                          context,
                                                          size,
                                                          isDarkMode
                                                      );
                                                      return '';
                                                    }
                                                    if (!RegExp(
                                                        r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]+")
                                                        .hasMatch(valuemail)) {
                                                      buildSnackError(
                                                          'l\'email est invalide',
                                                          context,
                                                          size,
                                                          isDarkMode
                                                      );
                                                      return '';
                                                    }
                                                    return null;
                                                  },
                                                  _emailKey,
                                                  2,
                                                  isDarkMode,
                                                ),
                                              ),
                                              Form(
                                                child: buildTextField(
                                                  "Mot de passe",
                                                  Icons.lock_outline,
                                                  true,
                                                  false,
                                                  size,
                                                      (valuepassword) {
                                                    if (valuepassword.length < 6) {
                                                      buildSnackError(
                                                          'Mot de passe invalide, minimum 6 caractères',
                                                          context,
                                                          size,
                                                          isDarkMode
                                                      );
                                                      return '';
                                                    }
                                                    return null;
                                                  },
                                                  _passwordKey,
                                                  3,
                                                  isDarkMode,
                                                ),
                                              ),
                                              Form(
                                                  child: buildTextField(
                                                    "Confirmer le mot de passe",
                                                    Icons.lock_outline,
                                                    true,
                                                    true,
                                                    size,
                                                        (valuepassword) {
                                                      if (valuepassword != textfieldsStrings[3]) {
                                                        buildSnackError(
                                                            'Les mots de passe ne correspondent pas',
                                                            context,
                                                            size,
                                                            isDarkMode
                                                        );
                                                        return '';
                                                      }
                                                      return null;
                                                    },
                                                    _confirmPasswordKey,
                                                    4,
                                                    isDarkMode,
                                                  )
                                              ),
                                              Form(
                                                  child: buildTextField(
                                                    "Numéro de téléphone",
                                                    Icons.phone_iphone_outlined,
                                                    false,
                                                    false,
                                                    size,
                                                        (valuePhone) {
                                                          if (valuePhone.length < 10) {
                                                            buildSnackError(
                                                                'Numéro de téléphone invalide, minimum 10 caractères',
                                                                context,
                                                                size,
                                                                isDarkMode
                                                            );
                                                            return '';
                                                      }
                                                      return null;
                                                    },
                                                    _phoneNumberkey,
                                                    5,
                                                    isDarkMode,
                                                  )
                                              ),
                                            ],
                                          ),
                                          ),
                                          FadeAnimation(1.6,
                                              Padding(
                                                  padding: EdgeInsets.symmetric(
                                                    horizontal: size.width * 0.015,
                                                  ),
                                                  child:
                                                  CheckboxListTile(
                                                    title: RichText(
                                                      textAlign: TextAlign.left,
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                            "En vous inscrivant, vous acceptez nos ",
                                                            style: TextStyle(
                                                              color: const Color(0xffADA4A5),
                                                              fontSize: size.height * 0.015,
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            child: InkWell(
                                                              onTap: () {
                                                                showDialog(context: context,
                                                                    builder: (BuildContext context) =>
                                                                const AboutPopup());
                                                              },
                                                              child: Text(
                                                                "Conditions d\'utilisation",
                                                                style: TextStyle(
                                                                  color: const Color(0xffADA4A5),
                                                                  decoration:
                                                                  TextDecoration.underline,
                                                                  fontSize: size.height * 0.015,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: " et ",
                                                            style: TextStyle(
                                                              color: const Color(0xffADA4A5),
                                                              fontSize: size.height * 0.015,
                                                            ),
                                                          ),
                                                          WidgetSpan(
                                                            child: InkWell(
                                                              onTap: () {
                                                              },
                                                              child: Text(
                                                                "nos Politiques de confidentialité",
                                                                style: TextStyle(
                                                                  color: const Color(0xffADA4A5),
                                                                  decoration:
                                                                  TextDecoration.underline,
                                                                  fontSize: size.height * 0.015,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                    activeColor: const Color(0xff7B6F72),
                                                    value: checkedValue,
                                                    onChanged: (newValue) {
                                                      setState(() {
                                                        checkedValue = newValue!;
                                                      });
                                                    },
                                                    controlAffinity:
                                                    ListTileControlAffinity.leading,
                                                  )
                                              )),
                                          FadeAnimation(1.7,
                                            AnimatedPadding(
                                              duration: const Duration(milliseconds: 500),
                                              padding: EdgeInsets.only(top: size.height * 0.025),
                                              child: ProgressButton.icon(
                                                iconedButtons: {
                                                  ButtonState.idle:
                                                  const IconedButton(
                                                    text: "S'inscrire",
                                                    icon: Icon(Icons.lock, color: Colors.white),
                                                    color: Color(0xFF4CAF50),
                                                  ),

                                                  ButtonState.loading:
                                                  const IconedButton(
                                                    text: "Inscription en cours",
                                                    color: Color(0xFF4CAF50),
                                                  ),
                                                  ButtonState.fail:
                                                  IconedButton(
                                                    text: "Inscription échouée",
                                                    icon: const Icon(Icons.cancel,color: Colors.white),
                                                    color: Colors.red.shade300,
                                                  ),
                                                  ButtonState.success:
                                                  IconedButton(
                                                    text: "Compte créé",
                                                    icon: const Icon(Icons.check_circle,color: Colors.white,),
                                                    color: Colors.green.shade400,
                                                  ),
                                                },
                                                onPressed:() async {
                                                  submitForm(context);
                                                },
                                                state: stateTextWithIcon,
                                                minWidth: size.width * 0.8,
                                                maxWidth: size.width * 0.8,
                                                radius: 10.0,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: size.height * 0.02),
                                          FadeAnimation(1.8,
                                            RichText(
                                              textAlign: TextAlign.left,
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: "Vous avez déjà un compte? ",
                                                    style: TextStyle(
                                                      color: isDarkMode
                                                          ? Colors.white
                                                          : const Color(0xff1D1617),
                                                      fontSize: size.height * 0.018,
                                                    ),
                                                  ),
                                                  WidgetSpan(
                                                    child: InkWell(
                                                        onTap: () =>
                                                        //navigate to login page
                                                        Navigator.pushReplacement(
                                                          context,
                                                          MaterialPageRoute(
                                                            builder: (context) =>
                                                            const LoginPage(),
                                                          ),
                                                        ),
                                                        child:
                                                        Text(
                                                          "Se connecter",
                                                          style: TextStyle(
                                                            foreground: Paint()
                                                              ..shader = const LinearGradient(
                                                                colors: <Color>[
                                                                  Color(0xFF4CAF50),
                                                                  Color(0xFF4CAF50),
                                                                ],
                                                              ).createShader(
                                                                const Rect.fromLTWH(
                                                                  0.0,
                                                                  0.0,
                                                                  200.0,
                                                                  70.0,
                                                                ),
                                                              ),
                                                            fontSize: size.height * 0.018,
                                                          ),
                                                        )
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: size.height * 0.02),
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
                    );
                  }
              )
          );
        }
    );
  }
            
            
            


  bool pwVisible = false;
  bool confirmPwVisible = false;

  Widget buildTextField(String hintText,
      IconData icon,
      bool password,
      bool isConfirmPassword,
      size,
      FormFieldValidator validator,
      Key key,
      int stringToEdit,
      bool isDarkMode,) {
    return Padding(
      padding: EdgeInsets.only(top: size.height * 0.025),
      child: Container(
        width: size.width * 0.9,
        height: size.height * 0.07,
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
                textfieldsStrings[stringToEdit] = value;
              });
            },
            validator: validator,
            textInputAction: TextInputAction.next,
            obscureText: password ? (isConfirmPassword ? !confirmPwVisible : !pwVisible) : false,
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
                      if (isConfirmPassword) {
                        confirmPwVisible = !confirmPwVisible;
                      } else {
                        pwVisible = !pwVisible;
                      }
                    });
                  },
                  child: isConfirmPassword
                      ? confirmPwVisible
                      ? const Icon(
                    Icons.visibility_off_outlined,
                    color: Color(0xff7B6F72),
                  )
                      : const Icon(
                    Icons.visibility_outlined,
                    color: Color(0xff7B6F72),
                  )
                      : pwVisible
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
      String error, context, size, bool isDarkMode) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.black,
        content: SizedBox(
          height: size.height * 0.02,
          child: Center(
            child: Text(error, style: const TextStyle(color: Colors.white),),
          ),
        ),
      ),
    );
  }

  /*
  _handleRegister() async {
    if (_firstnamekey.currentState!.validate()) {
      if (_lastNamekey.currentState!.validate()) {
        if (_emailKey.currentState!.validate()) {
          if (_passwordKey.currentState!.validate()) {
            if (_confirmPasswordKey.currentState!
                .validate()) {
              if (checkedValue == false) {
                buildSnackError(
                    'Veuillez lire et accepter les conditions d\'utilisation',
                    context,
                    MediaQuery
                        .of(context)
                        .size,
                    false);
              } else {
                setState(() {
                  stateTextWithIcon = ButtonState.loading;
                });
                try {
                  //Todo: Change this when we have a country selector
                  String phoneNumber =  textfieldsStrings[4].replaceFirst(RegExp(r'^\+'), '') // supprime le +
                      .replaceFirst(RegExp(r'^212'), '') // supprime 212
                      .replaceFirst(RegExp(r'^0+'), ''); // supprime tous les zéros au début
                  await AuthService.register(
                    firstName: textfieldsStrings[0],
                    lastName: textfieldsStrings[1],
                    email: textfieldsStrings[2],
                    password: textfieldsStrings[3],
                    phoneNumber: phoneNumber,
                  );
                  setState(() {
                    stateTextWithIcon = ButtonState.success;
                  });
                  buildSnackError(
                      "Votre compte a été crée, veuillez se connecter", context,
                      MediaQuery
                          .of(context)
                          .size, false);
                  Navigator.pushReplacementNamed(context, '/login');
                } on FormGeneralException catch (e) {
                  setState(() {
                    stateTextWithIcon = ButtonState.fail;
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      stateTextWithIcon = ButtonState.idle;
                    });
                  });
                  buildSnackError(e.message, context, MediaQuery
                      .of(context)
                      .size, false);
                }
                on FormFieldsException catch (e) {
                  setState(() {
                    stateTextWithIcon = ButtonState.fail;
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      stateTextWithIcon = ButtonState.idle;
                    });
                  });
                  buildSnackError(e.errors.toString(), context, MediaQuery
                      .of(context)
                      .size, false);
                }
                on Exception catch (e) {
                  setState(() {
                    stateTextWithIcon = ButtonState.fail;
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      stateTextWithIcon = ButtonState.idle;
                    });
                  });
                  buildSnackError(e.toString(), context, MediaQuery
                      .of(context)
                      .size, false);
                }
              }
            }
          }
        }
      }
    }
  }
*/

  void submitForm(BuildContext context) {
    if (_firstnamekey.currentState!.validate()) {
      if (_lastNamekey.currentState!.validate()) {
        if (_emailKey.currentState!.validate()) {
          if (_passwordKey.currentState!.validate()) {
            if (_confirmPasswordKey.currentState!.validate()) {
              if (_phoneNumberkey.currentState!.validate()) {
                if (checkedValue == false) {
                  buildSnackError(
                      'Veuillez lire et accepter les conditions d\'utilisation',
                      context,
                      MediaQuery
                          .of(context)
                          .size,
                      false);
                } else {
                  setState(() {
                    stateTextWithIcon = ButtonState.loading;
                  });
                  String phoneNumber = textfieldsStrings[5].replaceFirst(
                      RegExp(r'^\+'), '') // supprime le +
                      .replaceFirst(RegExp(r'^212'), '') // supprime 212
                      .replaceFirst(
                      RegExp(r'^0+'), ''); // supprime tous les zéros au début
                  context.read<RegisterBloc>().add(
                    RegisterRequestEvent(
                        firstName: textfieldsStrings[0],
                        lastName: textfieldsStrings[1],
                        email: textfieldsStrings[2],
                        password: textfieldsStrings[3],
                        phoneNumber: phoneNumber,
                        //4 is the confirmPassword's Field
                        countryCode: "+212"
                    ),
                  );
                }
              }
            }
          }
        }
      }
    }
  }
  Future<bool> popScreen(state) async {
    return state is! RegisterLoadingState;
  }


}