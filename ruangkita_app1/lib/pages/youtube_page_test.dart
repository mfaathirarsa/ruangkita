// import 'package:flutter/material.dart';
// import '../controller/youtube_service.dart';

// class Youtube extends StatefulWidget {
//   const Youtube({super.key});

//   @override
//   _Youtube createState() => _Youtube();
// }

// class _Youtube extends State<Youtube> {
//   final YouTubeService _youTubeService = YouTubeService();
//   final ScrollController _scrollController = ScrollController();

//   List<Map<String, dynamic>> _videos = [];

//   bool _isLoading = false;
//   bool _isFetchingMore = false;

//   @override
//   void initState() {
//     super.initState();
//     _fetchVideos();
//     _scrollController.addListener(() {
//       if (_scrollController.position.pixels ==
//           _scrollController.position.maxScrollExtent) {
//         _fetchMoreVideos();
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Channel Videos'),
//       ),
//       body: _isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : RefreshIndicator(
//               onRefresh: _fetchVideos,
//               child: ListView.builder(
//                 controller: _scrollController,
//                 itemCount: _videos.length + (_isFetchingMore ? 1 : 0),
//                 itemBuilder: (context, index) {
//                   if (index == _videos.length) {
//                     return const Center(child: CircularProgressIndicator());
//                   }

//                   final video = _videos[index];
//                   final snippet = video['snippet'] ?? {}; // Default jika null

//                   return ListTile(
//                     leading: snippet['thumbnails'] != null
//                         ? Image.network(
//                             snippet['thumbnails']['default']['url'] ?? '')
//                         : const Placeholder(), // Ganti Placeholder dengan widget pengganti yang sesuai
//                     title: Text(snippet['title'] ?? 'No Title'),
//                     subtitle: Text(snippet['channelTitle'] ?? 'No Channel'),
//                   );
//                 },
//               ),
//             ),
//     );
//   }

//   @override
//   void dispose() {
//     _scrollController.dispose();
//     super.dispose();
//   }
// }
