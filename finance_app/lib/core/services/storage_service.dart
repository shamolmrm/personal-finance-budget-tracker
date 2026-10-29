import 'package:hive/hive.dart';

class StorageService {
  static final StorageService instance = StorageService._internal();

  StorageService._internal();

  Future<void> openBox(String name) async {
    await Hive.openBox(name);
  }

  Box? box(String name) => Hive.isBoxOpen(name) ? Hive.box(name) : null;
}
