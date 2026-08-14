import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tiroconnect/src/core/theme/app_theme.dart';
import 'package:tiroconnect/src/core/routes/app_router.dart';
import 'package:tiroconnect/src/core/bloc/theme/theme_bloc.dart';

class TiroConnectAppView extends StatelessWidget {
  const TiroConnectAppView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp.router(
          title: 'TiroConnect',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          routerConfig: AppRouter.router,
          localizationsDelegates: const [
            // Add localization delegates
          ],
          supportedLocales: const [
            Locale('en', 'US'),
            Locale('en', 'BW'), // Botswana English
          ],
        );
      },
    );
  }
}
