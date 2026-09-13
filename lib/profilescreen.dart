import 'package:attendance_app/model/user.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isSigningOut = false;

  Future<void> _logout() async {
    final shouldLogout = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Log out?'),
        content: const Text('Your current session will be ended.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('CANCEL'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('LOG OUT'),
          ),
        ],
      ),
    );

    if (shouldLogout != true || !mounted) return;

    setState(() {
      _isSigningOut = true;
    });

    debugPrint('[LOGOUT] Starting logout');
    User.username = ' ';
    final sharedPreferences = await SharedPreferences.getInstance();
    await sharedPreferences.remove('employeeId');
    debugPrint('[LOGOUT] Local session cleared');
    await firebase_auth.FirebaseAuth.instance.signOut();
    debugPrint('[LOGOUT] Firebase signOut completed');
  }

  @override
  Widget build(BuildContext context) {
    final email = firebase_auth.FirebaseAuth.instance.currentUser?.email ??
        'Unknown email';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.account_circle, size: 96),
            const SizedBox(height: 16),
            Text(
              email,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 32),
            FilledButton.icon(
              onPressed: _isSigningOut ? null : _logout,
              icon: _isSigningOut
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.logout),
              label: Text(_isSigningOut ? 'LOGGING OUT...' : 'LOG OUT'),
            ),
          ],
        ),
      ),
    );
  }
}
