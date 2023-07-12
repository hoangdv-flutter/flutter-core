import 'package:flutter/cupertino.dart';

abstract class ItemViewStateless<D> extends StatelessWidget {
  @protected
  final D data;

  @protected
  final int index;

  const ItemViewStateless({Key? key, required this.data, required this.index})
      : super(key: key);
}

abstract class ItemViewStateful<D> extends StatefulWidget {
  final D data;

  final int index;

  const ItemViewStateful({Key? key, required this.data, required this.index})
      : super(key: key);
}
