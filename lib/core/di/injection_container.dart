import 'package:get_it/get_it.dart';
import '../../features/home/data/home_mock_data.dart';
import '../../features/home/presentation/cubit/home_cubit.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerFactory(() => HomeCubit(mockData: sl()));
  sl.registerLazySingleton(() => HomeMockData());
}
