import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/di/injection_container.dart';
import 'core/theme/app_theme.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'features/home/presentation/pages/home_page.dart';

class ShoppingStoreApp extends StatelessWidget {
  const ShoppingStoreApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<HomeCubit>(),
      child: MaterialApp(
        title: 'LUXE',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.active,
        home: const HomePage(),
      ),
    );
  }
}
