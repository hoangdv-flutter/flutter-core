import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_core/core.dart';
import 'package:flutter_core/theme/app_theme.dart';

abstract class MyListView<D> extends StatefulWidget {
  const MyListView({super.key});
}

abstract class MyListViewState<D, T extends StatefulWidget>
    extends BaseState<T> {
  StreamSubscription? _listUpdateSubscriptions;

  StreamSubscription? _itemUpdateSubscriptions;

  var _listState = ListState.loading;

  @protected
  var useAnimated = false;

  @override
  void initState() {
    super.initState();
    setupCubitLogic();
  }

  @protected
  final GlobalKey<AnimatedListState> listKey = GlobalKey();

  @protected
  Widget buildListItem(BuildContext context);

  @override
  Widget build(BuildContext context) {
    if (_listState == ListState.loading) return buildLoading();
    if (_listState == ListState.loaded && listData.isEmpty) {
      return buildPlaceholder();
    }
    return buildListItem(context);
  }

  @protected
  Widget buildLoading() {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 5,
        valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
      ),
    );
  }

  @protected
  Widget buildPlaceholder() {
    return Center(
      child: Text(
        "Not data yet!",
        style: TextStyle(
            color: appColor.colorBlack,
            fontSize: 20.sp,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  @protected
  void listenListStream(Stream<ListItemUpdate<D>?> stream) {
    _listUpdateSubscriptions?.cancel();
    _listUpdateSubscriptions = stream.listen((event) {
      onListListening(event);
    });
  }

  @protected
  void onItemUpdateListening(ItemUpdate<D>? event,
      {bool needToUpdateState = true}) {
    if (event == null) return;
    switch (event.action) {
      case ItemUpdateAction.remove:
        event.data == null
            ? removeAt(event.index, needToSetState: needToUpdateState)
            : remove(event.data as D, needToSetState: needToUpdateState);
        break;
      case ItemUpdateAction.replace:
        if (event.data != null) {
          update(event.index, event.data as D);
        }
        break;
      case ItemUpdateAction.add:
        if (event.data != null) {
          insert(event.data as D,
              index: event.index, needToSetState: needToUpdateState);
        }
        break;
      case ItemUpdateAction.loading:
        break;
    }
  }

  @protected
  void listenItemUpdateStream(Stream<ItemUpdate<D>?> stream) {
    _itemUpdateSubscriptions?.cancel();
    _itemUpdateSubscriptions = stream.listen((event) {
      onItemUpdateListening(event);
    });
  }

  final List<D> listData = <D>[];

  void notify(Function() call, {Function()? animateItem}) {
    if (useAnimated && animateItem != null && listData.isNotEmpty) {
      call();
      if (listData.isEmpty) {
        setState(() {});
        return;
      }
      animateItem();
      return;
    }
    setState(call);
  }

  void replace(List<D> data) {
    notify(() {
      listData.clear();
      listData.addAll(data);
    });
  }

  void insertAll(List<D> data, {int index = -1}) {
    notify(() {
      listData.insertAll(index == -1 ? listData.length : index, data);
    });
  }

  void insert(D item, {int index = -1, bool? needToSetState = true}) {
    if (needToSetState == false) {
      listData.insert(index == -1 ? listData.length : index, item);
      return;
    }
    notify(
      () {
        listData.insert(index == -1 ? listData.length : index, item);
      },
      animateItem: () => listKey.currentState
          ?.insertItem(index == -1 ? listData.lastIndex : index),
    );
  }

  Widget buildItemWithAnimation(
          int index, D dataReplacement, Animation<double> animation) =>
      Container();

  void removeAt(int index, {bool? needToSetState = true}) {
    final itemRemoved = listData[index];
    if (needToSetState == false) {
      listData.removeAt(index);
      return;
    }
    notify(
      () {
        listData.removeAt(index);
      },
      animateItem: () {
        listKey.currentState?.removeItem(
            index,
            (context, animation) =>
                buildItemWithAnimation(index, itemRemoved, animation));
      },
    );
  }

  void remove(D item, {bool needToSetState = true}) {
    final index = listData.indexOf(item);
    if (index != -1) {
      removeAt(index, needToSetState: needToSetState);
    }
  }

  void update(int index, D item) {
    final i =
        index == -1 ? listData.indexWhere((element) => element == item) : index;
    if (i == -1) return;
    notify(() {
      listData[i] = item;
    });
  }

  @override
  void dispose() {
    _itemUpdateSubscriptions?.cancel();
    _listUpdateSubscriptions?.cancel();
    super.dispose();
  }

  void setupCubitLogic() {}

  void onListListening(ListItemUpdate<D>? event) {
    if (event == null) return;
    switch (event.action) {
      case ItemUpdateAction.add:
        insertAll(event.data, index: event.index ?? -1);
        _listState = ListState.loaded;
        break;
      case ItemUpdateAction.replace:
        _listState = ListState.loaded;
        replace(event.data);
        break;
      case ItemUpdateAction.remove:
        break;
      case ItemUpdateAction.loading:
        _listState = ListState.loading;
        replace([]);
        break;
    }
  }
}

class ItemUpdate<D> {
  final int index;

  D? data;

  ItemUpdateAction action;

  ItemUpdate(this.index, this.action, {this.data});

  ItemUpdate<D> copy({int? index, D? data, ItemUpdateAction? action}) {
    return ItemUpdate(index ?? this.index, action ?? this.action,
        data: data ?? this.data);
  }
}

enum ListState { loading, loaded, loadMore }

class ListItemUpdate<D> {
  final int? index;

  List<D> data;

  final ItemUpdateAction action;

  ListItemUpdate({this.index, required this.data, required this.action});

  ListItemUpdate<D> copy(
          {int? index, List<D>? data, ItemUpdateAction? action}) =>
      ListItemUpdate(
          index: index ?? this.index,
          data: data ?? this.data,
          action: action ?? this.action);
}

enum ItemUpdateAction { remove, replace, add, loading }
