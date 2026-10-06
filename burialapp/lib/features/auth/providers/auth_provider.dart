import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/network/api_client.dart';
import '../../../shared/models/user_model.dart';
import '../screens/otp_screen.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  String? _identifier;
  String? get identifier => _identifier;

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  UserModel? _member;
  UserModel? get member => _member;

  String? _nominee;
  String? get nominee => _nominee;

  AuthProvider() {
    ApiClient().onUnauthorized = _handleUnauthorized;
    _checkLoginStatus();
  }

  void _handleUnauthorized() {
    _isLoggedIn = false;
    _member = null;
    notifyListeners();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    _isLoggedIn = token != null && token.isNotEmpty;

    final memberJson = prefs.getString('member');
    if (memberJson != null && memberJson.isNotEmpty) {
      try {
        _member = UserModel.fromJson(jsonDecode(memberJson));
      } catch (_) {
        await prefs.remove('member');
      }
    }

    _isInitialized = true;
    notifyListeners();
  }

  Future<void> _persistMember(UserModel? member) async {
    final prefs = await SharedPreferences.getInstance();
    if (member == null) {
      await prefs.remove('member');
      return;
    }
    await prefs.setString(
      'member',
      jsonEncode({
        'id': member.id,
        'surname': member.surname,
        'name': member.name,
        'cellnumber': member.cellnumber,
        'idnumber': member.idnumber,
        'passbook_no': member.passbookNo,
      }),
    );
  }

  Future<void> sendOtp(String id, BuildContext context) async {
    _isLoading = true;
    notifyListeners();
    _identifier = id.trim();

    try {
      final res = await ApiClient().post('auth/send-otp', {
        'identifier': _identifier,
      });
      if (res.data['success'] == true && context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const OtpScreen()),
        );
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res.data['message']?.toString() ?? 'Failed to send OTP',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ApiClient.errorMessage(e)),
            backgroundColor: Colors.red,
          ),
        );
      }
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
        'otp': otp.trim(),
      });

      if (res.data['success'] == true) {
        final data = res.data['data'] as Map<String, dynamic>;
        await ApiClient().setToken(data['token'] as String);

        if (data['member'] != null) {
          _member = UserModel.fromJson(
            Map<String, dynamic>.from(data['member'] as Map),
          );
          await _persistMember(_member);
          if (data['nominee'] != null) {
            _nominee = data['nominee']?.toString() ?? '';
          }
        }

        _isLoggedIn = true;
        notifyListeners();

        // Return to AuthCheckScreen root; it will show MainNavigation.
        if (context.mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      } else if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res.data['message']?.toString() ?? 'Verification failed',
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(ApiClient.errorMessage(e)),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiClient().logout();
      await _persistMember(null);
      _isLoggedIn = false;
      _member = null;
      _identifier = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
