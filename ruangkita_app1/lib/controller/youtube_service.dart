import 'dart:convert';
import 'package:http/http.dart' as http;

class YouTubeService {
  final String apiKey = 'AIzaSyC-2Cs2mAOYXxlcFfAS7fAbnqdfewHZ4PI';
  final String channelId = 'UC8WIrO3hSfKrJxAZLMHIS2g'; // Ganti dengan ID channel.

  String? _nextPageToken;

  Future<List<Map<String, dynamic>>> fetchVideos({int maxResults = 3}) async {
    final url = Uri.parse(
      'https://www.googleapis.com/youtube/v3/search?part=snippet&channelId=$channelId&type=video&maxResults=$maxResults&pageToken=${_nextPageToken ?? ''}&key=$apiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      _nextPageToken = data['nextPageToken'];

      // Memetakan hasil query ke format `contentData`
      return List<Map<String, dynamic>>.from(data['items'].map((item) {
        final snippet = item['snippet'];
        return {
          "title": snippet['title'],
          "type": "Video",
          "date": _formatDate(snippet['publishedAt']),
          "imagePath": snippet['thumbnails']['default']['url'],
        };
      }));
    } else {
      throw Exception('Failed to load videos');
    }
  }

  void resetPagination() {
    _nextPageToken = null;
  }

  String _formatDate(String dateTime) {
    final date = DateTime.parse(dateTime);
    return "${date.day}/${date.month}/${date.year}";
  }
}
