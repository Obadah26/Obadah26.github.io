import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PendingConfirmationsScreen extends StatefulWidget {
  const PendingConfirmationsScreen({super.key, required this.userName});
  final String userName;

  @override
  State<PendingConfirmationsScreen> createState() =>
      _PendingConfirmationsScreenState();
}

class _PendingConfirmationsScreenState
    extends State<PendingConfirmationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('طلبات التأكيد')),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseFirestore.instance
                .collection('daily_recitation')
                .where('other_User', isEqualTo: widget.userName)
                .where('status', isEqualTo: 'pending')
                .orderBy('timestamp', descending: true)
                .snapshots(),
        builder: (context, snapshot) {
          try {
            if (snapshot.hasError) {
              return Center(child: Text('حدث خطأ ما'));
            }
          } catch (e) {
            print('The error is $e');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('لا توجد طلبات في انتظار التأكيد'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              var data = doc.data() as Map<String, dynamic>;

              return ListTile(
                title: Text(
                  '${data['user']} يطلب تأكيد الصفحات ${data['first_page']} إلى ${data['second_page']}',
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => _handleConfirmation(doc.id, true),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => _handleConfirmation(doc.id, false),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _handleConfirmation(String docId, bool accepted) async {
    try {
      await FirebaseFirestore.instance
          .collection('daily_recitation')
          .doc(docId)
          .update({
            'status': accepted ? 'confirmed' : 'rejected',
            'confirmed_at': FieldValue.serverTimestamp(),
          });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(accepted ? 'تم التأكيد بنجاح' : 'تم رفض الطلب')),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('حدث خطأ أثناء معالجة الطلب')));
    }
  }
}
