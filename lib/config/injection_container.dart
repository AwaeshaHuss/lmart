import 'package:get_it/get_it.dart';
import 'package:lmart/config/providers/locale_provider.dart';
import 'package:lmart/config/providers/profile_provider.dart';

final GetIt sl = GetIt.I;

void init() async{

  //? Features

  //* Home
  //* Provider
  
  // sl.registerFactory(() => PostBloc(getAllPostsUseCase: sl()));
  sl.registerFactory(() => LocaleProvider());
  sl.registerFactory(() => ProfileProvider());

  //* UseCase

  // sl.registerLazySingleton(() => GetAllPostsUseCase(sl()));

  //* Repo

  // sl.registerLazySingleton<PostsReposetories>(() => PostReposetoriesImpl(postRemoteDataSource: sl()));

  //* Data Source

  // sl.registerLazySingleton<PostRemoteDataSource>(() => PostRemoteDataSourceHttpImpl());

  //* Auth
  //* Bloc

  // sl.registerFactory(() => AuthBloc(registerUserUseCase: sl(), loginUseCase: sl(), logOutUseCase: sl()));

  //* UseCase

  // sl.registerLazySingleton(() => RegisterUseCase(sl()));
  // sl.registerLazySingleton(() => LoginUseCase(sl()));
  // sl.registerLazySingleton(() => LogOutUseCase(sl()));

  //* Repo

  // sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()));

  //* DataSource

  // sl.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceHttpImpl());
}