import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';

class Utils {
  static createDatePicker(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        //get today's date
        firstDate: DateTime(1940),
        //DateTime.now() - not to allow to choose before today.
        lastDate: DateTime(2101));

    if (pickedDate != null) {
      // print(pickedDate); //get the picked date in the format => 2022-07-04 00:00:00.000

      String formattedDate = DateFormat('dd/MM/yyyy').format(
          pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
      // print(
      //     formattedDate); //formatted date output using intl package =>  2022-07-04
      //You can format date as per your need
      // return formattedDate;
      return formattedDate;
    } else {
      print("Date is not selected");
    }
  }

  static String formatDateTimetoTime(DateTime time) {
    // Define the date format
    final dateFormat = DateFormat('h:mm a');

    // Format the DateTime object
    return dateFormat.format(time);
  }

  static Future<bool> storagePermission() async {
    await Permission.photos.request();
    await Permission.videos.request();
    await Permission.storage.request();

    if(await Permission.photos.status.isGranted || await Permission.storage.status.isGranted){
      return true;

    }
    else{
      return false;
    }
  }
}
