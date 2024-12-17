import 'package:flutter/material.dart';

// Widget untuk kartu konten
class ContentCard extends StatelessWidget {
  final String title;
  final String type;
  final String date;
  final String imagePath;
  final double width; // Tambahkan parameter untuk lebar card
  final double imageHeight; // Tambahkan parameter untuk tinggi gambar

  const ContentCard({
    super.key,
    required this.title,
    required this.type,
    required this.date,
    required this.imagePath,
    this.width = 200, // Default width
    this.imageHeight = 120, // Default height untuk gambar
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width, // Gunakan parameter untuk lebar
      margin: const EdgeInsets.only(
        right: 12.0,
        bottom: 8.0,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 6.0,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12.0),
            ),
            child: Stack(
              children: [
                Image.asset(
                  imagePath,
                  width: double.infinity,
                  height: imageHeight, // Gunakan parameter untuk tinggi gambar
                  fit: BoxFit.cover,
                ),
                if (type == "Video")
                  Container(
                    height: imageHeight,
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: Icon(
                        Icons.play_circle_fill,
                        color: Colors.black,
                        size: 40,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      type,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      date,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
