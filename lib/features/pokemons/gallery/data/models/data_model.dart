import 'package:equatable/equatable.dart';
import 'package:pokemon/features/pokemons/gallery/domain/entities/data_entity.dart';

class DataModel extends DataEntity {

  const DataModel({String? name, String? url}) : super(name: name, url: url);

  factory DataModel.fromJson(Map<String, dynamic> json) {
    return DataModel(
      name: json['name'] as String?,
      url: json['url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'url': url,
    };
  }

  factory DataModel.fromEntity({DataEntity? entity}) {
    return DataModel(
      name: entity?.name,
      url: entity?.url,
    );
  }
}
