// @author Christian Babin
// @version 1.0.0
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_image_importer.dart

import 'dart:io';

import 'package:image_picker/image_picker.dart';

import 'my_file_explorer_sdk/my_file_explorer_sdk.dart';

/// Class is used to import images into this program.
///
/// It can get images from the device's default gallery or the camera.
class MyImageImporter {
  /// For default file naming, this prefix is used to identify files created by
  /// [MyImageImporter].
  ///
  /// Note: "fmii" stands for "from my image importer"
  static const String filePrefix = "img_fmii_";

  /// This method gets an image from the photo gallery and returns the file.
  ///
  /// The file will be saved to the temporary folder in the device's working
  /// directory for this app. It will either be named with the given `fileName`
  /// or, if that is `null`, [filePrefix]{millisecondsSinceEpoch}.
  static Future<File?> import(ImageOrigin imageOrigin,
      {String? fileName}) async {
    if (imageOrigin == ImageOrigin.gallery) {
      return await importFromGallery(fileName: fileName);
    }

    return await importFromCamera(fileName: fileName);
  }

  /// This method gets an image from the photo gallery and returns the file.
  ///
  /// The file will be saved to the temporary folder in the device's working
  /// directory for this app. It will either be named with the given `fileName`
  /// or, if that is `null`, [filePrefix]{millisecondsSinceEpoch}.
  static Future<File?> importFromGallery({String? fileName}) async {
    final selectedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    return _finalizeImport(selectedImage, fileName);
  }

  /// This method takes a picture with the camera and returns the file.
  ///
  /// The file will be saved to the temporary folder in the device's working
  /// directory for this app. It will either be named with the given `fileName`
  /// or, if that is `null`, [filePrefix]{millisecondsSinceEpoch}.
  static Future<File?> importFromCamera({String? fileName}) async {
    final selectedImage = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    );

    return _finalizeImport(selectedImage, fileName);
  }

  /// This method finishes importing an image after one is either selected from
  /// the gallery or taken with the camera.
  ///
  /// It is a helper method for [importFromGallery] and [importFromCamera].
  static Future<File?> _finalizeImport(
      XFile? selectedImage, String? fileName) async {
    // Unrectifiable error! Must return null.
    if (selectedImage == null) return null;

    /// The file extension for the image file being returned.
    final String? fileExt =
        MyFileExplorerSDK.tryParseFileExt(selectedImage.path);

    // Unrectifiable error! Must return null.
    if (fileExt == null) return null;

    /// The base name of the image file.
    final String fileBaseName =
        fileName ?? "$filePrefix${DateTime.now().millisecondsSinceEpoch}";

    /// The path to the image file.
    final String imagePath = await MyFileExplorerSDK.createPathToFile(
      localDir: LocalDir.tempDir,
      fileName: fileBaseName + fileExt,
    );

    // Write the image to the [imagePath] location.
    await selectedImage.saveTo(imagePath);

    // Delete the temporary file made by [ImagePicker].
    File(selectedImage.path).deleteSync();

    // Return the image file.
    return File(imagePath);
  }
}

/// Describes where the program should start looking for the image that is to be
/// imported.
enum ImageOrigin {
  /// Image already exists in the device's default image gallery.
  gallery,

  /// Image does not exist and needs to be taken with the camera.
  camera,
}
