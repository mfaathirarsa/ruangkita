// searchbar_dashboard_controller.dart

class SearchBarDashboardController {
  static String getHintText(int currentIndex) {
    switch (currentIndex) {
      case 0:
        return 'Cari artikel, video, kuis, atau lainnya...';
      case 1:
        return 'Cari konten...';
      case 2:
        return 'Cari aktivitas...';
      case 3:
        return 'Cari konsultasi...';
      default:
        return 'Cari sesuatu...';
    }
  }

  static void searchInDashboard(String query) {
    print("Searching in Dashboard: $query");
    // Tambahkan logika pencarian di Dashboard
  }

  static void searchInKonten(String query) {
    print("Searching in Konten: $query");
    // Tambahkan logika pencarian di KontenPage
  }

  static void searchInAktivitas(String query) {
    print("Searching in Aktivitas: $query");
    // Tambahkan logika pencarian di AktivitasPage
  }

  static void searchInKonsultasi(String query) {
    print("Searching in Konsultasi: $query");
    // Tambahkan logika pencarian di KonsultasiPage
  }

  static void performSearch(int currentIndex, String query) {
    switch (currentIndex) {
      case 0:
        searchInDashboard(query);
        break;
      case 1:
        searchInKonten(query);
        break;
      case 2:
        searchInAktivitas(query);
        break;
      case 3:
        searchInKonsultasi(query);
        break;
      default:
        print("Unknown page search: $query");
    }
  }
}
