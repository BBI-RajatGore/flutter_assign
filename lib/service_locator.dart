// import 'dart:io';
// import 'package:get_it/get_it.dart';
// import 'package:news_app_clean_archi/data/data_sources/news_remote_data_source.dart';
// import 'package:news_app_clean_archi/data/repository/news_repository_impl.dart';
// import 'package:news_app_clean_archi/domain/repository/news_repository.dart';
// import 'package:news_app_clean_archi/domain/usecase/fetch_news.dart';
// import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
// import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
// import 'package:news_app_clean_archi/core/theme/theme_manager.dart'; // Make sure you import ThemeManager
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';

// final getIt = GetIt.instance;

// Future<void> initServiceLocator() async {


//   final sharedPreferences = await SharedPreferences.getInstance();
  


//   // Register ThemeManager with the instance of SharedPreferences
//   getIt.registerLazySingleton<ThemeManager>(
//     () => ThemeManager(sharedPreferences: sharedPreferences),
//   );

//   // Register dependencies for lazy singleton
//   getIt.registerLazySingleton<NewsRemoteDataSource>(
//     () => NewsRemoteDataSourceImpl(
//       client: http.Client(),
//     ),
//   );

//   getIt.registerLazySingleton<NewsRepository>(
//     () => NewsRepositoryImpl(
//       newsRemoteDataSource: getIt(),
//     ),
//   );

//   getIt.registerLazySingleton<FetchNews>(
//     () => FetchNews(
//       newsRepository: getIt(),
//     ),
//   );

//   // Register NewsBloc as factory since each page might have its own events and states
//   getIt.registerFactory<NewsBloc>(
//     () => NewsBloc(
//       fetchNews: getIt(),
//     ),
//   );

//   // Register ThemeCubit, passing ThemeManager
//   getIt.registerLazySingleton<ThemeCubit>(
//     () => ThemeCubit(themeManager: getIt()),
//   );
// }



import 'dart:io';
import 'package:get_it/get_it.dart';
import 'package:news_app_clean_archi/data/data_sources/news_remote_data_source.dart';
import 'package:news_app_clean_archi/data/repository/news_repository_impl.dart';
import 'package:news_app_clean_archi/domain/repository/news_repository.dart';
import 'package:news_app_clean_archi/domain/usecase/fetch_news.dart';
import 'package:news_app_clean_archi/presentation/bloc/news_bloc.dart';
import 'package:news_app_clean_archi/presentation/cubit/theme_cubit.dart';
import 'package:news_app_clean_archi/core/theme/theme_manager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

Future<void> initServiceLocator() async {

  // Initialize shared preferences asynchronously
  final sharedPreferences = await SharedPreferences.getInstance();

  final client = http.Client();

  // Register dependencies with GetIt
  getIt.registerLazySingleton<ThemeManager>(
    () => ThemeManager(sharedPreferences: sharedPreferences),
  );

  // Register other services
  getIt.registerLazySingleton<NewsRemoteDataSource>(
    () => NewsRemoteDataSourceImpl(client: client),
  );

  getIt.registerLazySingleton<NewsRepository>(
    () => NewsRepositoryImpl(newsRemoteDataSource: getIt()),
  );

  getIt.registerLazySingleton<FetchNews>(
    () => FetchNews(newsRepository: getIt()),
  );

  getIt.registerFactory<NewsBloc>(
    () => NewsBloc(fetchNews: getIt()),
  );

  // Register ThemeCubit
  getIt.registerLazySingleton<ThemeCubit>(
    () => ThemeCubit(themeManager: getIt()),
  );
}
