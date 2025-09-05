import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pokemon/core/core_barrel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GalleryViewCubit extends Cubit<ViewType> {
  GalleryViewCubit() : super(ViewType.grid){
    ViewType type;
    String? view = locator<SharedPreferences>().get("view_type") as String?;
    if (view == null || view.trim().toLowerCase() == "grid") {
      type = ViewType.grid;
    } else {
      type = ViewType.list;
    }
    emit(type);
  }

  void toggleView(ViewType type) {
    String? view;
    if(type == ViewType.grid){
      view = "grid";
    }
    else{
      view = "list";
    }

    locator<SharedPreferences>().setString("view_type", view);
    emit(type);
  }
}

enum ViewType { list, grid }