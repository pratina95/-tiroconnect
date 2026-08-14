part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {
  final ThemeMode themeMode;

  const ThemeState({required this.themeMode});

  @override
  List<Object> get props => [themeMode];
}

class ThemeInitial extends ThemeState {
  const ThemeInitial() : super(themeMode: ThemeMode.system);
}

class ThemeLoaded extends ThemeState {
  const ThemeLoaded({required super.themeMode});
}
