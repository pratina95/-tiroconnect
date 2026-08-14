import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiroconnect/src/app.dart';
import 'package:tiroconnect/src/core/di/injection.dart';
import 'package:tiroconnect/src/core/utils/app_bloc_observer.dart';
import 'package:tiroconnect/src/core/bloc/theme/theme_bloc.dart';
import 'package:tiroconnect/src/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize dependency injection
  await configureDependencies();

  // Set up BLoC observer for debugging
  Bloc.observer = AppBlocObserver();

  runApp(const TiroConnectApp());
}

class TiroConnectApp extends StatelessWidget {
  const TiroConnectApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => ThemeBloc(),
        ),
        BlocProvider(
          create: (_) => getIt<AuthBloc>(),
        ),
      ],
      child: const TiroConnectAppView(),
    );
  }
}
