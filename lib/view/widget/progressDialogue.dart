import 'package:flutter/material.dart';

import 'loader.dart';



void showProgressDialog({required BuildContext context}) {
  //showing progress indicator
  showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
          onWillPop: () => Future.value(false),
          child: const ProgressDialog(msg: 'Please Wait...')));
}