import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'features/dashboard/screens/dashboard_screen.dart';
import 'features/claims/screens/claims_screen.dart';
import 'features/beneficiaries/screens/beneficiaries_screen.dart';
import 'features/subscriptions/screens/subscriptions_screen.dart';
import 'features/auth/providers/auth_provider.dart';
import 'core/constants/app_constants.dart';

// Adjust these import paths to match your project structure
import 'features/about/screens/about_burial.dart'; // → AboutBurialScreen (or whatever the class is named)
import 'features/about/screens/terms.dart'; // → TermsScreen
import 'features/about/screens/about_app.dart'; // → AboutAppScreen

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),
    ClaimsScreen(),
    BeneficiariesScreen(),
    SubscriptionsScreen(),
  ];

  void _logout(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext);
              context.read<AuthProvider>().logout();
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _shareApp() async {
    // ← put your real Play Store / App Store / website URL here
    const appLink =
        'https://play.google.com/store/apps/details?id=com.your.package';

    await Clipboard.setData(const ClipboardData(text: appLink));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('App link copied to clipboard'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _onMenuSelected(String value) {
    switch (value) {
      case 'about_burial':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AboutBurialScreen(),
          ), // adjust class name if needed
        );
        break;
      case 'share':
        _shareApp();
        break;
      case 'terms':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const TermsScreen(),
          ), // adjust class name if needed
        );
        break;
      case 'about_app':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const AboutAppScreen(),
          ), // adjust class name if needed
        );
        break;
      case 'logout':
        _logout(context);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = AppConstants.navItems[_currentIndex]['label'] as String;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            tooltip: 'More options',
            onSelected: _onMenuSelected,
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'about_burial',
                child: Text('About SNAT Burial'),
              ),
              const PopupMenuItem(value: 'share', child: Text('Share App')),
              const PopupMenuItem(value: 'terms', child: Text('Terms')),
              const PopupMenuItem(value: 'about_app', child: Text('About App')),
              const PopupMenuDivider(),
              const PopupMenuItem(
                value: 'logout',
                child: Text('Logout', style: TextStyle(color: Colors.red)),
              ),
            ],
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[600],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600),
        items: AppConstants.navItems.map((item) {
          return BottomNavigationBarItem(
            icon: Icon(item['icon'] as IconData),
            label: item['label'] as String,
          );
        }).toList(),
      ),
    );
  }
}
