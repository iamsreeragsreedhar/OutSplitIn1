import 'package:flutter/material.dart';

class OnboardingItem {
  final String badge;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final List<String> features;

  const OnboardingItem({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.features,
  });

  static const List<OnboardingItem> items = [
    OnboardingItem(
      badge: 'AUTO-DETECTION',
      title: 'Never Forget an Expense Again',
      subtitle:
          'OutSplitIn automatically captures payments in real-time as soon as you pay via Google Pay, PhonePe, Paytm, or bank cards.',
      icon: Icons.notifications_active_rounded,
      accentColor: Color(0xFF0BA874),
      features: [
        '⚡ Instant UPI payment recording',
        '🔒 Runs locally on your device',
        '💳 Supports all major banks & apps',
      ],
    ),
    OnboardingItem(
      badge: 'SMART CATEGORIZATION',
      title: 'Effortless Expense Management',
      subtitle:
          'Every rupee is categorized automatically into Food, Shopping, Bills, Transport, and more with smart merchant matching.',
      icon: Icons.account_balance_wallet_rounded,
      accentColor: Color(0xFF087F59),
      features: [
        '🍔 Auto-detects Swiggy, Zomato, etc.',
        '🏷️ Customizable spend categories',
        '💡 Zero manual entry friction',
      ],
    ),
    OnboardingItem(
      badge: 'OFFLINE & VISUAL REPORTS',
      title: 'Gain Clarity on Your Cashflow',
      subtitle:
          'Beautiful interactive graphs and charts give you complete visibility over your finances — fully functional offline.',
      icon: Icons.pie_chart_rounded,
      accentColor: Color(0xFFF47A45),
      features: [
        '📊 Interactive donut & bar charts',
        '📱 100% offline access & instant launch',
        '📈 Weekly & monthly spending trends',
      ],
    ),
  ];
}
