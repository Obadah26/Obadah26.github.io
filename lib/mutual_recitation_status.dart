import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MutualRecitationStatus extends StatelessWidget {
  const MutualRecitationStatus({super.key, required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          FirebaseFirestore.instance
              .collection('daily_recitation')
              .where('user', isEqualTo: userName)
              .where('recitation_type', isEqualTo: 'with')
              .orderBy('timestamp', descending: true)
              .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox.shrink(); // Return an empty widget if no data
        }

        final pending =
            snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data['status'] == 'pending';
            }).length;

        final confirmed =
            snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data['status'] == 'confirmed';
            }).length;

        final rejected =
            snapshot.data!.docs.where((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return data['status'] == 'rejected';
            }).length;

        return Column(
          children: [
            if (pending > 0)
              ListTile(
                leading: const Icon(Icons.access_time, color: Colors.orange),
                title: Text('لديك $pending طلب في انتظار التأكيد'),
              ),
            if (confirmed > 0)
              ListTile(
                leading: const Icon(Icons.check_circle, color: Colors.green),
                title: Text('لديك $confirmed طلب مؤكد'),
              ),
            if (rejected > 0)
              ListTile(
                leading: const Icon(Icons.cancel, color: Colors.red),
                title: Text('لديك $rejected طلب مرفوض'),
              ),
          ],
        );
      },
    );
  }
}
