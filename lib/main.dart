import 'package:ecoparkdesktop/pages/login.dart';
import 'package:ecoparkdesktop/repositories/auth_repository.dart';
import 'package:ecoparkdesktop/services/auth_service.dart';
import 'package:ecoparkdesktop/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<StorageService>(() => StorageService());
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository(getIt()));
  getIt.registerLazySingleton<AuthService>(() => AuthService(getIt()));
}

void main() {
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
  return const MaterialApp(
    home: Login(),
  );
}
}