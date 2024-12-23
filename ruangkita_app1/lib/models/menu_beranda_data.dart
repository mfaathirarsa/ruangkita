import 'package:flutter/material.dart';
import '../models/menu_beranda.dart';
import 'package:flutter/foundation.dart'; // Buat kDebugMode

// Buat logging
void logMenuClick(String menuName) {
  if (kDebugMode) {
    debugPrint('$menuName clicked');
  }
}

List<Widget> generateDashboardMenu(Function(int index) onTabTapped) {
  return [
    DashboardMenu(
      icon: Icons.article,
      caption: 'Konten',
      onPressed: () =>
          onTabTapped(1), // Panggil fungsi onTabTapped dengan indeks 1
    ),
    DashboardMenu(
      icon: Icons.lightbulb,
      caption: 'Aktivitas',
      onPressed: () =>
          onTabTapped(2), // Panggil fungsi onTabTapped dengan indeks 2
    ),
    DashboardMenu(
      icon: Icons.chat,
      caption: 'Konsultasi',
      onPressed: () =>
          onTabTapped(3), // Panggil fungsi onTabTapped dengan indeks 3
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
