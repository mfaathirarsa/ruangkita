import 'package:flutter/material.dart';
import '../models/menu_beranda.dart';

List<Widget> get generateDashboardMenu {
  return [
    DashboardMenu(
      icon: Icons.article,
      caption: 'Konten',
      onPressed: () {
        print('Konten clicked');
      },
    ),
    DashboardMenu(
      icon: Icons.lightbulb,
      caption: 'Aktivitas',
      onPressed: () {
        print('Aktivitas clicked');
      },
    ),
    DashboardMenu(
      icon: Icons.chat,
      caption: 'Konsultasi',
      onPressed: () {
        print('Konsultasi clicked');
      },
    ),
    DashboardMenu(
      icon: Icons.quiz,
      caption: 'Kuis',
      onPressed: () {
        print('Kuis clicked');
      },
    ),
    DashboardMenu(
      icon: Icons.question_answer,
      caption: 'Tanya Anonim',
      onPressed: () {
        print('Tanya Anonim clicked');
      },
    ),
    DashboardMenu(
      icon: Icons.star,
      caption: 'Premium',
      onPressed: () {
        print('Premium clicked');
      },
    ),
  ];
}
