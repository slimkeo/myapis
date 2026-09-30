import 'package:flutter/material.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('About the App'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(
                Icons.phone_android,
                size: 64,
                color: Colors.blue[700],
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'SNAT Burial Scheme App',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Official Member Mobile Application',
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 28),
            _infoCard(
              icon: Icons.info_outline,
              title: 'About This App',
              content:
                  'This application allows registered members of the SNAT Burial Scheme to securely access their membership details, view claims, and manage beneficiaries on the go.\n\n'
                  'It is the official mobile companion to the member portal available at my.snatburialscheme.com.',
            ),
            const SizedBox(height: 16),
            _infoCard(
              icon: Icons.language,
              title: 'Official Websites',
              content:
                  'Main website:\nwww.snatburialscheme.com\n\n'
                  'Member portal (mirror):\nmy.snatburialscheme.com',
            ),
            const SizedBox(height: 16),
            _infoCard(
              icon: Icons.person,
              title: 'Development',
              content:
                  'Developed by IT Specialist\nSicelo Thabani Hlanze\n\n'
                  'Built for the SNAT Burial Scheme to serve its members with convenient digital access to their information.',
            ),
            const SizedBox(height: 16),
            _infoCard(
              icon: Icons.copyright,
              title: 'Copyright',
              content:
                  '© SNAT Burial Scheme. All rights reserved.\n\n'
                  'This application and its content are the property of SNAT Burial Scheme. Unauthorised reproduction or distribution is prohibited.',
            ),
            const SizedBox(height: 32),
            Center(
              child: Text(
                'Caring for Teachers Since 2003',
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Peace of Mind During Life’s Difficult Moments',
                style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.blue[700], size: 28),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    content,
                    style: const TextStyle(fontSize: 14.5, height: 1.45),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
