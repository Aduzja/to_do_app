import 'package:flutter/material.dart';
import 'package:to_do_app/helpers/size_helper.dart';
import 'package:to_do_app/helpers/constants.dart';
import 'package:google_fonts/google_fonts.dart';

class TaskWidget extends StatelessWidget {
  const TaskWidget(
    this.title, {
    Key? key,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.colorMustard,
      padding: EdgeInsets.all(
        SizeHelper.getSizeFromPx(context, 45),
      ),
      margin: EdgeInsets.all(
        SizeHelper.getSizeFromPx(context, 45),
      ),
      child: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: SizeHelper.getSizeFromPx(context, 50),
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}
