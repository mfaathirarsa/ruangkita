import 'package:flutter/material.dart';

class MenuBawah extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabTapped;
  final bool hasNewNotification;

  // Use super parameters to directly pass the parameters to the superclass constructor
  const MenuBawah({
    super.key, // Automatically passing the key to the super class
    required this.currentIndex,
    required this.onTabTapped,
    required this.hasNewNotification,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFF63B0E3),
      unselectedItemColor: const Color.fromARGB(255, 78, 78, 78),
      showUnselectedLabels: true,
      onTap: onTabTapped,
      items: [
        _buildBottomNavigationBarItem(0, 'Beranda', 'assets/icons/iconBeranda.png'),
        _buildBottomNavigationBarItem(1, 'Konten', 'assets/icons/iconKonten.png'),
        _buildBottomNavigationBarItem(2, 'Aktivitas', 'assets/icons/iconAktivitas.png', hasNotification: hasNewNotification),
        _buildBottomNavigationBarItem(3, 'Konsultasi', 'assets/icons/iconKonsultasi.png'),
      ],
    );
  }

  BottomNavigationBarItem _buildBottomNavigationBarItem(
    int index,
    String label,
    String iconPath, {
    bool hasNotification = false,
  }) {
    bool isActive = currentIndex == index;

    return BottomNavigationBarItem(
      icon: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            iconPath,
            color: isActive ? const Color(0xFF63B0E3) : const Color.fromARGB(255, 78, 78, 78),
            height: 24,
          ),
          if (isActive)
            Positioned(
              top: -12,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/icons/aktif.png',
                height: 10,
              ),
            ),
          if (hasNotification)
            Positioned(
              top: -5,
              right: -5,
              child: Image.asset(
                'assets/icons/elips.png',
                height: 5,
                width: 5,
              ),
            ),
        ],
      ),
      label: label,
    );
  }
}
