/// Base Model
/// All data models should extend this class
abstract class BaseModel {
  const BaseModel();

  Map<String, dynamic> toJson();

  @override
  String toString() {
    return '$runtimeType(${toJson()})';
  }
}
