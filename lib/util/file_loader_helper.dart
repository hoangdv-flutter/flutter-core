part of 'util.dart';

class FileLoaderHelper {
  FileLoaderHelper._();

  static Future<dynamic> getFileOrAssets(String path) async {
    if (path.startsWith('assets/')) {
      return await rootBundle.load(path);
    }
    return path;
  }
}
