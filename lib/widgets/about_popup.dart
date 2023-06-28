import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutPopup extends StatelessWidget {
  const AboutPopup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return AlertDialog(
      title:  Text('Conditions d\'utilisation',
        style: GoogleFonts.poppins(textStyle: TextStyle(color: textColor)),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildAboutText(textColor),
            _buildLogoAttribution(textColor),
          ],
        ),
      ),
      actions: <Widget>[
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('c\'est compris !'),
        ),
      ],
    );
  }

  Widget _buildAboutText(Color textColor) {
    return RichText(
      text: TextSpan(
        text: 'L\'utilisation de notre application est soumise à votre acceptation des conditions d\'utilisation suivantes : vous vous engagez à utiliser l\'application uniquement pour la gestion de l\'irrigation et à respecter les lois locales en vigueur. Vous êtes responsable de toutes les activités effectuées via l\'application. Tout usage abusif, frauduleux ou illégal de l\'application peut entraîner la résiliation de votre accès. Nous nous réservons le droit de mettre à jour ou de suspendre l\'application sans préavis. En utilisant l\'application, vous acceptez que vos données soient collectées et utilisées à des fins d\'amélioration des services. Veuillez lire attentivement les conditions d\'utilisation complètes avant d\'utiliser l\'application.\n\n',
        style: GoogleFonts.poppins(textStyle: TextStyle(color: textColor), fontSize: 13.0),
      ),
    );
  }

  Widget _buildLogoAttribution(Color textColor) {
    final secondTextColor = textColor.withOpacity(0.6);

    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: Text(
                'Cette application a été développée dans le cadre de notre projet PFA en collaboration avec la faculté des sciences. Merci de votre soutien et de votre intérêt pour notre projet !',
                style: GoogleFonts.poppins(
                  textStyle: TextStyle(fontSize: 12.0, color: secondTextColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}
