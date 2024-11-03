part of 'util.dart';


class DirManager {


  static Future<String> getInternalDir(String dir) async {
    final root = await getApplicationDocumentsDirectory();
    final recordingDir = Directory("${root.path}/$dir");
    if (!(await recordingDir.exists())) {
      await recordingDir.create(recursive: true);
    }
    return recordingDir.path;
  }

  DirManager._();
}
