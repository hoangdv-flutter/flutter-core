import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_core/ext/list.dart';
import 'package:flutter_core/ext/string.dart';
import 'package:flutter_core/theme/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AppBarHelper {
  static AppBar buildAppbar(Widget toolbar,
      {SystemUiOverlayStyle? systemOverlayStyle}) {
    return AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 8.h,
        elevation: 0,
        systemOverlayStyle: systemOverlayStyle ??
            SystemUiOverlayStyle.light
                .copyWith(statusBarColor: Colors.transparent),
        backgroundColor: Colors.transparent,
        flexibleSpace: toolbar);
  }
}

class Toolbar extends StatelessWidget {
  final Widget? icon;

  final String? title;

  final Widget? titleWidget;

  final TextStyle? titleStyle;

  final Function()? onIconPressed;

  final List<MenuItem>? menuItems;

  const Toolbar(
      {super.key,
      this.icon,
      this.title,
      this.menuItems,
      this.onIconPressed,
      this.titleStyle,
      this.titleWidget});

  @override
  Widget build(BuildContext context) {
    final iconSize = 10.w;
    var left = 0;
    var right = 0;
    final children = <Widget>[];
    if (icon != null) {
      left++;
      children.add(IconButton(
          onPressed: onIconPressed, iconSize: iconSize, icon: icon!));
    }
    if (titleWidget != null) {
      children.add(Expanded(child: titleWidget!));
    } else if (!title.isNullOrEmpty) {
      children.add(Expanded(
          child: Center(
        child: Text(
          title!,
          style: titleStyle ??
              TextStyle(
                  fontFamily: 'titleFont',
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: appColor.colorBlack),
          textAlign: TextAlign.center,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      )));
    } else {
      children.add(Expanded(child: Container()));
    }
    if (!menuItems.isNullOrEmpty) {
      children.add(Row(
        children: List.generate(menuItems!.length, (index) {
          right++;
          return _buildMenuItemView(menuItems![index], iconSize);
        }),
      ));
    }
    if (left < right) {
      children.insert(
          1,
          SizedBox(
            width: iconSize,
          ));
    } else if (left > right) {
      children.add(SizedBox(
        width: iconSize,
      ));
    }
    return Row(
      children: children,
    );
  }

  Widget _buildMenuItemView(MenuItem menuItem, double iconSize) {
    return IconButton(
      onPressed: menuItem.clickListener,
      icon: menuItem.icon,
      iconSize: iconSize,
    );
  }
}

class MenuItem {
  final String? title;
  final Widget icon;
  final Function()? clickListener;

  const MenuItem({this.title, required this.icon, this.clickListener});
}
