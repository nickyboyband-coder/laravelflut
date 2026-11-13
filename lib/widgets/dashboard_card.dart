import 'package:flutter/material.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  const DashboardCard({
  super.key,
  required this.title,
  required this.value,
  required this.icon,
  required this.color,
  });
  

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            Icon(icon,
            size: 20,
            color: color,
            ),
            const SizedBox(height: 10),
            Text(value,
            style: TextStyle(
              fontSize: 20,fontWeight: FontWeight.bold,
            ),
            ),
             const SizedBox(height: 5),
             Text(title),
          ],
        ),
        ),
    );
  }
}