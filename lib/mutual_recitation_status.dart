import 'package:alhadiqa/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MutualRecitationStatus extends StatelessWidget {
  const MutualRecitationStatus({super.key, required this.userName});
  final String userName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Sender pending requests
        StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('daily_recitation')
                  .where('user', isEqualTo: userName)
                  .where('recitation_type', isEqualTo: 'with')
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
          builder: (context, snapshot) {
            final pendingCount =
                snapshot.hasData ? snapshot.data!.docs.length : 0;
            if (pendingCount == 0) return SizedBox.shrink();

            return ListTile(
              trailing: const Icon(Icons.access_time, color: kPrimaryColor),
              title: Text(
                'لديك $pendingCount طلب في انتظار التأكيد',
                style: GoogleFonts.cairo(textStyle: kBodySmallText),
                textAlign: TextAlign.right,
              ),
            );
          },
        ),

        // Receiver pending requests
        StreamBuilder<QuerySnapshot>(
          stream:
              FirebaseFirestore.instance
                  .collection('daily_recitation')
                  .where('other_User', isEqualTo: userName)
                  .where('recitation_type', isEqualTo: 'with')
                  .where('status', isEqualTo: 'pending')
                  .snapshots(),
          builder: (context, snapshot) {
            final pendingCount =
                snapshot.hasData ? snapshot.data!.docs.length : 0;
            if (pendingCount == 0) return SizedBox.shrink();

            return ListTile(
              trailing: const Icon(Icons.access_time, color: kPrimaryColor),
              title: Text(
                'لديك $pendingCount طلب في انتظار تأكيدك',
                style: GoogleFonts.cairo(textStyle: kBodySmallText),
                textAlign: TextAlign.right,
              ),
            );
          },
        ),
      ],
    );
  }
}
