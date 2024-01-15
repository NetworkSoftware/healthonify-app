import 'dart:developer';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class CustomImagePicker {
  Future<File> imagePicker(ImageSource imgSource) async {
    File? image;

    try {
      final galleryimage = await ImagePicker().pickImage(
        source: imgSource,
      );
      if (galleryimage == null) {
        throw "No image picked";
      }
      final permanentImage = await savePermanentImage(galleryimage.path);

      image = permanentImage;
      log(image.path.toString());
      return image;
    } on PlatformException {
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<String> cropImage(File? pickedImage) async {
    CroppedFile cropFile;
    try {
      if (pickedImage != null) {
        final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedImage.path,
          compressQuality: 80,
          aspectRatio: const CropAspectRatio(ratioX: 100, ratioY: 100),
        );
        if (croppedFile != null) {
          cropFile = croppedFile;
          return cropFile.path;
        }
      }
      throw "Unable to crop image";
    } catch (e) {
      rethrow;
    }
  }

  Future<File> savePermanentImage(String imagePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final name = basename(imagePath);
    final image = File('${directory.path}/$name');
    return File(imagePath).copy(image.path);
  }
}
