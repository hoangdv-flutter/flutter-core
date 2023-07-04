import 'package:flutter/material.dart';
import 'package:flutter_core/base_dialog.dart';
import 'package:flutter_core/ext/string.dart';
import 'package:flutter_core/theme/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ConfirmDialog extends BaseDialogStateless {
  final String? title;

  final String? message;

  final MenuButton? negativeButton;

  final MenuButton? positiveButton;

  const ConfirmDialog(
      {super.key,
      this.title,
      this.message,
      this.negativeButton,
      this.positiveButton,
      required super.rootContext});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.w),
            width: 80.w,
            decoration: BoxDecoration(
                color: appColor.colorWhite,
                borderRadius: BorderRadius.circular(6.w)),
            child: Column(
              children: [
                if (!title.isNullOrEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      title!,
                      style: TextStyle(
                          color: appColor.colorBlack, fontSize: 17.sp),
                    ),
                  ),
                if (!message.isNullOrEmpty)
                  SizedBox(
                    width: double.infinity,
                    child: Text(
                      message!,
                      style:
                          TextStyle(color: appColor.colorGrey, fontSize: 17.sp),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    if (negativeButton != null)
                      TextButton(
                          onPressed: () {
                            negativeButton?.clickListener?.call();
                            dismissDialog();
                          },
                          child: Text(
                            negativeButton?.title ?? "",
                            style: TextStyle(
                                color: appColor.colorBlack, fontSize: 17.sp),
                          )),
                    SizedBox(
                      width: 4.w,
                    ),
                    if (positiveButton != null)
                      TextButton(
                          onPressed: () {
                            positiveButton?.clickListener?.call();
                            dismissDialog();
                          },
                          child: Text(
                            positiveButton?.title ?? "",
                            style: TextStyle(fontSize: 17.sp),
                          ))
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}

class MenuButton {
  final String? title;
  final Function()? clickListener;

  MenuButton({this.title, this.clickListener});
}
