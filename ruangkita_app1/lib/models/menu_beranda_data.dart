import 'package:flutter/material.dart';
import '../models/menu_beranda.dart';
import 'package:flutter/foundation.dart'; // Buat kDebugMode


// Buat logging
void logMenuClick(String menuName) {
  if (kDebugMode) {
    debugPrint('$menuName clicked');
  }
}

List<Widget> get generateDashboardMenu {
  return [
    DashboardMenu(
      icon: Icons.article,
      caption: 'Konten',
      onPressed: () => logMenuClick('Konten'),
    ),
    DashboardMenu(
      icon: Icons.lightbulb,
      caption: 'Aktivitas',
      onPressed: () => logMenuClick('Aktivitas'),
    ),
    DashboardMenu(
      icon: Icons.chat,
      caption: 'Konsultasi',
      onPressed: () => logMenuClick('Konsultasi'),
    ),
    DashboardMenu(
      icon: Icons.quiz,
      caption: 'Kuis',
      onPressed: () => logMenuClick('Kuis'),
    ),
    DashboardMenu(
      icon: Icons.question_answer,
      caption: 'Tanya Anonim',
      onPressed: () => logMenuClick('Tanya Anonim'),
    ),
    DashboardMenu(
      icon: Icons.star,
      caption: 'Premium',
      onPressed: () => logMenuClick('Premium'),
    ),
  ];
}
