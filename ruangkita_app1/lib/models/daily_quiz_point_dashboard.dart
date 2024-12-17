import 'package:flutter/material.dart';

class TotalPointsWidget extends StatelessWidget {
  final int totalPoints;

  const TotalPointsWidget({Key? key, required this.totalPoints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.lightBlue[50],
        border: Border.all(color: Colors.blueAccent),
        borderRadius: BorderRadius.circular(8),
      ),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 16, color: Colors.black),
          children: [
            TextSpan(
              text: 'Total poin kuis harian kamu: ',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            TextSpan(
              text: '$totalPoints',
              style: TextStyle(
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
