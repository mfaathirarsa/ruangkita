import 'package:flutter/material.dart';

class TotalPointsWidget extends StatelessWidget {
  final int totalPoints;

  const TotalPointsWidget({super.key, required this.totalPoints});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(
        text: TextSpan(
          style: const TextStyle(fontSize: 16, color: Colors.black),
          children: [
            const TextSpan(
              text: 'Total poin kuis harian kamu: ',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            TextSpan(
              text: '$totalPoints',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
