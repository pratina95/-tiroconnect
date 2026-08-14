import 'package:flutter_bloc/flutter_bloc.dart';

class AppBlocObserver extends BlocObserver {
  @override
  void onCreate(BlocBase bloc) {
    super.onCreate(bloc);
    // Add logging for BLoC creation
  }

  @override
  void onClose(BlocBase bloc) {
    super.onClose(bloc);
    // Add logging for BLoC closing
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    // Add logging for BLoC changes
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    // Add error logging
    super.onError(bloc, error, stackTrace);
  }
}
