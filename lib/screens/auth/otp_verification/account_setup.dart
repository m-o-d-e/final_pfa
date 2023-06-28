import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:rive_animation/screens/auth/otp_verification/bloc/otp_verification_bloc.dart';
import '../../../animations/fade_animation.dart';
import '../../../blocs/auth_bloc.dart';
import '../../home_page/home_page_widget.dart';
import '../phone_signin/phone_signin.dart';



class AccountSetupPage extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;

  const AccountSetupPage({Key? key, required this.phoneNumber, required this.countryCode}) : super(key: key);

  @override
  State<AccountSetupPage> createState() => _AccountSetupPageState();
}

class _AccountSetupPageState extends State<AccountSetupPage> {
  List textFieldsInput = [
    "", // First Name
    "", // Last Name
    "", // Email
  ];

  final _firstnamekey = GlobalKey<FormState>();
  final _lastNamekey = GlobalKey<FormState>();
  final _emailkey = GlobalKey<FormState>();

  ButtonState stateTextWithIcon = ButtonState.idle;



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
          return BlocProvider<OtpVerificationBloc>(
              create: (context) => OtpVerificationBloc(),
              child: BlocConsumer<OtpVerificationBloc, OtpVerificationState>(
                  listener: (context, state) {
                    if(state is OtpVerificationAccountCreationLoadingState) {
                      stateTextWithIcon = ButtonState.loading;
                    }
                    else if(state is OtpVerificationAccountCreationErrorState) {
                      stateTextWithIcon = ButtonState.fail;
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          stateTextWithIcon = ButtonState.idle;
                        });
                      });
                      buildSnackError(state.message, context, size, false);
                    }
                    else if (state is OtpVerificationAccountCreationSuccessState) {
                      stateTextWithIcon = ButtonState.success;
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          stateTextWithIcon = ButtonState.idle;
                        });
                      });
                      context.read<AuthBloc>().add(
                        AuthAuthenticateEvent(state.user),
                      );
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const HomePageWidget(),
                        ),
                            (route) => false,
                      );
                    //  buildSnackError("Account registered successfully", context, size, false);
                    }
                    else {
                      stateTextWithIcon = ButtonState.idle;
                    }
                  },
                  builder: (context, state) {
                    return WillPopScope(
                      onWillPop: () => popScreen(context, state),
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
                                          SizedBox(height : size.height * 0.1),
                                          Padding(
                                            padding: EdgeInsets.only(top: size.height * 0.02),
                                            child: Align(
                                              child: Text(
                                                'Terminer votre inscription,',
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
                                            padding: EdgeInsets.only(top: size.height * 0.015,
                                            left: size.width * 0.06, right: size.width * 0.06),
                                            child: Align(
                                                child:
                                                Text(
                                                  'Complétez votre inscription en ajoutant vos informations personnelles',
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
                                            1.5, Padding(
                                              padding: EdgeInsets.symmetric(vertical: size.height * 0.08),
                                              child: Column(
                                              children: [
                                                buildTextField(
                                                  "Prénom",
                                                  Icons.person_outlined,
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
                                                    _emailkey,
                                                    2,
                                                    isDarkMode,
                                                  ),
                                                ),
                                              ],
                                          ),
                                            ),
                                          ),
                                          FadeAnimation(1.7,
                                            AnimatedPadding(
                                              duration: const Duration(milliseconds: 500),
                                              padding: EdgeInsets.only(top: size.height * 0.025),
                                              child: ProgressButton.icon(
                                                iconedButtons: {
                                                  ButtonState.idle:
                                                  const IconedButton(
                                                    text: "Terminer l'inscription",
                                                    icon: Icon(Icons.arrow_right_alt, color: Colors.white),
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
                                                    text: "Succès",
                                                    icon: const Icon(Icons.check_circle,color: Colors.white,),
                                                    color: Colors.green.shade400,
                                                  ),
                                                },
                                                onPressed:() async {
                                                  submitForm(context, size, isDarkMode);
                                                  },
                                                state: stateTextWithIcon,
                                                minWidth: size.width * 0.8,
                                                maxWidth: size.width * 0.8,
                                                radius: 10.0,
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
                    );
                  }
              )
          );
        }
    );
  }

  void submitForm(BuildContext context, Size size, bool isDarkMode) {
    //verifier que tous les champs sont remplis
    if (_firstnamekey.currentState!.validate() && _lastNamekey.currentState!.validate() && _emailkey.currentState!.validate()) {
      context.read<OtpVerificationBloc>().add(
          RegisterPhoneNumberEvent(
            phoneNumber: widget.phoneNumber,
            countryCode: widget.countryCode,
            firstName: textFieldsInput[0],
            lastName: textFieldsInput[1],
            email: textFieldsInput[2],
          )
      );
    }
    else{
      final materialBanner = MaterialBanner(
        /// need to set following properties for best effect of awesome_snackbar_content
        elevation: 0,
        backgroundColor: Colors.transparent,
        forceActionsBelow: true,
        content: AwesomeSnackbarContent(
          title: 'Oh Hey!!',
          message:
          'This is an example error message that will be shown in the body of materialBanner!',

          /// change contentType to ContentType.success, ContentType.warning or ContentType.help for variants
          contentType: ContentType.failure,
          // to configure for material banner
          inMaterialBanner: true,
        ),
        actions: const [SizedBox.shrink()],
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentMaterialBanner()
        ..showMaterialBanner(materialBanner);
    }
}

  Future<bool> popScreen(BuildContext context, state) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Êtes-vous sûr d\'annuler la création de votre compte?'),
        actions: [
          TextButton(
            child: const Text('Non, continuer'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Oui, Annuler'),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const PhoneSigninPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
    return false;
  }

  Widget buildTextField(String hintText,
      IconData icon,
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
                textFieldsInput[stringToEdit] = value;
              });
            },
            validator: validator,
            textInputAction: TextInputAction.next,
            obscureText: false,
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
}
