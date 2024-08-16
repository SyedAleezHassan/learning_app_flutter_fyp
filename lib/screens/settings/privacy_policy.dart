import 'package:flutter/material.dart';
import 'package:flutter_application_1/color/color.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor.primaryColor,
        title: Text(
          "Privacy Policy",
          style: TextStyle(fontSize: 25, color: Colors.white),
        ),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section 1: Introduction
              Text(
                "Introduction",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: appColor.primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Welcome to [Your App Name]! We are committed to protecting your personal information and your right to privacy. This Privacy Policy explains how we collect, use, and safeguard your information when you use our application.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20),

              // Section 2: Information Collection
              Text(
                "Information We Collect",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: appColor.primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "We collect personal information that you voluntarily provide to us when you register on the application, express interest in obtaining information about us, or otherwise contact us.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "The personal information we collect may include the following:",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10),
              _buildBulletPoint(
                  "• Name and Contact Details (e.g., email address, phone number)"),
              _buildBulletPoint("• Profile Data (e.g., username, preferences)"),
              _buildBulletPoint("• Course Progress and Completion Records"),
              SizedBox(height: 20),

              // Section 3: Use of Information
              Text(
                "How We Use Your Information",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: appColor.primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "We use the information we collect or receive for the following purposes:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10),
              _buildBulletPoint(
                  "• To facilitate account creation and login processes"),
              _buildBulletPoint(
                  "• To send administrative information, such as updates to our terms and policies"),
              _buildBulletPoint(
                  "• To improve and personalize your learning experience"),
              _buildBulletPoint(
                  "• To deliver targeted advertisements and promotional offers"),
              SizedBox(height: 20),

              // Section 4: Sharing of Information
              Text(
                "Sharing of Your Information",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: appColor.primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "We may share your information with third-party vendors, service providers, contractors, or agents who perform services for us or on our behalf.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "We ensure that any third parties with whom we share your information are contractually obligated to protect your personal information.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20),

              // Section 5: Data Security
              Text(
                "Data Security",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: appColor.primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "We use administrative, technical, and physical security measures to help protect your personal information. However, no electronic transmission over the internet or information storage technology can be guaranteed to be 100% secure.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 20),

              // Section 6: Contact Us
              Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: appColor.primaryColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "If you have any questions or concerns about our Privacy Policy, please contact us at:",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 10),
              Text(
                "Email: support@yourappname.com\nPhone: +123 456 7890",
                style: TextStyle(
                  fontSize: 16,
                  color: appColor.primaryColor,
                  height: 1.5,
                ),
              ),
              SizedBox(height: 40),

              // Final Note
              Text(
                "Thank you for choosing [Your App Name]. We are committed to ensuring your privacy and security.",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBulletPoint(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "• ",
            style: TextStyle(fontSize: 16, color: Colors.black87),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 16, color: Colors.black87, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}
