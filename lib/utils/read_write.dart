import 'dart:convert';
import 'dart:io';

import 'package:flutter_testing/models/user.dart';
import 'package:path_provider/path_provider.dart';

Future<String> get localPath async {
  final directory = await getApplicationDocumentsDirectory();

  return directory.path;
}

Future<File> get localFile async {
  final path = await localPath;
  return File('$path/flutter_expense_tracker.txt');
}

Future<File> writeJsonToFile(String json) async {
  final file = await localFile;

  return file.writeAsString(json);
}

Future<String> readJsonFromFile() async {
  try {
    final file = await localFile;

    // Read the file
    final contents = await file.readAsString();

    return contents;
  } catch (e) {
    rethrow;
  }
}

void save(UserModel userModel) {
  writeJsonToFile(jsonEncode(userModel));
}

Future<UserModel> load() async {
  final userModelMap = jsonDecode(await readJsonFromFile()) as Map<String, dynamic>;
  final userModel = UserModel.fromJson(userModelMap);

  return userModel;
}