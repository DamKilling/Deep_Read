import 'dart:convert';
import 'package:http/http.dart' as http;

class DictionaryResult {
  final String word;
  final String phonetic;
  final String partOfSpeech;
  final String definition;
  final String example;

  DictionaryResult({
    required this.word,
    required this.phonetic,
    required this.partOfSpeech,
    required this.definition,
    required this.example,
  });
}

class DictionaryService {
  /// Fetches word definition from the Free Dictionary API
  static Future<DictionaryResult?> lookupWord(String word) async {
    // Clean the word from punctuation just in case
    final cleanWord = word.replaceAll(RegExp(r'[^\w\s\-]'), '').toLowerCase();
    if (cleanWord.isEmpty) return null;

    try {
      final response = await http.get(
        Uri.parse('https://api.dictionaryapi.dev/api/v2/entries/en/$cleanWord'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final entry = data[0];
          
          String phonetic = entry['phonetic'] ?? '';
          if (phonetic.isEmpty && entry['phonetics'] != null && entry['phonetics'].isNotEmpty) {
            phonetic = entry['phonetics'][0]['text'] ?? '';
          }

          String partOfSpeech = '';
          String definition = 'No definition found.';
          String example = '';

          if (entry['meanings'] != null && entry['meanings'].isNotEmpty) {
            final meaning = entry['meanings'][0];
            partOfSpeech = meaning['partOfSpeech'] ?? '';
            
            if (meaning['definitions'] != null && meaning['definitions'].isNotEmpty) {
              final def = meaning['definitions'][0];
              definition = def['definition'] ?? '';
              example = def['example'] ?? '';
            }
          }

          return DictionaryResult(
            word: entry['word'] ?? cleanWord,
            phonetic: phonetic,
            partOfSpeech: partOfSpeech,
            definition: definition,
            example: example,
          );
        }
      }
    } catch (e) {
      print('Dictionary fetch error: $e');
    }
    return null;
  }
}
