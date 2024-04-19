import '../models/response.dart';

abstract class Repository<T> {
  Future<IResponse> getAll({String path = "", int page = 1});

  Future<IResponse> getAllByFilter(dynamic filter);
}
