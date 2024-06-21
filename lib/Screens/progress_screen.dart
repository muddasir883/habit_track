import 'package:flutter/material.dart';

import 'homepage.dart';

class ProgressScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Progress & Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Progress',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  ReportCard('June Summary: 3/5 sugar days used', 'View Detailed Report'),
                  ReportCard('May Summary: 5/5 sugar days used', 'View Detailed Report'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
