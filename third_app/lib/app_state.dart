// app_state.dart

class AppState {
  static String occupation = ''; // Your global variable

  // Singleton pattern
  static final AppState _instance = AppState._internal();

  factory AppState() {
    return _instance;
  }

  AppState._internal();
}
