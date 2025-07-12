import 'package:flutter/material.dart';

import '../theme/theme_helper.dart';

class CourseRequestItem extends StatelessWidget {
  final String courseName;
  final String date;
  final String amount;
  final String status;

  const CourseRequestItem({
    super.key,
    required this.courseName,
    required this.date,
    required this.amount,
    required this.status,
  });

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case '1':
        return Colors.green;
      case '-1':
        return Colors.red;
      case '0':
      default:
        return Colors.orange;
    }
  }

  String getStatus(String status){
    switch (status){
      case '1':
        return "Accepted";
      case '-1':
        return "Rejected";
      case '0':
      default:
        return "In Review";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              courseName,style: theme.textTheme.bodyLarge!.copyWith(height: 1.60)
            ),
            SizedBox(height: 8),

            Row(
              children: [
                Icon(Icons.calendar_today, size: 15, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  "Date : $date",style: theme.textTheme.bodyLarge!.copyWith(height: 1.60)
                ),
              ],
            ),
            SizedBox(height: 6),

            Row(
              children: [
                Icon(Icons.attach_money, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  "Paid Price : $amount",style: theme.textTheme.bodyLarge!.copyWith(height: 1.60)
                ),
              ],
            ),
            SizedBox(height: 6),

            Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.grey),
                SizedBox(width: 6),
                Text(
                  "Status : ",style: theme.textTheme.bodyLarge!.copyWith(height: 1.60)
                ),
                Text(
                  getStatus(status),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getStatusColor(status),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
