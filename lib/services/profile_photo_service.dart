import 'dart:typed_data';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

abstract interface class ProfilePhotoPicker {
  Future<Uint8List?> capture();
}

class CameraProfilePhotoPicker implements ProfilePhotoPicker {
  CameraProfilePhotoPicker({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<Uint8List?> capture() async {
    final image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 65,
    );
    return image?.readAsBytes();
  }
}
