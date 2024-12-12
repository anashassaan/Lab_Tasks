import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:gallery_saver/gallery_saver.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Camera and Gallery Saver'),
        ),
        body: Center(
          child: CameraScreen(),
        ),
      ),
    );
  }
}

class CameraScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Get.find<CameraController>().takePhoto(),
      child: Text('Take Photo'),
    );
  }
}

class CameraController extends GetxController {
  final ImagePicker _picker = ImagePicker();

  Future<void> takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      await GallerySaver.saveImage(photo.path);
      Get.snackbar('Success', 'Photo saved to gallery!',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CameraController());
  }
}
