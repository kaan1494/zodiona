import 'dart:async';
import 'dart:html' as html;
import 'dart:typed_data';

Future<Map<String, dynamic>?> pickImageForWeb() async {
  final input = html.FileUploadInputElement()..accept = 'image/*';
  input.click();

  await input.onChange.first;
  final file = input.files?.isNotEmpty == true ? input.files!.first : null;
  if (file == null) {
    return null;
  }

  final reader = html.FileReader();
  final completer = Completer<Map<String, dynamic>?>();

  reader.onLoadEnd.listen((_) {
    final result = reader.result;
    Uint8List? bytes;
    if (result is ByteBuffer) {
      bytes = Uint8List.view(result);
    } else if (result is Uint8List) {
      bytes = result;
    }

    if (bytes == null) {
      completer.complete(null);
      return;
    }

    completer.complete({
      'bytes': bytes,
      'name': file.name,
      'mimeType': file.type,
    });
  });

  reader.onError.listen((_) {
    completer.completeError(Exception('Dosya okunamadi.'));
  });

  reader.readAsArrayBuffer(file);
  return completer.future;
}
