import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../utlis/framwork_utils.dart';

class AddsoilModel extends FlutterFlowModel {
  ///  State fields for stateful widgets in this page.

  final unfocusNode = FocusNode();
  // State field(s) for yourName widget.
  TextEditingController? yourNameController;
  String? Function(BuildContext, String?)? yourNameControllerValidator;
  // State field(s) for city widget.
  TextEditingController? cityController1;
  String? Function(BuildContext, String?)? cityController1Validator;
  // State field(s) for city widget.
  TextEditingController? cityController2;
  String? Function(BuildContext, String?)? cityController2Validator;
  // State field(s) for city widget.
  TextEditingController? cityController3;
  String? Function(BuildContext, String?)? cityController3Validator;
  // State field(s) for city widget.
  TextEditingController? cityController4;
  String? Function(BuildContext, String?)? cityController4Validator;

  /// Initialization and disposal methods.

  void initState(BuildContext context) {}

  void dispose() {
    unfocusNode.dispose();
    yourNameController?.dispose();
    cityController1?.dispose();
    cityController2?.dispose();
    cityController3?.dispose();
    cityController4?.dispose();
  }

  /// Action blocks are added here.

  /// Additional helper methods are added here.
}
