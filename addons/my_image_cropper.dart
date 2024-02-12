// @author Christian Babin
// @version 1.0.1
// https://github.com/babincc/flutter_workshop/blob/master/addons/my_image_cropper.dart

import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:my_skeleton/utils/my_file_explorer_sdk/my_file_explorer_sdk.dart';

/// Allows users to crop images.
///
/// This example shows how to create an image cropper that only allows the user
/// to create a square image.
///
/// ```dart
/// /// Original sized image.
/// File myImage = File('/path/to/image.jpg');
///
/// // Crop the image.
/// File? croppedImage = MyImageCropper.crop(
///   image: myImage,
///   aspectRatioPresets: [CropAspectRatioPreset.square],
///   uiSettings: [
///     AndroidUiSettings(
///       initAspectRatio: CropAspectRatioPreset.square,
///       lockAspectRatio: true,
///     ),
///     IOSUiSettings(
///       minimumAspectRatio: 1.0,
///       aspectRatioLockEnabled: true,
///     ),
///     WebUiSettings(
///       context: context,
///     ),
///   ],
/// );
/// ```
class MyImageCropper {
  /// For default file naming, this prefix is used to identify files created by
  /// [MyImageCropper].
  ///
  /// Note: "fmic" stands for "from my image cropper"
  static const String filePrefix = 'img_fmic_';

  /// Opens an interface to crop the given `image`.
  ///
  /// If the givin `image` is not valid, or the cropping process fails, this
  /// method will return `null`.
  static Future<File?> crop({
    required File image,
    int? maxWidth,
    int? maxHeight,
    CropAspectRatio? aspectRatio,
    List<CropAspectRatioPreset>? aspectRatioPresets,
    CropStyle cropStyle = CropStyle.rectangle,
    ImageCompressFormat compressFormat = ImageCompressFormat.jpg,
    int compressQuality = 90,
    List<PlatformUiSettings>? uiSettings,
  }) async {
    CroppedFile? croppedImage;

    try {
      croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        maxWidth: maxWidth,
        maxHeight: maxHeight,
        aspectRatio: aspectRatio,
        aspectRatioPresets: aspectRatioPresets ??
            const [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio3x2,
              CropAspectRatioPreset.ratio4x3,
              CropAspectRatioPreset.ratio16x9,
            ],
        cropStyle: cropStyle,
        compressFormat: compressFormat,
        compressQuality: compressQuality,
        uiSettings: uiSettings,
      );
    } catch (e) {
      // Unrectifiable error! Must return null.
      return null;
    }

    // Unrectifiable error! Must return null.
    if (croppedImage == null) return null;

    /// The file extension for the cropped image file being returned.
    final String? fileExt =
        MyFileExplorerSDK.tryParseFileExt(croppedImage.path);

    // Unrectifiable error! Must return null.
    if (fileExt == null) return null;

    /// The name of the cropped image file being returned.
    final String croppedImageFileName =
        filePrefix + DateTime.now().millisecondsSinceEpoch.toString() + fileExt;

    /// The location where the cropped image file will be saved.
    final String? croppedImageFilePath =
        MyFileExplorerSDK.tryGetNewNameWithPath(
      croppedImage.path,
      croppedImageFileName,
    );

    // Unrectifiable error! Must return null.
    if (croppedImageFilePath == null) return null;

    // Rename the cropped image file from the default one image_cropper gives
    // it.
    return File(croppedImage.path).renameSync(croppedImageFilePath);
  }
}
