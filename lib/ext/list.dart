part of 'exts.dart';


extension ListExt<T> on List<T> {
  List<G> convert<G>(Function(int index, T element) onConvert) {
    final res = <G>[];
    asMap().forEach((index, element) {
      res.add(onConvert(index, element));
    });
    return res;
  }

  T? get randomOrNull {
    if (isEmpty) return null;
    return getOrNull(Random().nextInt(length));
  }

  int get lastIndex => length - 1;

  T? getOrNull(int index) =>
      index >= 0 && index <= lastIndex ? this[index] : null;

  T? removeFirst() {
    if (isNotEmpty) {
      final r = this[0];
      removeAt(0);
      return r;
    }
    return null;
  }

  List<List<T>> chunks(int span) {
    final res = <List<T>>[];
    for (var i = 0; i < length; i += span) {
      res.add(sublist(i, min(i + span, length)));
    }
    return res;
  }

  T? get firstOrNull => isEmpty ? null : first;

  T? get lastOrNull => isEmpty ? null : last;

}

extension ListExt2<T> on List<T>? {
  bool get isNullOrEmpty => this?.isEmpty != false;
}
