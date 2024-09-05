import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final String title;
  final int number;
  const SummaryCard({
    super.key, required this.title, required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return   SizedBox(
      width: 100,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text('$number',style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),),
              Text(title)
            ],
          ),
        ),
      ),
    );
  }
}