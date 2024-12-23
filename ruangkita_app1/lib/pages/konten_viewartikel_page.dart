import 'package:flutter/material.dart';

class ArticlePage extends StatelessWidget {
  const ArticlePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Artikel'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.lightBlue,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ayo Cuci Tangan 6 Langkah Agar Tangan Bersih dan Bebas Kuman!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Image.network(
                'https://bumninc.com/cegah-penularan-covid-19-unduh-aplikasi-pengingat-cuci-tangan/',
                height: 200,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 8),
              const Text(
                'Senin, 23 Desember 2024 11:11 WIB',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Menjaga kebersihan tangan menjadi hal utama dalam pencegahan dan pengendalian infeksi. Menurut penelitian dengan mencuci tangan yang benar dapat menurunkan angka penularan penyakit menular (seperti influenza, diare, hingga hepatitis A) hingga 50%. Oleh karena itu penting sekali untuk mengetahui cara mencuci tangan yang baik dan benar sesuai dengan Standar World Health Organization (WHO).\n\nCuci tangan dilakukan dengan menggosokkan tangan menggunakan cairan antiseptik (handrub) sekitar 20-30 detik atau dengan air mengalir dan sabun antiseptik (handwash) sekitar 40-60 detik.',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.thumb_up_alt_outlined, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Like', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.comment_outlined, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Comment', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.share_outlined, color: Colors.grey),
                      SizedBox(width: 8),
                      Text('Share', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
