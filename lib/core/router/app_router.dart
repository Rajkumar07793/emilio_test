import 'package:emilio_test/blocs/auth/auth_bloc.dart';
import 'package:emilio_test/blocs/auth/auth_state.dart';
import 'package:emilio_test/blocs/profile/profile_bloc.dart';
import 'package:emilio_test/blocs/profile/profile_event.dart';
import 'package:emilio_test/blocs/profile/profile_state.dart';
import 'package:emilio_test/data/models/product_model.dart';
import 'package:emilio_test/data/models/user_model.dart';
import 'package:emilio_test/presentation/screens/admin/active_products_screen.dart';
import 'package:emilio_test/presentation/screens/admin/admin_dashboard_screen.dart';
import 'package:emilio_test/presentation/screens/admin/create_seller_screen.dart';
import 'package:emilio_test/presentation/screens/admin/seller_list_screen.dart';
import 'package:emilio_test/presentation/screens/auth/admin_register_screen.dart';
import 'package:emilio_test/presentation/screens/auth/login_screen.dart';
import 'package:emilio_test/presentation/screens/seller/product_form_screen.dart';
import 'package:emilio_test/presentation/screens/seller/profile_setup_screen.dart';
import 'package:emilio_test/presentation/screens/seller/seller_dashboard_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(
          builder: (_) => const AuthGuard(child: LoginScreen()),
        );
      case '/register':
        return MaterialPageRoute(builder: (_) => const AdminRegisterScreen());
      case '/admin/dashboard':
        return MaterialPageRoute(
          builder: (_) => const RoleGuard(
            allowedRole: UserRole.admin,
            child: AdminDashboardScreen(),
          ),
        );
      case '/admin/create-seller':
        return MaterialPageRoute(
          builder: (_) => const RoleGuard(
            allowedRole: UserRole.admin,
            child: CreateSellerScreen(),
          ),
        );
      case '/admin/seller-list':
        return MaterialPageRoute(
          builder: (_) => const RoleGuard(
            allowedRole: UserRole.admin,
            child: SellerListScreen(),
          ),
        );
      case '/admin/active-products':
        return MaterialPageRoute(
          builder: (_) => const RoleGuard(
            allowedRole: UserRole.admin,
            child: ActiveProductsScreen(),
          ),
        );
      case '/seller/dashboard':
        return MaterialPageRoute(
          builder: (_) => const RoleGuard(
            allowedRole: UserRole.seller,
            child: ProfileCheckGuard(child: SellerDashboardScreen()),
          ),
        );
      case '/seller/profile-setup':
        return MaterialPageRoute(
          builder: (_) => const RoleGuard(
            allowedRole: UserRole.seller,
            child: ProfileSetupScreen(),
          ),
        );
      case '/seller/product-form':
        final product = settings.arguments as ProductModel?;
        return MaterialPageRoute(
          builder: (_) => RoleGuard(
            allowedRole: UserRole.seller,
            child: ProductFormScreen(product: product),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Page not found'))),
        );
    }
  }

  static String getInitialRoute(AuthState authState) {
    if (authState is AuthAuthenticated) {
      if (authState.user.role == UserRole.admin) {
        return '/admin/dashboard';
      } else {
        return '/seller/dashboard';
      }
    }
    return '/';
  }
}

// Auth Guard - redirects authenticated users
class AuthGuard extends StatelessWidget {
  final Widget child;

  const AuthGuard({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final route = AppRouter.getInitialRoute(state);
          Navigator.pushReplacementNamed(context, route);
        }
      },
      child: child,
    );
  }
}

// Role Guard - ensures user has correct role
class RoleGuard extends StatelessWidget {
  final UserRole allowedRole;
  final Widget child;

  const RoleGuard({super.key, required this.allowedRole, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is! AuthAuthenticated) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(context, '/');
          });
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.user.role != allowedRole) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacementNamed(
              context,
              AppRouter.getInitialRoute(state),
            );
          });
          return const Scaffold(body: Center(child: Text('Access Denied')));
        }

        return child;
      },
    );
  }
}

// Profile Check Guard - ensures seller has completed profile
class ProfileCheckGuard extends StatefulWidget {
  final Widget child;

  const ProfileCheckGuard({super.key, required this.child});

  @override
  State<ProfileCheckGuard> createState() => _ProfileCheckGuardState();
}

class _ProfileCheckGuardState extends State<ProfileCheckGuard> {
  @override
  void initState() {
    super.initState();
    _checkProfile();
  }

  void _checkProfile() {
    final authState = context.read<AuthBloc>().state;
    if (authState is AuthAuthenticated) {
      context.read<ProfileBloc>().add(
        LoadProfileEvent(sellerId: authState.user.id),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileLoaded && state.profile == null) {
          Navigator.pushReplacementNamed(context, '/seller/profile-setup');
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading || state is ProfileInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileLoaded && state.profile != null) {
          return widget.child;
        }

        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      },
    );
  }
}
