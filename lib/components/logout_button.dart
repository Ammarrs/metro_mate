// lib/components/logout_button.dart
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  final VoidCallback? onLogout;
  
  const LogoutButton({
    Key? key,
    this.onLogout,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5F5), // Light pink background
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _handleLogout(context),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.logout,
                  color: Color(0xFFEF4444), // Red color
                  size: 20,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Log Out',
                  style: TextStyle(
                    color: Color(0xFFEF4444),
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    // Call custom callback if provided
    if (onLogout != null) {
      onLogout!();
    }
    
    // Clear token and navigate
    await _clearToken();
    _navigateToLogin(context);
  }

  Future<void> _clearToken() async {
    // Clear token from storage (implement based on your storage method)
    // Examples shown in Step 2
  }

  void _navigateToLogin(BuildContext context) {
    // Navigate to login and clear navigation stack
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    );
  }
}