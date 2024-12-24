import 'package:flutter/material.dart';

// Widget untuk kartu konten
class ContentCard extends StatefulWidget {
  String title;
  String type;
  String date;
  String imagePath;
  double width;
  double imageHeight;
  String searchQuery;
  VoidCallback? onTap; // Tambahkan parameter onTap

  ContentCard({
    super.key,
    required this.title,
    required this.type,
    required this.date,
    required this.imagePath,
    this.width = 200,
    this.imageHeight = 120,
    required this.searchQuery,
    this.onTap, // Callback untuk navigasi
  });

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  void updateContent({
    String? newTitle,
    String? newType,
    String? newDate,
    String? newImagePath,
  }) {
    setState(() {
      if (newTitle != null) widget.title = newTitle;
      if (newType != null) widget.type = newType;
      if (newDate != null) widget.date = newDate;
      if (newImagePath != null) widget.imagePath = newImagePath;
    });
  }

  TextSpan highlightText(String text, String query) {
    // Tentukan font family yang digunakan
    TextStyle defaultStyle = const TextStyle(
      color: Colors.black,
      fontWeight: FontWeight.bold,
      fontFamily: 'Gotham', // Ganti dengan nama font family yang Anda inginkan
    );

    // Jika query kosong, kembalikan teks biasa dengan font yang diinginkan
    if (query.isEmpty) {
      return TextSpan(text: text, style: defaultStyle);
    }

    int startIndex = text.toLowerCase().indexOf(query.toLowerCase());

    if (startIndex == -1) {
      return TextSpan(text: text, style: defaultStyle);
    }

    List<TextSpan> spans = [];

    // Teks sebelum query
    spans.add(TextSpan(
      text: text.substring(0, startIndex),
      style: defaultStyle,
    ));

    // Teks yang sesuai dengan query dan memberi highlight
    spans.add(TextSpan(
      text: text.substring(startIndex, startIndex + query.length),
      style: const TextStyle(
        color: Color.fromARGB(255, 255, 145, 0), // Warna teks highlight
        fontWeight: FontWeight.w900,
        fontFamily:
            'Gotham', // Ganti dengan nama font family yang Anda inginkan
      ),
    ));

    // Teks setelah query
    spans.add(TextSpan(
      text: text.substring(startIndex + query.length),
      style: defaultStyle,
    ));

    return TextSpan(children: spans);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap, // Panggil callback saat ditekan
      child: Container(
        width: widget.width,
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
                  widget.imagePath.startsWith('http')
                      ? Image.network(
                          widget.imagePath,
                          width: double.infinity,
                          height: widget.imageHeight,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: double.infinity,
                              height: widget.imageHeight,
                              color: Colors.grey[300],
                              child: Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes !=
                                          null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ??
                                              1)
                                      : null,
                                ),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: double.infinity,
                              height: widget.imageHeight,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.broken_image,
                                color: Colors.red,
                                size: 40,
                              ),
                            );
                          },
                        )
                      : Image.asset(
                          widget.imagePath,
                          width: double.infinity,
                          height: widget.imageHeight,
                          fit: BoxFit.cover,
                        ),
                  if (widget.type == "Video")
                    Container(
                      height: widget.imageHeight,
                      color: Colors.black.withOpacity(0.3),
                      child: const Center(
                        child: Icon(
                          Icons.play_circle_fill,
                          color: Colors.white,
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
                  RichText(
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    text: highlightText(widget.title, widget.searchQuery),
                  ),
                  const SizedBox(height: 8.0),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.type,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.date,
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
      ),
    );
  }
}
