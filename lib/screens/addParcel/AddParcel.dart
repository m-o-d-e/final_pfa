import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../blocs/parcel_bloc.dart';
import '../../utlis/framwork_utils/flutter_flow_theme.dart';
import '../../widgets/CircleArrowButton.dart';

class AddParcel extends StatefulWidget {
  const AddParcel({Key? key}) : super(key: key);

  @override
  State<AddParcel> createState() => _AddParcelState();
}

class _AddParcelState extends State<AddParcel> {
  final formKey = GlobalKey<FormState>(); //key for form
  String name = "";
  TextEditingController parcelNameController = TextEditingController();
  TextEditingController areaController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Color(0xFFffffff),
        body: Container(
          padding: const EdgeInsets.only(left: 40, right: 40),
          child: Form(
            key: formKey, //key for form
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: height * 0.04),
                Text(
                  "Bienvenu !",
                  style: TextStyle(fontSize: 30, color: Colors.black87),
                ),
                SizedBox(
                  height: height * 0.06,
                ),
                TextFormField(
                  controller: parcelNameController,
                  cursorColor: FlutterFlowTheme.of(context).primary,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Entrer le nom du parcel",
                    labelStyle:
                        TextStyle(color: FlutterFlowTheme.of(context).primary),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context)
                              .primary), // Change border color when focused
                    ),
                  ),
                  // InputDecoration
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[a-zA-Z][a-zA-Z0-9]+$').hasMatch(value)) {
                      return "Entrer un nom correct";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: height * 0.06,
                ),
                TextFormField(
                  controller: areaController,
                  cursorColor: FlutterFlowTheme.of(context).primary,
                  decoration: InputDecoration(
                    filled: true,
                    labelText: "Surface",
                    labelStyle:
                        TextStyle(color: FlutterFlowTheme.of(context).primary),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                          color: FlutterFlowTheme.of(context)
                              .primary), // Change border color when focused
                    ),
                  ), // InputDecoration
                  validator: (value) {
                    if (value!.isEmpty ||
                        !RegExp(r'^[0-9]+$').hasMatch(value)) {
                      return "Entrer une surface correcte";
                    } else {
                      return null;
                    }
                  },
                ),
                BlocBuilder<ParcelBloc1, ParcelState>(
                  builder: (context, state) {
                    if (state is AddParcelLoadingState) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      return Container();
                    }
                  },
                ),
                SizedBox(
                  height: height * 0.06,
                ),
                SizedBox(
                  height: height * 0.05,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleArrowButton(onPressed: () {
                      if (formKey.currentState!.validate()) {
                        context.read<ParcelBloc1>().add(AddParcelEvent(
                            parcelName: parcelNameController.text,
                            area: double.parse(
                              areaController.text,
                            )));
                        Navigator.pushNamed(context, '/crop');
                      } else {
                        return;
                      }
                    }
                        // Action to perform when the button is pressed
                        ),
                  ],
                )
              ],
            ),
          ),
        ));
  }
}
