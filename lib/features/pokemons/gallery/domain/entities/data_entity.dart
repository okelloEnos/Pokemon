import 'package:equatable/equatable.dart';
import '../../../../features_barrel.dart';

class DataEntity extends Equatable{
  final String? name;
  final String? url;

  const DataEntity({this.name, this.url});

  @override
  List<Object?> get props => [name, url];

  // copy method
  DataEntity copyWith({String? name, String? url}) {
    return DataEntity(
      name: name ?? this.name,
      url: url ?? this.url,
    );
  }

  // from model to entity
  factory DataEntity.fromModel(DataModel model) {
    return DataEntity(
      name: model.name,
      url: model.url,
    );
  }
}