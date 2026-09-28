import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../screens/otp_screen.dart';
import '../../../main_navigation.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _identifier;
  String? get identifier => _identifier;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    _isLoggedIn = token != null && token.isNotEmpty;
    notifyListeners();
  }

  Future<void> sendOtp(String id, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    _identifier = id;

    try {
      final res = await ApiClient().post('auth/send-otp', {'identifier': id});
      if (res.data['success']) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OtpScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> verifyOtp(String otp, BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      final res = await ApiClient().post('auth/verify-otp', {
        'identifier': _identifier,
        'otp': otp,
      });

      if (res.data['success']) {
        await ApiClient().setToken(res.data['data']['token']);
        _isLoggedIn = true;
        notifyListeners();

        // Navigate to Main Navigation (with bottom nav)
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const MainNavigation()),
          (route) => false,
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiClient().logout();
      _isLoggedIn = false;
      _identifier = null;
      notifyListeners();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
    _isLoading = false;
    notifyListeners();
  }
}
