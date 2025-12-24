import 'package:supabase_flutter/supabase_flutter.dart';

class AuthService {
  final SupabaseClient _client = Supabase.instance.client;

  // SIGN UP
  Future<String?> signUp(String email, String password) async {
    try {
      await _client.auth.signUp(
        email: email,
        password: password,
      );
      return null; // success
    } catch (e) {
      return e.toString();
    }
  }

  // LOGIN
  Future<String?> login(String email, String password) async {
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return null; // success
    } catch (e) {
      return e.toString();
    }
  }

  // LOGOUT (for later)
  Future<void> logout() async {
    await _client.auth.signOut();
  }
}
