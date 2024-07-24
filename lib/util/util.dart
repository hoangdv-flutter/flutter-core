import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_core/ext/string.dart';
import 'package:flutter_core/theme/app_theme.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../base_dialog.dart';

part 'conectivity/net_work_checker.dart';
part 'global_dialog/confirm_dialog.dart';
part 'constant.dart';
part 'crash_log.dart';
part 'debug_config.dart';
part 'dir_manager.dart';
part 'page_router_creator.dart';
part 'transition_helper.dart';
part 'math/polygon.dart';