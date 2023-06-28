import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:rive_animation/screens/auth/phone_signin/bloc/phone_signin_bloc.dart';
import 'package:rive_animation/screens/auth/otp_verification/otp_verification.dart';
import 'package:rive_animation/screens/auth/register/signup.dart';
import '../../../animations/fade_animation.dart';
import '../../../blocs/auth_bloc.dart';

class PhoneSigninPage extends StatefulWidget {
  const PhoneSigninPage({Key? key}) : super(key: key);

  @override
  _PhoneSigninPage createState() => _PhoneSigninPage();
}

class _PhoneSigninPage extends State<PhoneSigninPage> {
  TextEditingController controller = TextEditingController();
  bool isValid = false;
  ButtonState stateTextWithIcon = ButtonState.idle;
  final _phoneNumberKey = GlobalKey<FormState>();
  //TODO: add Country Code Picker
  String phoneNumber = '';


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    controller.addListener(() {
      setState(() {
        String inputValue = controller.text
            .replaceAll(' ', ''); // Remove spaces from the input value
        isValid = inputValue.length ==
            10; // Update the validity based on the length of the input
      });
    });

    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return BlocProvider<PhoneSigninBloc>(
              create: (context) => PhoneSigninBloc(),
              child: BlocConsumer<PhoneSigninBloc, PhoneSigninState>(
                  listener: (context, state) {
                    if(state is PhoneSigninErrorState) {
                      stateTextWithIcon = ButtonState.fail;
                      buildSnackError(state.message, context, MediaQuery.of(context).size);
                      Future.delayed(const Duration(seconds: 2), () {
                        setState(() {
                          stateTextWithIcon = ButtonState.idle;
                        });
                      });
                    }
                    else if(state is PhoneSigninLoadingState) {
                      stateTextWithIcon = ButtonState.loading;
                    }
                    else if (state is PhoneSigninSuccessState) {
                      stateTextWithIcon = ButtonState.success;
                      Future.delayed(const Duration(seconds: 2), () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => OtpVerificationPage(phoneNumber: phoneNumber, countryCode: "+212")),
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
                                  FadeAnimation(1.5,
                                      Padding(
                                        padding: EdgeInsets.only(
                                          top: size.height * 0.1,
                                          left: 25,
                                          right: 25,
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Se connecter',
                                            style: GoogleFonts.poppins(
                                              color: isDarkMode
                                                  ? Colors.white
                                                  : const Color(0xff1D1617),
                                              fontSize: size.height * 0.035,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      )),
                                  FadeAnimation(1.5, Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 25.0),
                                    child: Align(
                                      child: Text(
                                        "Veuillez entrer votre numéro de téléphone, nous vous enverrons un code de vérification par SMS.",
                                        style: GoogleFonts.poppins(
                                          color:
                                          isDarkMode ? Colors.white54 : Colors.black54,
                                          fontSize: size.height * 0.02,
                                        ),
                                      ),
                                    ),
                                  ),),
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
                                  Padding(
                                    padding: const EdgeInsets.only(top: 30.0),
                                    child: FadeAnimation(1.7,
                                      RichText(
                                        textAlign: TextAlign.left,
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: "Vous voulez continuer par email?",
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
                                                    setState(() {
                                                      Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                            const Signup()),
                                                      );
                                                    }),
                                                child: Text(
                                                  " Cliquer ici",
                                                  style: TextStyle(
                                                    color: const Color(0xFF4CAF50),
                                                    fontSize: size.height * 0.018,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
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
        }
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
/*
  _sendOtp() async {
    if (_phoneNumberKey.currentState!.validate() && stateTextWithIcon !=
        ButtonState.loading) {
      setState(() {
        stateTextWithIcon = ButtonState.loading;
      });
      phoneNumber = phoneNumber.replaceAll(" ", "");
      try {
        await AuthService.sendLoginVerificationCode(phoneNumber, "+212");
        setState(() {
          stateTextWithIcon = ButtonState.success;
        });
        if (context.mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpVerificationPage(
                phoneNumber: phoneNumber,
                countryCode: "+212",
              ),
            ),
          );
        }
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
            .size);
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
            .size);
      }
    }
  }
*/

  void submitForm(BuildContext context) {
                setState(() {
                  stateTextWithIcon = ButtonState.loading;
                });
                phoneNumber = phoneNumber.replaceAll(" ", "");
                phoneNumber = phoneNumber.replaceFirst(RegExp(r'^\+'), '')
                    .replaceFirst(RegExp(r'^212'), '')
                    .replaceFirst(RegExp(r'^0+'), '');

                context.read<PhoneSigninBloc>().add(
                  PhoneSigninRequestEvent(
                      phoneNumber: phoneNumber, //4 is the confirmPassword's Field
                      countryCode: "+212"
                  ),
                );
  }


  Future<bool> popScreen(state) async {
    return state is! PhoneSigninLoadingState;
  }

}

 class PhoneNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String inputData = newValue.text;
    StringBuffer buffer = StringBuffer();

    for (var i = 0; i < inputData.length; i++) {
      buffer.write(inputData[i]);
      int index = i + 1;

      if (index % 2 == 0 && inputData.length != index) {
        buffer.write(' ');
      }
    }
    return TextEditingValue(
        text: buffer.toString(),
        selection: TextSelection.collapsed(offset: buffer.toString().length));
  }

}










