import 'package:alhadiqa/const.dart';
import 'package:alhadiqa/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class PendingConfirmationsScreen extends StatefulWidget {
  const PendingConfirmationsScreen({super.key, required this.userName});
  final String userName;
  static const String id = 'pending_confirmations_screen';

  @override
  State<PendingConfirmationsScreen> createState() =>
      _PendingConfirmationsScreenState();
}

class _PendingConfirmationsScreenState
    extends State<PendingConfirmationsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      appBar: AppBar(
        title: Center(
          child: Text(
            'طلبات التأكيد',
            style: GoogleFonts.elMessiri(
              textStyle: kHeading2Text.copyWith(color: kDarkPrimaryColor),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(
              Icons.checklist_outlined,
              color: kDarkPrimaryColor,
              size: 35,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15),
          child: IconButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                context,
                HomeScreen.id,
                (route) => false,
              );
            },
            icon: Icon(
              Icons.arrow_back_rounded,
              size: 35,
              color: kDarkPrimaryColor,
            ),
          ),
        ),
      ),
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

              return LayoutBuilder(
                builder: (context, constraints) {
                  final isWeb = constraints.maxWidth > 600;

                  return Center(
                    child: Card(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: kSecondaryBorderColor),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: Container(
                        width: isWeb ? 600 : double.infinity,
                        child: ListTile(
                          title: Text(
                            'هل قد قمت بالمدارسة مع ${data['user'].split(' ')[0]} من صفحة ${data['first_page']} الى ${data['second_page']} ؟',
                            style: GoogleFonts.cairo(
                              textStyle: kBodySmallText.copyWith(
                                fontSize: isWeb ? 17 : 14,
                              ),
                            ),
                            textAlign: TextAlign.right,
                          ),
                          leading: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.close,
                                  color: Colors.red,
                                ),
                                onPressed:
                                    () => _handleConfirmation(doc.id, false),
                              ),
                              IconButton(
                                icon: const Icon(
                                  Icons.check,
                                  color: Colors.green,
                                ),
                                onPressed:
                                    () => _handleConfirmation(doc.id, true),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
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
