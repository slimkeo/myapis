import 'package:flutter/material.dart';

class AboutBurialScreen extends StatelessWidget {
  const AboutBurialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(title: const Text('About SNAT Burial'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                'assets/logo.png',
                height: 120,
                width: 120,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 16),
            const Center(
              child: Text(
                'SNAT Burial Scheme',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'Supporting Teachers & Families',
                style: TextStyle(fontSize: 15, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            _sectionTitle('Who We Are'),
            const Text(
              'The SNAT Burial Scheme was established in 2003 to provide financial relief, dignity, and compassionate support to teachers and their families during bereavement.\n\n'
              'For over 20 years we have served thousands of teachers across Eswatini with affordable contributions and reliable benefits, ensuring every member and their loved ones receive dignified support when it matters most.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Our Mission'),
            const Text(
              'To give peace of mind during life’s most difficult moments by offering reliable burial cover, funeral support, and assistance to SNAT members and their immediate families.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),
            _sectionTitle('Who Can Join'),
            const Text(
              'Primarily for Teachers under SNAT, and for SNAT members employed in schools within Eswatini and affiliated SNAT insitutions employees are eligible to join the scheme.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),
            _sectionTitle('What We Cover'),
            const Text(
              '• Funeral arrangements and support\n'
              '• Transport assistance\n'
              '• Documentation assistance\n'
              '• Support for registered beneficiaries during bereavement',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 20),
            _sectionTitle('How the App Helps'),
            const Text(
              'This mobile app allows registered members to securely view their membership information, claims history, and list of beneficiaries. It is the official companion to the member portal at my.snatburialscheme.com.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 12),
            Center(
              child: Text(
                'Visit us online',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'www.snatburialscheme.com',
                style: TextStyle(fontSize: 14, color: Colors.blue[700]),
              ),
            ),
            Center(
              child: Text(
                'my.snatburialscheme.com',
                style: TextStyle(fontSize: 14, color: Colors.blue[700]),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Colors.blue[800],
        ),
      ),
    );
  }
}
