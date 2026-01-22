import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/product/product_bloc.dart';
import 'blocs/profile/profile_bloc.dart';
import 'blocs/seller/seller_bloc.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';
import 'data/models/product_model.dart';
import 'data/models/seller_profile_model.dart';
import 'data/models/user_model.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/product_repository.dart';
import 'data/repositories/seller_profile_repository.dart';
import 'data/repositories/user_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Register Hive Adapters
  Hive.registerAdapter(UserModelAdapter());
  Hive.registerAdapter(UserRoleAdapter());
  Hive.registerAdapter(SellerProfileModelAdapter());
  Hive.registerAdapter(ProductModelAdapter());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize repositories
    final authRepository = AuthRepository();
    final userRepository = UserRepository();
    final profileRepository = SellerProfileRepository();
    final productRepository = ProductRepository();

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: authRepository),
        RepositoryProvider.value(value: userRepository),
        RepositoryProvider.value(value: profileRepository),
        RepositoryProvider.value(value: productRepository),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                AuthBloc(authRepository: authRepository)..add(CheckAuthEvent()),
          ),
          BlocProvider(
            create: (context) => SellerBloc(userRepository: userRepository),
          ),
          BlocProvider(
            create: (context) =>
                ProfileBloc(profileRepository: profileRepository),
          ),
          BlocProvider(
            create: (context) =>
                ProductBloc(productRepository: productRepository),
          ),
        ],
        child: MaterialApp(
          title: 'Multi-Role App',
          theme: AppTheme.lightTheme,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: '/',
        ),
      ),
    );
  }
}
