import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../core/utils/snackbar.dart';

class FirebaseStorageService {
  FirebaseStorageService._privateConstructor();

  //singleton instance variable
  static FirebaseStorageService? _instance;

  //This code ensures that the singleton instance is created only when it's accessed for the first time.
  //Subsequent calls to FirebaseCRUDService.instance will return the same instance that was created before.

  //getter to access the singleton instance
  static FirebaseStorageService get instance {
    _instance ??= FirebaseStorageService._privateConstructor();
    return _instance!;
  }


  Future<String> pickImageFromCamera() async {
    ImagePicker imagePicker = ImagePicker();
    final XFile? images =
    await imagePicker.pickImage(source: ImageSource.camera);
    if (images!.path.isEmpty) return '';
    return images.path;
  }

  Future<String> pickImageFromGallery() async {
    ImagePicker imagePicker = ImagePicker();
    final XFile? images =
    await imagePicker.pickImage(source: ImageSource.gallery);
    if (images == null) return '';
    return images.path;
  }

  Future<FilePickerResult?> pickCustomFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'ppt', 'xls', 'xlsx'], // Add extensions you want to allow
    );

    return result;
  }

  Future<FilePickerResult?> pickFile({required FileType fileType,bool allowMultiple=false}) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: fileType,
      allowMultiple: allowMultiple,
    );
    return result;
  }

  Future<(String,bool)> uploadFile({
    String storageRef = "audio",
    FilePickerResult? result

  }) async {
    try {

      // return result?.paths.first!;
    print("------------------- select File $result");
      if (result != null) {
        File file = File(result.files.single.path!);
        String fileName = path.basename(file.path);

        // Upload the file to Firebase Storage
        Reference reference = FirebaseStorage.instance.ref().child(storageRef).child(fileName);
        print("reference === $reference");
        // UploadTask uploadTask = reference.putFile(file);
        Uint8List bytes = file.readAsBytesSync();
        // await reference.putFile(file).timeout(Duration(seconds: 30));

        await reference.putData(bytes).timeout(Duration(seconds: 30));

        // Get download URL of the uploaded file
        String downloadURL = await reference.getDownloadURL();

        // Perform any action with the download URL, such as storing it in Firestore
        print('Download URL: $downloadURL');
        return (downloadURL,true);
      } else {
        // User canceled the file picker
        print('User canceled file picking');
        return ('',false);
      }
    } on FirebaseException catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
      return ('',false);
    } on TimeoutException {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: 'Request Timeout');
      return ('',false);
    } catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
      return ('',false);
    }
  }

  Future<String> uploadFileToStorage({required String filePath,String storageRef = "audio"}) async {
    File file = File(filePath);
    String fileName = path.basename(file.path);

    try{
      // Upload the file to Firebase Storage
      Reference reference = FirebaseStorage.instance.ref().child(storageRef).child(fileName);
      print("reference === $reference");
      // UploadTask uploadTask = reference.putFile(file);
      Uint8List bytes = file.readAsBytesSync();
      // await reference.putFile(file).timeout(Duration(seconds: 30));

      await reference.putData(bytes).timeout(Duration(seconds: 30));

      // Get download URL of the uploaded file
      String downloadURL = await reference.getDownloadURL();

      // Perform any action with the download URL, such as storing it in Firestore

      return (downloadURL);
    }on FirebaseException catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
      return ('');
    } on TimeoutException {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: 'Request Timeout');
      return ('');
    } catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
      return ('');
    }

  }


  Future<String> uploadSingleImage(
      {required String imgFilePath, String storageRef = "images"}) async {
    try {
      final filePath = path.basename(imgFilePath);
      final ref =
      FirebaseStorage.instance.ref().child(storageRef).child(filePath);

      // await ref.putFile(File(imgFilePath));
      // // await ref.putFile(File(imgFilePath)).timeout(Duration(seconds: 30));
      //
      // String downloadUrl = await ref.getDownloadURL();
      Uint8List bytes = File(imgFilePath).readAsBytesSync(); //THIS LINE
      var snapshot = await ref.putData(bytes).timeout(Duration(seconds: 30)); //THIS LINE
      return await snapshot.ref.getDownloadURL();

    } on FirebaseException catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
      return '';
    } on TimeoutException {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: 'Request Timeout');
      return '';
    } catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
      return '';
    }
  }

  //get image url paths functions
  Future<List> uploadMultipleImages(
      {required List imagesPaths, String storageRef = "images"}) async {
    try {
      final futureList = imagesPaths.map((element) async {
        final filePath = path.basename(element.path);
        final ref =
        FirebaseStorage.instance.ref().child(storageRef).child(filePath);
        await ref.putFile(File(element.path));
        return ref.getDownloadURL();
      });
      final downloadURLs = await Future.wait(futureList);
      return downloadURLs;
    } on FirebaseException catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
      return [];
    } on TimeoutException {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: 'Request Timeout');
      return [];
    } catch (e) {
      CustomSnackBars.instance
          .showFailureSnackbar(title: "Failed", message: '$e');
      return [];
    }
  }
}