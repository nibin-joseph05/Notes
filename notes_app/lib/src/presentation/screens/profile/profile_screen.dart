import 'package:flutter/material.dart';
import '../../widgets/common/app_background.dart';
import '../../widgets/common/info_bottom_sheet.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Account"), elevation: 0),
      body: Stack(
        children: [
          const AppBackground(),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                final isTablet = width >= 700;
                final isDesktop = width >= 1100;
                
                final double maxContentWidth = isDesktop ? 900 : isTablet ? 750 : width;
                final double horizontalPadding = width >= 1100 ? width * 0.12 : width >= 700 ? width * 0.08 : width * 0.045;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxContentWidth),
                    child: Column(
                      children: [
                        Expanded(
                          child: ListView(
                            padding: EdgeInsets.symmetric(
                              horizontal: horizontalPadding,
                              vertical: isTablet ? 26 : 18,
                            ),
                            children: [
                        _buildDeveloperCard(isWide: width > 540, context: context),
                        SizedBox(height: isTablet ? 30 : 22),
                        _buildSectionCard(
                          title: "Legal & Policies",
                          icon: Icons.gavel_rounded,
                          isWide: width > 540,
                          children: [
                            _buildListTile(
                              title: "Privacy Policy",
                              icon: Icons.privacy_tip_outlined,
                              onTap: () => InfoBottomSheet.show(context, title: "Privacy Policy", children: _privacyPolicyContent()),
                            ),
                            _buildListTile(
                              title: "Terms & Conditions",
                              icon: Icons.description_outlined,
                              onTap: () => InfoBottomSheet.show(context, title: "Terms of Use", children: _termsContent()),
                            ),
                            _buildListTile(
                              title: "Open Source Licenses",
                              icon: Icons.code_rounded,
                              onTap: () => showLicensePage(
                                context: context,
                                applicationName: "AiBi Notes",
                                applicationLegalese: "© ABN",
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: isTablet ? 30 : 22),
                        _buildSectionCard(
                          title: "Support",
                          icon: Icons.help_outline_rounded,
                          isWide: width > 540,
                          children: [
                            _buildListTile(
                              title: "Contact Support",
                              icon: Icons.mail_outline_rounded,
                              onTap: () => InfoBottomSheet.show(context, title: "Contact Support", children: _contactContent()),
                            ),
                            _buildListTile(
                              title: "Rate App",
                              icon: Icons.star_outline_rounded,
                              onTap: () => InfoBottomSheet.show(context, title: "Rate App", children: _rateAppContent()),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SafeArea(
                    top: false,
                    child: _footerInfo(fontSize: isTablet ? 14 : 12),
                  ),
                ],
              ),
            ),
          );
        },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDeveloperCard({required bool isWide, required BuildContext context}) {
    return GestureDetector(
      onTap: () => InfoBottomSheet.show(context, title: "© ABN", children: _aboutContent()),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.fromLTRB(
          isWide ? 28 : 22,
          isWide ? 22 : 20,
          isWide ? 28 : 22,
          isWide ? 30 : 24,
        ),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.42),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: isWide ? 32 : 28,
              backgroundColor: Colors.transparent,
              backgroundImage: const AssetImage('assets/logo/abn-logo.png'),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "© ABN",
                    style: TextStyle(
                      fontSize: isWide ? 22 : 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Engineered for Efficiency. Designed for Impact.",
                    style: TextStyle(
                      fontSize: isWide ? 13 : 11,
                      color: Colors.white.withOpacity(0.7),
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required bool isWide,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
              isWide ? 28 : 22,
              isWide ? 22 : 18,
              isWide ? 28 : 22,
              12,
            ),
            child: Row(
              children: [
                Icon(icon, color: Colors.blueAccent.withOpacity(0.8), size: 22),
                const SizedBox(width: 12),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ...children.map((child) => Padding(padding: const EdgeInsets.only(bottom: 12, left: 16, right: 16), child: child)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildListTile({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.07),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white24),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white70, size: 22),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white38, size: 16),
          ],
        ),
      ),
    );
  }

  Widget _heading(String text) => Padding(
        padding: const EdgeInsets.only(top: 24, bottom: 8),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
      );

  Widget _body(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          text,
          textAlign: TextAlign.justify,
          style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15, height: 1.5),
        ),
      );

  Widget _bullet(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8, left: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("• ", style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15, height: 1.5)),
            Expanded(
              child: Text(
                text,
                textAlign: TextAlign.justify,
                style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 15, height: 1.5),
              ),
            ),
          ],
        ),
      );

  List<Widget> _privacyPolicyContent() {
    return [
      _body("Your privacy is important.\n\nNotes is designed with a privacy-first approach. Your notes remain under your control."),
      _heading("Information We Collect"),
      _bullet("Notes you create"),
      _bullet("App preferences and settings"),
      _bullet("Images and audio recordings that you choose to attach"),
      _heading("What We Don't Collect"),
      _bullet("We do not sell your personal information."),
      _bullet("We do not access your notes without your permission."),
      _bullet("We do not collect unnecessary personal information."),
      _heading("Storage"),
      _body("Notes are stored locally on your device. If cloud synchronization is enabled, encrypted communication is used to synchronize your content with the backend service."),
      _heading("Permissions"),
      _body("The app may request permission to access:"),
      _bullet("Camera"),
      _bullet("Photo Gallery"),
      _bullet("Microphone"),
      _bullet("Notifications"),
      _body("These permissions are only used for features you choose to use."),
      _heading("Contact"),
      _body("For privacy-related questions:\nnibin.joseph.career@gmail.com"),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _termsContent() {
    return [
      _body("By using Notes, you agree to use the application responsibly."),
      _heading("User Responsibilities"),
      _bullet("You are responsible for any content you create and store within the application."),
      _bullet("You may not use the application for illegal, harmful, or abusive activities."),
      _heading("Disclaimers"),
      _bullet("While every effort is made to provide a reliable experience, the application is provided \"as is\" without warranties of any kind."),
      _bullet("Features may change, improve, or be discontinued without prior notice."),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _contactContent() {
    return [
      _body("Need help or have suggestions?\nI'd love to hear from you."),
      _heading("Support Email"),
      _body("nibin.joseph.career@gmail.com"),
      _heading("Response Time"),
      _bullet("Typical response time: 24–48 hours"),
      const SizedBox(height: 24),
    ];
  }

  List<Widget> _aboutContent() {
  return [
    _heading("Who We Are"),
    _body(
      "ABN is a premier independent software developer dedicated to crafting "
      "thoughtfully engineered, ultra-high-performance digital solutions. We specialize "
      "in transforming complex workflows into seamless, everyday productivity and automation tools."
    ),
    
    _heading("Our Core Principles"),
    _bullet("User-Centric & Intentional Design – Clean, intuitive user experiences that eliminate friction."),
    _bullet("High-Performance Engineering – Robust, reliable execution optimized for speed and scale."),
    _bullet("Modern & Adaptive Architecture – Scalable, maintainable, and cutting-edge codebases."),
    _bullet("Privacy & Security First – Built with rock-solid security protocols and data integrity by design."),
    
    _heading("Technical Focus Areas"),
    _bullet("Cross-Platform Mobile Apps – High-fidelity, fluid user interfaces built for modern platforms."),
    _bullet("Distributed Backend Systems – Enterprise-grade, resilient cloud APIs and microservices."),
    _bullet("Intelligent AI & Automation – Streamlining operations using NLP, smart data analysis, and process automation."),
    _bullet("End-to-End Full-Stack Solutions – Comprehensive, production-ready systems from concept to deployment."),
    
    const SizedBox(height: 32),
  ];
}

  List<Widget> _rateAppContent() {
    return [
      _body("If Notes has been helpful, consider leaving a rating on Google Play.\n\nYour feedback helps improve the app and supports future development.\n\nThank you for using Notes."),
      const SizedBox(height: 24),
    ];
  }

  Widget _footerInfo({required double fontSize}) {
    return FutureBuilder<PackageInfo>(
      future: PackageInfo.fromPlatform(),
      builder: (context, snapshot) {
        final version = snapshot.hasData ? snapshot.data!.version : "1.0.0";
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: Center(
            child: Opacity(
              opacity: 0.80,
              child: Text(
                "Version $version",
                style: TextStyle(
                  fontSize: fontSize,
                  color: Colors.white.withOpacity(0.72),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
