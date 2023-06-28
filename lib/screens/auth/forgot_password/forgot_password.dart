import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:quickalert/models/quickalert_animtype.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:rive_animation/blocs/auth_bloc.dart';
import 'package:rive_animation/screens/auth/forgot_password/verify_code.dart';
import '../../../animations/fade_animation.dart';
import '../phone_signin/phone_signin.dart';
import 'bloc/forgot_password_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({Key? key}) : super(key: key);

  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  String phoneNumber = '';
  final _phoneNumberKey = GlobalKey<FormState>();
  TextEditingController controller = TextEditingController();
  bool isValid = false;
  ButtonState stateTextWithIcon = ButtonState.idle;

  @override
  Widget build(BuildContext context) {
    final Size ds = MediaQuery.of(context).size;
    final bool isTablet = ds.shortestSide >= 600;
    controller.addListener(() {
      setState(() {
        String inputValue = controller.text
            .replaceAll(' ', ''); // Remove spaces from the input value
        isValid = inputValue.length ==
            10; // Update the validity based on the length of the input
      });
    });

    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        return BlocProvider<ForgotPasswordBloc>(
            create: (context) => ForgotPasswordBloc(),
        child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
          listener: (context, state) {
            if(state is ForgotPasswordSendCodeErrorState) {
              stateTextWithIcon = ButtonState.fail;
              if (context.mounted) {
                Navigator.of(context, rootNavigator: true)
                    .pop(); // dismiss the loading dialog
                QuickAlert.show(
                  context: context,
                  type: QuickAlertType.error,
                  text: state.message,
                  animType: QuickAlertAnimType.slideInUp,
                  title: 'Erreur',
                  confirmBtnText: 'OK',
                  barrierDismissible: false,
                );
              }
              Future.delayed(const Duration(seconds: 2), () {
                setState(() {
                  stateTextWithIcon = ButtonState.idle;
                });
              });
            }
            else if(state is ForgotPasswordLoadingState) {
              stateTextWithIcon = ButtonState.loading;
            }
            else if (state is ForgotPasswordSendCodeSuccessState) {
              stateTextWithIcon = ButtonState.success;
              Future.delayed(const Duration(seconds: 2), () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ForgotPasswordVerifyCodePage(phoneNumber: phoneNumber, countryCode: "+212")),
                );
              });
            }
            else {
              stateTextWithIcon = ButtonState.idle;
            }
          },
          builder : (context, state) {
            return WillPopScope(
              onWillPop: () => popScreen(state),
              child: Scaffold(
                body: Center(
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
                                  padding: EdgeInsets.only(left: isTablet? 0 : size.width * 0.05 , top: size.height * 0.02),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: GestureDetector(
                                      onTap: () => Navigator.pop(context),
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
                                FadeAnimation(1.5,
                                    Padding(
                                      padding: EdgeInsets.only(
                                        top: size.height * 0.1,
                                        left: 25,
                                        right: 25,
                                      ),
                                      child: Column(
                                        children: [
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              'Mot de passe oublié',
                                              style: GoogleFonts.poppins(
                                                color: isDarkMode
                                                    ? Colors.white
                                                    : const Color(0xff1D1617),
                                                fontSize: size.height * 0.035,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                          FadeAnimation(1.5,
                                            Align(
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                "Veuillez entrer votre numéro de téléphone pour continuer la réinitialisation.",
                                                style: GoogleFonts.poppins(
                                                  color:
                                                  isDarkMode ? Colors.white54 : Colors.black54,
                                                  fontSize: size.height * 0.02,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ),

                                SizedBox(
                                  height: size.height * 0.2,
                                ),
                                FadeAnimation(1.5,
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: Form(
                                      key: _phoneNumberKey,
                                      child: TextFormField(
                                        style: TextStyle(
                                            color: isDarkMode ? const Color(0xffADA4A5) : Colors.black),
                                        onChanged: (value) {
                                          setState(() {
                                            phoneNumber = value;
                                          });
                                        },
                                        validator: (value) {
                                          if (value!.isEmpty) {
                                            buildSnackError(
                                              'Le numéro de téléphone est nécessaire',
                                              context,
                                              size,
                                            );
                                            return 'Le numéro de téléphone est nécessaire';
                                          }
                                          else if (value.replaceAll(' ', '').length < 10) {
                                            buildSnackError(
                                              'Le numéro de téléphone doit contenir 10 chiffres',
                                              context,
                                              size,
                                            );
                                            return 'Le numéro de téléphone doit contenir 10 chiffres';
                                          }
                                          return null;
                                        },
                                        keyboardType: TextInputType.number,
                                        controller: controller,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.digitsOnly,
                                          LengthLimitingTextInputFormatter(10),
                                          PhoneNumberInputFormatter(),
                                        ],
                                        decoration: InputDecoration(
                                          errorStyle: const TextStyle(height: 0),
                                          hintStyle: const TextStyle(
                                            color: Color(0xffADA4A5),
                                          ),
                                          border: const OutlineInputBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(8)),
                                              borderSide: BorderSide(
                                                color: Colors.red,
                                              )
                                          ),
                                          enabledBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular((8))),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),
                                          focusedBorder: const OutlineInputBorder(
                                            borderRadius: BorderRadius.all(Radius.circular((8))),
                                            borderSide: BorderSide(
                                              color: Colors.grey,
                                            ),
                                          ),

                                          contentPadding: EdgeInsets.only(
                                            top: size.height * 0.02,
                                          ),
                                          hintText: 'Numéro de téléphone',
                                          prefixIcon: Padding(
                                            padding: EdgeInsets.only(
                                              top: size.height * 0.005,
                                            ),
                                            child: const Icon(
                                              Icons.phone_android_outlined,
                                              color: Color(0xff7B6F72),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),),

                                FadeAnimation(1.6,
                                  Padding(
                                    padding: EdgeInsets.only(top: size.height * 0.05),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            Flexible(
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                                child: SizedBox(
                                                  width: double.infinity,
                                                  child: ProgressButton.icon(
                                                    iconedButtons: {
                                                      ButtonState.idle: const IconedButton(
                                                        text: "Continuer",
                                                        icon: Icon(
                                                            Icons.keyboard_double_arrow_right_outlined,
                                                            color: Colors.white),
                                                        color: Color(0xFF4CAF50),
                                                      ),
                                                      ButtonState.loading: const IconedButton(
                                                        text: "Inscription en cours",
                                                        color: Color(0xFF4CAF50),
                                                      ),
                                                      ButtonState.fail: IconedButton(
                                                        text: "Echec",
                                                        icon: const Icon(Icons.cancel,
                                                            color: Colors.white),
                                                        color: Colors.red.shade300,
                                                      ),
                                                      ButtonState.success: IconedButton(
                                                        text: "Code envoyé",
                                                        icon: const Icon(
                                                          Icons.check_circle,
                                                          color: Colors.white,
                                                        ),
                                                        color: Colors.green.shade400,
                                                      ),
                                                    },
                                                    onPressed: () async {
                                                      _phoneNumberKey.currentState!.validate()? submitForm(context): null;
                                                    },
                                                    state: stateTextWithIcon,
                                                    minWidth: size.width * 0.8,
                                                    maxWidth: size.width * 0.8,
                                                    radius: 10.0,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                FadeAnimation(1.7,
                                  Padding(
                                    padding: EdgeInsets.only(top: size.height * 0.08),
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
                                  ),),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
        )
        );
        },
        );
  }

  bool pwVisible = false;
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

  Future<bool> popScreen(state) async {
    return state is! ForgotPasswordLoadingState;
  }

  void submitForm(BuildContext context) {
    setState(() {
      stateTextWithIcon = ButtonState.loading;
    });
    phoneNumber = phoneNumber.replaceAll(" ", "");
    phoneNumber = phoneNumber.replaceFirst(RegExp(r'^\+'), '')
        .replaceFirst(RegExp(r'^212'), '')
        .replaceFirst(RegExp(r'^0+'), '');

    context.read<ForgotPasswordBloc>().add(
      ForgotPasswordSendCodeEvent(
          phoneNumber: phoneNumber,
          countryCode: "+212"
      ),
    );
  }
}