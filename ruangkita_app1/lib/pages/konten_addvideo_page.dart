import 'package:flutter/material.dart';

class AddVideoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Konten Terbaru'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildTabButton(context, 'Artikel', false),
                _buildTabButton(context, 'Video', true),
              ],
            ),
            SizedBox(height: 16),
            Row(
              children: [
                CircleAvatar(
                  radius: 24,
                  child: Icon(Icons.person, size: 24),
                ),
                SizedBox(width: 8),
                Text(
                  'User',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                labelText: 'Masukkan link',
                prefixIcon: Icon(Icons.link),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                // Handle image upload
              },
              child: Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  border: Border.all(color: Colors.grey),
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_circle, size: 40, color: Colors.lightBlue),
                      SizedBox(height: 8),
                      Text('Masukkan gambar',
                          style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Tambahkan deskripsi',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
            SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle upload
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.lightBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: Text('UNGGAH', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTabButton(BuildContext context, String title, bool isSelected) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Handle tab switch
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.lightBlue : Colors.white,
            borderRadius: BorderRadius.circular(8.0),
            border: Border.all(color: Colors.lightBlue),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : Colors.lightBlue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
