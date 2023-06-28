import 'package:flutter/material.dart';
import '../utlis/framwork_utils.dart';

class CircleArrowButton extends StatelessWidget {
  final VoidCallback onPressed;

  CircleArrowButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: onPressed,
      fillColor:
          FlutterFlowTheme.of(context).primary, // Customize the button color
      shape: CircleBorder(),
      elevation: 0.0,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Icon(
          Icons.arrow_forward,
          color: Colors.white,
        ),
      ),
    );
  }
}
