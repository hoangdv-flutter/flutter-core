part of '../util.dart';

class RectRotated {
  final List<Point> points;
  final Point c;

  RectRotated.fromLTWH(double l, double t, double w, double h)
      : points = [
          Point(l, t),
          Point(l + w, t),
          Point(l + w, t + h),
          Point(l, t + h)
        ],
        c = Point(l + w / 2, t + h / 2);

  void rotate(double radians) {
    for (final p in points) {
      p.rotate(radians, c);
    }
  }

  bool overlaps(RectRotated other) {
    for (final polygon in [this, other]) {
      for (int i1 = 0; i1 < polygon.points.length; i1++) {
        int i2 = (i1 + 1) % polygon.points.length;
        var p1 = polygon.points[i1];
        var p2 = polygon.points[i2];

        var normal = Point(p2.y - p1.y, p1.x - p2.x);

        double? minA, maxA;
        for (var p in points) {
          var projected = normal.x * p.x + normal.y * p.y;
          if (minA == null || projected < minA) {
            minA = projected;
          }
          if (maxA == null || projected > maxA) {
            maxA = projected;
          }
        }

        double? minB, maxB;
        for (var p in other.points) {
          var projected = normal.x * p.x + normal.y * p.y;
          if (minB == null || projected < minB) {
            minB = projected;
          }
          if (maxB == null || projected > maxB) {
            maxB = projected;
          }
        }
        if (minA != null &&
            minB != null &&
            maxA != null &&
            maxB != null) if (maxA < minB || maxB < minA) {
          return false;
        }
      }
    }
    return true;
  }

  bool contains(Offset point) {
    double x = point.dx, y = point.dy;
    bool inside = false;
    Point p1 = points[0], p2;

    for (int i = 1; i <= points.length; i++) {
      p2 = points[i % points.length];
      if (y > min(p1.y, p2.y)) {
        if (y <= max(p1.y, p2.y)) {
          if (x <= max(p1.x, p2.x)) {
            double xIntersect =
                (y - p1.y) * (p2.x - p1.x) / (p2.y - p1.y) + p1.x;
            if (p1.x == p2.x || x <= xIntersect) {
              inside = !inside;
            }
          }
        }
      }
      p1 = p2;
    }
    return inside;
  }
}

class Point {
  double x, y;

  Point(this.x, this.y);

  void rotate(double radians, Point c) {
    final tempX = x - c.x;
    final tempY = y - c.y;
    final rotatedX = tempX * cos(radians) - tempY * sin(radians);
    final rotatedY = tempX * sin(radians) + tempY * cos(radians);
    x = rotatedX + c.x;
    y = rotatedY + c.y;
  }
}
