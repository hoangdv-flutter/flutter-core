part of 'exts.dart';

extension FileExt on File {
  Future<void> moveTo(String path) async {
    final file = File(path);
    await file.parent.let(
      call: (value) => file.create(recursive: true),
    );
    await file.copy(path);
    await file.delete(recursive: true);
  }
}