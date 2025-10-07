import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_core/component/view/bottom_nav/bottom_menu_cubit.dart';
import 'package:flutter_core/core.dart';

class PagerView extends StatefulWidget {
  final Function(int)? onPageSelected;

  final List<Widget> children;

  const PagerView({super.key, required this.children, this.onPageSelected});

  @override
  State<PagerView> createState() => _PagerViewState();
}

class _PagerViewState extends BaseState<PagerView> {
  StreamSubscription? _subscription;

  var selectedItem = 0;

  Timer? _notifyPageDebounce;

  final pageController = PageController(keepPage: true);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _subscription?.cancel();
    _subscription = context.read<PageControllerCubit>().stream.listen((page) {
      if (page == selectedItem) return;
      pageController.animateToPage(page,
          duration: const Duration(milliseconds: 300),
          curve: Curves.fastOutSlowIn);
    });
    return PageView(
      controller: pageController,
      physics: const NeverScrollableScrollPhysics(),
      onPageChanged: (page) {
        selectedItem = page;
        if (_notifyPageDebounce?.isActive != true) {
          _notifyPageDebounce?.cancel();
          _notifyPageDebounce = Timer(const Duration(milliseconds: 100), () {
            context.read<PageControllerCubit>().selectPage(selectedItem);
          });
        }
      },
      children: widget.children,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    pageController.dispose();
    _notifyPageDebounce?.cancel();
    super.dispose();
  }
}
