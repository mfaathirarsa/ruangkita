import 'dart:convert';
import 'package:http/http.dart' as http;
import 'database_controller.dart';

class YouTubeService {
  final String apiKey = 'AIzaSyC-2Cs2mAOYXxlcFfAS7fAbnqdfewHZ4PI';
  final String channelId = 'UC8WIrO3hSfKrJxAZLMHIS2g';

  String? _nextPageToken;

  Future<void> fetchAndSaveVideos({int maxResults = 3}) async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&type=video&maxResults=$maxResults&pageToken=${_nextPageToken ?? ''}&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _nextPageToken = data['nextPageToken'];

      // Memetakan hasil query ke format `contentData`
      final videos = List<Map<String, dynamic>>.from(data['items'].map((item) {
        final snippet = item['snippet'];
        return {
          "title": snippet['title'],
          "type": "Video",
          "date": formatDate(snippet['publishedAt']),
          "imagePath": snippet['thumbnails']['default']['url'],
          "videoUrl": "https://www.youtube.com/watch?v=${item['id']['videoId']}",
          "content": snippet['description'] ?? "",
        };
      }));

      // Kirim data ke database, hindari duplikasi
      for (var video in videos) {
        final exists = await isContentExists(video['title']);
        if (!exists) {
          await DatabaseHelper.instance.sendContentData(video);
        }
      }
    } else {
      throw Exception('Failed to load videos');
    }
  }

  Future<bool> isContentExists(String title) async {
    // Periksa apakah konten dengan judul tertentu sudah ada di database
    final contentList = await DatabaseHelper.instance.fetchContentData();
    return contentList.any((content) => content['title'] == title);
  }

  void resetPagination() {
    _nextPageToken = null;
  }

  String formatDate(String dateTime) {
    final date = DateTime.parse(dateTime);
    return "${date.day}/${date.month}/${date.year}";
  }
}
