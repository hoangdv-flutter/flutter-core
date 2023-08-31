import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/base_stateful.dart';
import 'package:flutter_core/ext/list.dart';

import 'bottom_menu_cubit.dart';

class BottomNavigationView extends StatefulWidget {
  final List<BottomMenuItem> menuItems;

  final Function(int)? onItemSelected;

  final Decoration? decoration;

  final Duration duration;

  final Function(int index, BottomMenuItem menu, double t, bool isSelected)
      onBuildItem;

  const BottomNavigationView(
      {super.key,
      required this.menuItems,
      this.onItemSelected,
      required this.onBuildItem,
      this.decoration,
      this.duration = const Duration(milliseconds: 500)})
      : super();

  @override
  State<BottomNavigationView> createState() => _BottomNavigationViewState();
}

class _BottomNavigationViewState extends BaseState<BottomNavigationView>
    with SingleTickerProviderStateMixin {
  var selectedItem = 0;

  var _previousSelectedItem = 0;

  late Animation<double> animation;
  late AnimationController animationController;

  var animationProgress = 0;

  StreamSubscription? _pageSubscription;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..addListener(() {
        setState(() {});
      });
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animationController.forward(from: 0);
  }

  @override
  void dispose() {
    super.dispose();
    _pageSubscription?.cancel();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _pageSubscription?.cancel();
    _pageSubscription =
        context.read<PageControllerCubit>().stream.listen((page) {
      selectPage(page);
    });
    return Container(
      decoration: widget.decoration,
      child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children:
              widget.menuItems.convert((p0, p1) => _buildMenuItem(p0, p1))),
    );
  }

  Widget _buildMenuItem(int index, BottomMenuItem e) {
    final isSelected = index == selectedItem;
    final isPreviousSelected = index == _previousSelectedItem;
    final needToAnimate = isSelected || isPreviousSelected;
    final t = isSelected ? animation.value : 1 - animation.value;
    return Expanded(
        child: GestureDetector(
      onTap: () {
        selectPage(index);
      },
      behavior: HitTestBehavior.opaque,
      child: widget.onBuildItem.call(index, e, t, isSelected),
    ));
  }

  void selectPage(int index) {
    if (index == selectedItem) return;
    setState(() {
      _previousSelectedItem = selectedItem;
      selectedItem = index;
      context.read<PageControllerCubit>().selectPage(index);
      widget.onItemSelected?.call(selectedItem);
      animationController.forward(from: 0);
    });
  }
}

class BottomMenuItem {
  String? title;
  String icon;

  BottomMenuItem({required this.icon, this.title});
}
