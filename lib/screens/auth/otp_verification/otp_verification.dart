import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickalert/quickalert.dart';
import 'package:rive_animation/screens/auth/otp_verification/account_setup.dart';
import 'package:rive_animation/screens/auth/otp_verification/bloc/otp_verification_bloc.dart';
import 'package:rive_animation/screens/auth/phone_signin/phone_signin.dart';
import '../../../animations/fade_animation.dart';
import '../../../blocs/auth_bloc.dart';
import '../../../constants.dart';
import '../../../widgets/button_widget.dart';
import '../../home_page/home_page_widget.dart';

class OtpVerificationPage extends StatefulWidget {
  final String phoneNumber;
  final String countryCode;

  OtpVerificationPage({Key? key, required  this.phoneNumber, required this.countryCode}) : super(key: key){
    print('OtpVerificationPage');
  }
  @override
  _OtpVerificationPage createState() => _OtpVerificationPage();
}

class _OtpVerificationPage extends State<OtpVerificationPage> {
  String otp = '';
  int _counter = 60;
  Timer? _timer;
  final List<TextEditingController> _controllers = List.generate(4, (_) => TextEditingController());
  late final  List<String> _otpValues = List.generate(4, (_) => '');
  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _stopTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_counter > 0) {
        setState(() {
          _counter--;
        });
      } else {
        _stopTimer();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    var brightness = MediaQuery.of(context).platformBrightness;
    bool isDarkMode = brightness == Brightness.dark;
    return BlocBuilder<AuthBloc, AuthState>(
        builder: (context, authState) {
          return BlocProvider<OtpVerificationBloc>(
              create: (context) => OtpVerificationBloc(),
              child: BlocConsumer<OtpVerificationBloc, OtpVerificationState>(
                  listener: (context, state) {
                    if(state is OtpVerificationLoadingState) {
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.loading,
                        text: 'Vérification en cours...',
                        animType: QuickAlertAnimType.slideInUp,
                        title: 'Vérification',
                        barrierDismissible: false,
                      );
                    }
                    else if(state is OtpVerificationResendLoadingState){
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.loading,
                        text: 'Envoi du code en cours...',
                        animType: QuickAlertAnimType.slideInUp,
                        title: 'Envoi du code',
                        barrierDismissible: false,
                      );
                    }
                    else if(state is OtpVerificationErrorState) {
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
                    }
                    else if (state is OtpVerificationSuccessState) {
                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true).pop(); // dismiss the loading dialog
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
                      }
                    }
                    else if(state is OtpVerificationResendErrorState){
                        if (context.mounted) {
                          Navigator.of(context, rootNavigator: true)
                              .pop(); // dismiss the loading dialog
                      QuickAlert.show(
                        context: context,
                        type: QuickAlertType.error,
                        text: state.message,
                        animType: QuickAlertAnimType.slideInUp,
                        confirmBtnText: "Réessayer",
                        title: 'Erreur',
                        barrierDismissible: false,
                      );
                        }
                    }
                    else if(state is OtpVerificationResendSuccessState) {
                        if (context.mounted) {
                          Navigator.of(context, rootNavigator: true)
                              .pop(); // dismiss the loading dialog
                      QuickAlert.show(
                          context: context,
                          type: QuickAlertType.success,
                          text: 'Un nouveau code a été envoyé!',
                          animType: QuickAlertAnimType.slideInUp,
                          title: 'Succès',
                          confirmBtnText: 'OK',
                          );
                      }
                    }
                    else if(state is OtpVerificationContinueRegisterState) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AccountSetupPage(phoneNumber: widget.phoneNumber, countryCode: widget.countryCode)),
                      );
                      }
                  },
                  builder: (context, state) {
                    return WillPopScope(
                        onWillPop: () => popScreen(context, state),
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
                                                  left: size.width * 0.055,
                                                ),
                                                child: Align(
                                                  alignment: Alignment.centerLeft,
                                                  child: Text(
                                                    'Vérifier votre numéro',
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
                                          FadeAnimation(1.5,
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: size.width * 0.055),
                                              child: Align(
                                                child: Text(
                                                  "Nous avons envoyé un code de vérification à ${widget.countryCode}${widget.phoneNumber}, veuillez le saisir ci-dessous",
                                                  style: GoogleFonts.poppins(
                                                    color:
                                                    isDarkMode ? Colors.white54 : Colors.black54,
                                                    fontSize: size.height * 0.02,
                                                  ),
                                                ),
                                              ),
                                            ),),
                                          SizedBox(
                                            height: size.height * 0.05,
                                          ),
                                          FadeAnimation(1.5,
                                            Form(
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                children: List.generate(4, (index) {
                                                  return Container(
                                                    width: 70,
                                                    height: 70,
                                                    decoration: BoxDecoration(
                                                      color: isDarkMode ? Colors.black : const Color(0xffF7F8F8),
                                                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                                                      border: Border.all(
                                                        color: isDarkMode ? Colors.black : Colors.redAccent.withOpacity(0),
                                                      ),
                                                    ),
                                                    child: TextFormField(
                                                      controller: _controllers[index],
                                                      onChanged: (value) {
                                                        if (value.length == 1) {
                                                          if (index < 3) {
                                                            FocusScope.of(context).nextFocus();
                                                          } else {
                                                            // Perform action after last digit entered
                                                          }
                                                        }
                                                        setState(() {
                                                          _otpValues[index] = value;
                                                        });
                                                      },
                                                      keyboardType: TextInputType.number,
                                                      textAlign: TextAlign.center,
                                                      inputFormatters: [
                                                        LengthLimitingTextInputFormatter(1),
                                                        FilteringTextInputFormatter.digitsOnly
                                                      ],
                                                      style: TextStyle(
                                                          color: isDarkMode ? const Color(0xffADA4A5) : Colors.black),
                                                      textInputAction: index == 3 ? TextInputAction.done : TextInputAction.next,
                                                      decoration: const InputDecoration(
                                                        hintText: "0",
                                                        hintStyle: TextStyle(
                                                          color: Color(0xffADA4A5),
                                                        ),
                                                        border: InputBorder.none,
                                                        contentPadding: EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                                                      ),
                                                    ),
                                                  );
                                                }),
                                              ),
                                            ),),

                                          FadeAnimation(1.6,
                                            Padding(
                                              padding: EdgeInsets.only(top: size.height * 0.1),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                      children: [
                                                        Flexible(
                                                          child: Container(
                                                            margin: const EdgeInsets.symmetric(horizontal: 12.0),
                                                            child: ButtonWidget(
                                                              text: 'Continuer',
                                                              backColor: const [Color(0xFF4BC04B), Color(0xFF4CAF50)],
                                                              textColor: const [
                                                                Colors.white,
                                                                Colors.white,
                                                              ],
                                                              onPressed: () async {
                                                                submitOtp(context);
                                                              },
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
                                              padding: EdgeInsets.symmetric(vertical: size.height * 0.1, horizontal: size.width * 0.1),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Row(
                                                    children:  [
                                                      const Icon(Icons.timer),
                                                      Text('$_counter secondes restantes', style: const TextStyle(fontSize: 12),),
                                                    ],
                                                  ),
                                                  OutlinedButton(
                                                    onPressed: _counter > 0 ? null : () {
                                                      setState(() {
                                                        _counter = 60;
                                                      });
                                                      _startTimer();
                                                    },

                                                    child: GestureDetector(
                                                      onTap: () {
                                                        if (_counter > 0) return;
                                                        setState(() {
                                                          _counter = 60;
                                                        });
                                                        _startTimer();
                                                        resendOtp();
                                                      },
                                                      child: Text('Renvoyer le code', style: TextStyle(color:_counter == 0? kSecondaryColor : Colors.grey),),
                                                    ),

                                                  ),
                                                ],
                                              ),
                                            ),

                                          ),
                                          FadeAnimation(1.7,
                                            Padding(
                                              padding: EdgeInsets.only(top: size.height * 0.03),
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
                        )
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


  void submitOtp(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    for(int i = 0; i < _otpValues.length; i++) {
      if (_otpValues[i].isEmpty) {
        buildSnackError("Veuillez entrer le code de vérification", context, size);
        return;
      }
    }
    String otp = _otpValues.join();
    context.read<OtpVerificationBloc>().add(
        OtpVerificationRequestEvent(
            phoneNumber: widget.phoneNumber,
            countryCode: widget.countryCode,
            otp: otp
        )
    );
  }

  void resendOtp(){
    context.read<OtpVerificationBloc>().add(
        OtpResendEvent(
            phoneNumber: widget.phoneNumber,
            countryCode: widget.countryCode,
        )
    );
  }

  Future<bool> popScreen(BuildContext context, state) async {
    // disable back button on OTPVerificationPage
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Êtes-vous sûr d\'annuler la vérification?'),
        actions: [
          TextButton(
            child: const Text('Annuler'),
            onPressed: () => Navigator.pop(context, false),
          ),
          TextButton(
            child: const Text('Oui'),
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
}
