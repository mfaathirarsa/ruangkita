

class SearchBarDashboardModel {
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
    // Tambahkan logika pencarian di KontenPage
  }

    static void searchInKonten(
      String query,
      List<Map<String, dynamic>> contentData,
      String activeTag,
      Function(List<Map<String, dynamic>>) onResult) {
    print("Searching in Dashboard: $query");

    // Filter konten berdasarkan tag aktif
    final filteredByTag = activeTag == "Semua"
        ? contentData
        : contentData.where((item) => item['type'] == activeTag).toList();

    // Filter berdasarkan query
    final filteredByQuery = filteredByTag.where((item) {
      return item['title'].toLowerCase().contains(query.toLowerCase());
    }).toList();

    // Kirimkan hasil pencarian ke callback
    onResult(filteredByQuery);
  }

  static void searchInAktivitas(String query) {
    print("Searching in Aktivitas: $query");
    // Tambahkan logika pencarian di AktivitasPage
  }

  static void searchInKonsultasi(String query) {
    print("Searching in Konsultasi: $query");
    // Tambahkan logika pencarian di KonsultasiPage
  }

  static void performSearch({
    required int currentIndex,
    required String query,
    required List<Map<String, dynamic>> contentData,
    required String activeTag,
    required Function(List<Map<String, dynamic>>) onResult,
  }) {
    switch (currentIndex) {
      case 0:
        searchInDashboard(query);
        break;
      case 1:
        searchInKonten(query, contentData, activeTag, onResult);
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
