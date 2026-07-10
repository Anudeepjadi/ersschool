import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb) {
      return const SizedBox.shrink();
    }

    String currentYear = DateFormat('yyyy').format(DateTime.now());
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 16,
        runSpacing: 8,
        children: [
          const Text(
            "V.6.0 Developed by Ecstasy Consulting And Solutions Pvt Ltd.",
            style: TextStyle(fontSize: 10, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          Text(
            "Copyright © $currentYear All rights reserved",
            style: const TextStyle(fontSize: 10, color: Colors.black54),
            textAlign: TextAlign.center,
          ),
          Wrap(
            alignment: WrapAlignment.center,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Text("Please visit ", style: TextStyle(fontSize: 10, color: Colors.black54)),
              GestureDetector(
                onTap: () => _launchURL("https://ecstasysolutions.org"),
                child: const Text(
                  "ecstasysolutions.org",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const Text(" for details", style: TextStyle(fontSize: 10, color: Colors.black54)),
            ],
          ),
        ],
      ),
    );
  }
}
