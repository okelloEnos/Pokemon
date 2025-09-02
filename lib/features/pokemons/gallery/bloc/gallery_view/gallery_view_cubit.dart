import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

class GalleryViewCubit extends Cubit<ViewType> {
  GalleryViewCubit() : super(ViewType.grid);

  void toggleView(ViewType type) {
    emit(type);
  }
}

enum ViewType { list, grid }