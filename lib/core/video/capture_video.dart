import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';

bool get canRecordVideo =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.android);

Future<XFile?> recordVideo() =>
    ImagePicker().pickVideo(source: ImageSource.camera);

Future<void> saveRecordedVideo(XFile clip) async {
  final file = File(clip.path);
  await PhotoManager.editor.saveVideo(file);
  try {
    await file.delete();
  } on FileSystemException catch (error) {
    debugPrint('Could not remove temporary camera video: $error');
  }
}
