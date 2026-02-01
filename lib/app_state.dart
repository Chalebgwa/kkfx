import 'package:firebase_auth/firebase_auth.dart';

class AppState {
  // Your app will use this to know when to display loading spinners.
  bool isLoading;
  User? user;

  // Constructor
  AppState({
    this.isLoading = false,
  });

  // A constructor for when the app is loading.
  factory AppState.loading() => AppState(isLoading: true);

  @override
  String toString() {
    return 'AppState{isLoading: $isLoading, user: ${user?.displayName ?? 'null'}}';
  }
}