import 'package:flutter/cupertino.dart';

abstract class ItemViewStateless<D> extends StatelessWidget {
  @protected
  final D data;

  @protected
  final int index;

  const ItemViewStateless({super.key, required this.data, required this.index});
}

abstract class ItemViewStateful<D> extends StatefulWidget {
  final D data;

  final int index;

  const ItemViewStateful({super.key, required this.data, required this.index});
}
