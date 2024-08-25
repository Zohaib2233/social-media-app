import 'dart:io';
import 'dart:typed_data';

import 'package:app_settings/app_settings.dart';
import 'package:dio/dio.dart';
import 'package:flutter_media_downloader/flutter_media_downloader.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:soical_media_app/core/utils/snackbar.dart';

import '../core/utils/utils.dart';

class DownloadFileService {
  DownloadFileService._privateConstructor();

  static DownloadFileService? _instance;

  static DownloadFileService get instance {
    _instance ??= DownloadFileService._privateConstructor();
    return _instance!;
  }

  final Dio _dio = Dio();

  Future<String> createDirectory({required String dirName}) async {
    final Directory? appDocDir = await getDownloadsDirectory();
    final Directory dir =
        // Directory('${appDocDir!.absolute.path}' + '/' +'nur_social_app'+'/' +'$dirName');
        Directory('${appDocDir!.absolute.path}');
    print("dir.path = ${dir.path}");
    if (await dir.exists()) {
      return dir.path;
    } else {

      final Directory newDir = await dir.create(recursive: true);
      print("New Dir = ${newDir.path}");
      return newDir.path;
    }


  }

  Future<void> downloadFile(String url, String fileName, bool isImage) async {
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
    await Permission.videos.request();
    await Permission.photos.request();
    PermissionStatus status = (await Permission.photos.status);
    print("PermissionStatus =  $status");
    if (await Permission.photos.request().isGranted ) {

      String dirPath = '';
      if(isImage){
       dirPath = await createDirectory(dirName: 'videos');
      }
      else{
        dirPath = await createDirectory(dirName: 'images');
      }
      print("Dire Path = $dirPath");

      final filePath = '$dirPath/$fileName';

      try {
        await _dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              print((received / total * 100).toStringAsFixed(0) + "%");
              // setState(() {
              //   _progress = (received / total * 100).toStringAsFixed(0) + "%";
              // });
            }
          },
        );

        print("Downloaded path = $filePath");
        CustomSnackBars.instance.showSuccessSnackbar(
            title: "Downloaded", message: "File downloaded to $filePath");
      } catch (e) {
        // setState(() {
        //   _isDownloading = false;
        //   _progress = "Download failed";
        // });

        CustomSnackBars.instance
            .showFailureSnackbar(title: "Failed", message: "Error $e");
      }
    } else {
      await Permission.storage.request();
      await Permission.manageExternalStorage.request();
      // AppSettings.openAppSettings();
      CustomSnackBars.instance.showFailureSnackbar(
          title: "Failed", message: "Storage permission is not granted");
    }
  }

  downloadFileThroughFlutterMediaDown({required String url,required String desc, }) async {
    print("Download Files Called");
    await Permission.manageExternalStorage.request();
    await Permission.storage.request();
    PermissionStatus status = (await Permission.storage.status);
    print("PermissionStatus =  $status");
    final _flutterMediaDownloaderPlugin = MediaDownload();
    String dirPath = await createDirectory(dirName: 'files');
    await _flutterMediaDownloaderPlugin.downloadFile(url, "Downloading", desc, '$dirPath/image${DateTime(2011).millisecondsSinceEpoch}.jpeg');
  }

  /// through Gallery Saver image_gallery_saver

  saveNetworkImage({required String url, required Function(int receive, int total) onReceiveProgress}) async {
    var response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
    onReceiveProgress: onReceiveProgress);
    final result = await ImageGallerySaver.saveImage(
        Uint8List.fromList(response.data),
        quality: 60,
        name: "image_${DateTime.now().millisecondsSinceEpoch}");
    print(result);
    // Utils.toast("$result");
  }

  saveNetworkGifFile({required String url}) async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/gif_${DateTime.now().millisecondsSinceEpoch}.gif";
    String fileUrl = url;
    await Dio().download(fileUrl, savePath);
    final result =
    await ImageGallerySaver.saveFile(savePath, isReturnPathOfIOS: true);
    print(result);

  }

  saveNetworkVideoFile({required url}) async {
    var appDocDir = await getTemporaryDirectory();
    String savePath = appDocDir.path + "/video_${DateTime.now().millisecondsSinceEpoch}.mp4";
    String fileUrl = url;
    await Dio().download(fileUrl, savePath, onReceiveProgress: (count, total) {
      print((count / total * 100).toStringAsFixed(0) + "%");
    });
    final result = await ImageGallerySaver.saveFile(savePath);
    print(result);

  }
}
