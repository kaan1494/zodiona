import 'web_image_picker_stub.dart'
    if (dart.library.html) 'web_image_picker_web.dart' as impl;

Future<Map<String, dynamic>?> pickImageForWebSafe() {
  return impl.pickImageForWeb();
}
