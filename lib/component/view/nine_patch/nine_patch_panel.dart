part of '../view.dart';

/// Multi-segment Android 9-patch renderer (tái dùng cho mọi project).
///
/// Đọc TRỰC TIẾP marker từ file `.9.png` (1-px border):
/// - cạnh trên  → nhiều đoạn stretch ngang
/// - cạnh trái  → nhiều đoạn stretch dọc
/// - cạnh phải/dưới → content box (vùng đặt child)
///
/// Khác `DecorationImage.centerSlice` (chỉ 1 vùng giãn 3×3), widget này vẽ lưới
/// N×M: ô cố định giữ tỉ lệ (nhân [scale]), ô stretch hút phần không gian còn lại
/// → các đốt/đinh trang trí ở giữa cạnh KHÔNG bị méo khi khung cao/thấp khác nhau.
///
/// Marker chỉ parse 1 lần/asset rồi cache `static` (share toàn app). Mỗi lần
/// paint chỉ dùng lại data đã parse + `drawImageRect`; `shouldRepaint=false`
/// nên steady-state ~0 chi phí.
class NinePatchPanel extends StatefulWidget {
  const NinePatchPanel({
    super.key,
    required this.assetPath,
    required this.child,
    this.scale = 1.0,
    this.padding,
  });

  /// Đường dẫn `.9.png` (còn nguyên 1-px marker border).
  final String assetPath;
  final Widget child;

  /// Hệ số thu nhỏ các vùng cố định (giữ tỉ lệ). 1.0 = native px.
  final double scale;

  /// Padding cộng thêm vào content box parse từ asset.
  final EdgeInsets? padding;

  @override
  State<NinePatchPanel> createState() => _NinePatchPanelState();
}

class _NinePatchPanelState extends State<NinePatchPanel> {
  _NinePatchData? _data;
  ImageStream? _stream;
  ImageStreamListener? _listener;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _resolveImage();
  }

  void _resolveImage() {
    final stream = AssetImage(widget.assetPath)
        .resolve(createLocalImageConfiguration(context));
    if (stream.key == _stream?.key) return;
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
    _listener = ImageStreamListener((info, _) async {
      final data = await _NinePatchData.parseCached(widget.assetPath, info.image);
      if (mounted) setState(() => _data = data);
    });
    _stream = stream..addListener(_listener!);
  }

  @override
  void dispose() {
    if (_stream != null && _listener != null) {
      _stream!.removeListener(_listener!);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final data = _data;
    final extra = widget.padding ?? EdgeInsets.zero;
    if (data == null) {
      return Padding(padding: extra, child: widget.child);
    }
    final c = data.contentPadding(widget.scale);
    final pad = EdgeInsets.fromLTRB(
      c.left + extra.left,
      c.top + extra.top,
      c.right + extra.right,
      c.bottom + extra.bottom,
    );
    return CustomPaint(
      painter: _NinePatchPainter(data, widget.scale),
      child: Padding(padding: pad, child: widget.child),
    );
  }
}

/// 1 đoạn theo 1 trục (inner coords). [stretch] = có giãn hay không.
class _Seg {
  const _Seg(this.start, this.end, this.stretch);
  final double start;
  final double end;
  final bool stretch;
  double get length => end - start;
}

class _Resolved {
  const _Resolved(this.srcStart, this.srcEnd, this.dstStart, this.dstEnd);
  final double srcStart;
  final double srcEnd;
  final double dstStart;
  final double dstEnd;
}

class _NinePatchData {
  _NinePatchData({
    required this.image,
    required this.cols,
    required this.rows,
    required this.content,
  });

  final ui.Image image; // full image kèm 1-px border
  final List<_Seg> cols; // segments theo width (inner)
  final List<_Seg> rows; // segments theo height (inner)
  final Rect content; // content box (inner coords, LTRB)

  int get innerW => image.width - 2;
  int get innerH => image.height - 2;

  EdgeInsets contentPadding(double scale) => EdgeInsets.fromLTRB(
        content.left * scale,
        content.top * scale,
        (innerW - content.right) * scale,
        (innerH - content.bottom) * scale,
      );

  // Cache theo assetPath: nhiều khung dùng chung 1 asset → chỉ parse 1 lần
  // (tránh lặp lại toByteData GPU readback). Static → share toàn app.
  static final Map<String, _NinePatchData> _cache = {};
  static final Map<String, Future<_NinePatchData>> _inflight = {};

