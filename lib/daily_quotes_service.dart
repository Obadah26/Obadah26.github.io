import 'package:cloud_firestore/cloud_firestore.dart';

class DailyQuotesService {
  static final _firestore = FirebaseFirestore.instance;

  static Future<Map<String, String>> getAllQuotes() async {
    try {
      final snapshot = await _firestore.collection('daily_quotes').get();
      final quotes = <String, String>{};

      for (final doc in snapshot.docs) {
        quotes[doc['text']] = doc['reference'];
      }

      return quotes;
    } catch (e) {
      print('Error fetching quotes: $e');
      return {};
    }
  }

  static Future<MapEntry<String, String>> getTodaysQuote() async {
    try {
      final snapshot = await _firestore.collection('daily_quotes').get();
      final quotes = snapshot.docs;

      if (quotes.isEmpty) {
        return const MapEntry('', '');
      }

      final now = DateTime.now();
      final dayOfYear = now.difference(DateTime(now.year, 5, 18)).inDays;
      final index = dayOfYear % quotes.length;

      return MapEntry(quotes[index]['text'], quotes[index]['reference']);
    } catch (e) {
      print('Error getting today\'s quote: $e');
      return const MapEntry('', '');
    }
  }
}
