import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms of Use – SNAT Burial Scheme Mobile App',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Last updated: September 2026',
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            _heading('1. Acceptance of Terms'),
            const Text(
              'By accessing or using the SNAT Burial Scheme mobile application (“the App”), you agree to be bound by these Terms of Use. If you do not agree, please do not use the App.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),
            _heading('2. Purpose of the App'),
            const Text(
              'The App is provided exclusively for registered members of the SNAT Burial Scheme. It allows members to view their membership information, claims, and beneficiaries. The App is a digital companion to the official member portal at my.snatburialscheme.com.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),
            _heading('3. Membership & Eligibility'),
            const Text(
              'Access is restricted to active, registered members of the SNAT Burial Scheme. You must log in using the credentials linked to your membership. You are responsible for keeping your login details confidential.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),
            _heading('4. Accuracy of Information'),
            const Text(
              'While we strive to keep information accurate and up to date, the data displayed in the App is for convenience only. In case of any discrepancy, the official records held by SNAT Burial Scheme shall prevail. Please contact the scheme offices for any corrections.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),
            _heading('5. Claims, Benefits & Member Responsibility'),
            const Text(
              'Submitting or viewing claims through the App does not automatically guarantee payment. All claims remain subject to the scheme’s rules, waiting periods, and verification processes as determined by SNAT Burial Scheme.\n\n'
              'Registration and the addition of beneficiaries or members through the App (or any other channel) does not automatically mean that cover is active or in order. Members have a reciprocal duty to ensure that the amounts deducted (via stop order or other means) correctly match the number and details of registered beneficiaries. It remains each member’s responsibility to verify and, where necessary, update their deductions so that contributions stay aligned with their current membership.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),
            _heading('6. Privacy'),
            const Text(
              'We respect your privacy. Personal and membership data is handled in accordance with applicable data-protection practices. Information is used solely for the purpose of providing scheme-related services to members.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),
            _heading('7. Prohibited Use'),
            const Text(
              'You may not use the App for any unlawful purpose, attempt to gain unauthorised access, reverse-engineer the application, or share your login credentials with others.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),
            _heading('8. Limitation of Liability'),
            const Text(
              'SNAT Burial Scheme and its developers shall not be liable for any indirect, incidental, or consequential damages arising from the use of, or inability to use, the App. The App is provided “as is”.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),
            _heading('9. Changes to Terms'),
            const Text(
              'We may update these Terms from time to time. Continued use of the App after changes constitutes acceptance of the revised Terms.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 16),
            _heading('10. Contact'),
            const Text(
              'For questions regarding these Terms or the scheme, please visit:\n'
              '• www.snatburialscheme.com\n'
              '• my.snatburialscheme.com\n\n'
              'Or contact the SNAT Burial Scheme offices.',
              style: TextStyle(fontSize: 15, height: 1.5),
            ),
            const SizedBox(height: 28),
            const Divider(),
            const SizedBox(height: 12),
            Center(
              child: Text(
                '© SNAT Burial Scheme. All rights reserved.',
                style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _heading(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.blue[800],
        ),
      ),
    );
  }
}
