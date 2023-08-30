import 'package:flutter_bloc/flutter_bloc.dart';

class PageControllerCubit extends Cubit<int> {
  PageControllerCubit() : super(0);

  @override
  void onChange(Change<int> change) {
    super.onChange(change);
  }

  void selectPage(int pageIndex) async {
    emit(pageIndex);
  }
}

class PageAndMenuHolder {
  var pageIndex = 0;
  var menuItem = 0;
}