  static Future<_NinePatchData> parseCached(String key, ui.Image image) {
    final cached = _cache[key];
    if (cached != null) return Future.value(cached);
    return _inflight[key] ??= parse(image).then((data) {
      _cache[key] = data;
      _inflight.remove(key);
      return data;
    });
  }

  static Future<_NinePatchData> parse(ui.Image image) async {
    final w = image.width, h = image.height;
    final bytes =
        await image.toByteData(format: ui.ImageByteFormat.rawRgba);
    bool black(int x, int y) {
      final i = (y * w + x) * 4;
      return bytes!.getUint8(i + 3) > 128 &&
          bytes.getUint8(i) < 60 &&
          bytes.getUint8(i + 1) < 60 &&
          bytes.getUint8(i + 2) < 60;
    }

    final innerW = w - 2, innerH = h - 2;
    // stretch markers (top row / left col), tính theo inner index
    final cols = _segs([for (var x = 0; x < innerW; x++) black(x + 1, 0)]);
    final rows = _segs([for (var y = 0; y < innerH; y++) black(0, y + 1)]);
    // content box (bottom row / right col)
    final cx = _span([for (var x = 0; x < innerW; x++) black(x + 1, h - 1)]);
    final cy = _span([for (var y = 0; y < innerH; y++) black(w - 1, y + 1)]);
    final content = Rect.fromLTRB(
      (cx?.$1 ?? 0).toDouble(),
      (cy?.$1 ?? 0).toDouble(),
      (cx?.$2 ?? innerW).toDouble(),
      (cy?.$2 ?? innerH).toDouble(),
    );
    return _NinePatchData(
        image: image, cols: cols, rows: rows, content: content);
  }

  /// Gộp các pixel liền kề cùng trạng thái thành đoạn [start,end).
  static List<_Seg> _segs(List<bool> mark) {
    final out = <_Seg>[];
    var i = 0;
    final n = mark.length;
    while (i < n) {
      final v = mark[i];
      var j = i;
      while (j < n && mark[j] == v) {
        j++;
      }
      out.add(_Seg(i.toDouble(), j.toDouble(), v));
      i = j;
    }
    return out;
  }

  /// Đoạn [first, last+1) của các pixel `true` (cho content box).
  static (int, int)? _span(List<bool> mark) {
    var lo = -1, hi = -1;
    for (var i = 0; i < mark.length; i++) {
      if (mark[i]) {
        if (lo < 0) lo = i;
        hi = i;
      }
    }
    return lo < 0 ? null : (lo, hi + 1);
  }
}

class _NinePatchPainter extends CustomPainter {
  _NinePatchPainter(this.data, this.scale);

  final _NinePatchData data;
  final double scale;
  final Paint _paint = Paint()..filterQuality = FilterQuality.medium;

  @override
  void paint(Canvas canvas, Size size) {
    final cols = _resolve(data.cols, size.width);
    final rows = _resolve(data.rows, size.height);
    for (final r in rows) {
      for (final c in cols) {
        // +1: bù 1-px marker border của ảnh nguồn.
        final src = Rect.fromLTRB(
            c.srcStart + 1, r.srcStart + 1, c.srcEnd + 1, r.srcEnd + 1);
        final dst =
            Rect.fromLTRB(c.dstStart, r.dstStart, c.dstEnd, r.dstEnd);
        if (dst.width <= 0 || dst.height <= 0) continue;
        canvas.drawImageRect(data.image, src, dst, _paint);
      }
    }
  }

  /// Map các đoạn src → dst: ô cố định = len*scale, ô stretch chia đều phần dư.
  List<_Resolved> _resolve(List<_Seg> segs, double target) {
    var fixedTotal = 0.0, stretchSrcTotal = 0.0;
    for (final s in segs) {
      if (s.stretch) {
        stretchSrcTotal += s.length;
      } else {
        fixedTotal += s.length * scale;
      }
    }
    final dstStretch = (target - fixedTotal).clamp(0.0, double.infinity);
    final out = <_Resolved>[];
    var pos = 0.0;
    for (final s in segs) {
      final len = s.stretch
          ? (stretchSrcTotal > 0 ? s.length / stretchSrcTotal * dstStretch : 0.0)
          : s.length * scale;
      out.add(_Resolved(s.start, s.end, pos, pos + len));
      pos += len;
    }
    return out;
  }

  @override
  bool shouldRepaint(_NinePatchPainter old) =>
      old.data != data || old.scale != scale;
}
