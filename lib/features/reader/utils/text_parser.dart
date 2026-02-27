import '../models/text_token.dart';

class TextParser {
  /// Parses a given paragraph string into a list of TextTokens.
  /// It separates readable words from punctuations/spaces.
  static List<TextToken> parseParagraph(String paragraph, int paragraphIndex) {
    List<TextToken> tokens = [];
    
    // Regular expression to match words (including hyphens and apostrophes) 
    // OR non-word characters (spaces, punctuation).
    RegExp exp = RegExp(r"([a-zA-Z\-']+)|([^a-zA-Z\-']+)");
    Iterable<RegExpMatch> matches = exp.allMatches(paragraph);
    
    int currentSentenceIndex = 0;

    for (final match in matches) {
      String wordOrPunc = match.group(0)!;
      // If group(1) is not null, it matched the word part.
      bool isWord = match.group(1) != null;

      tokens.add(TextToken(
        text: wordOrPunc,
        isWord: isWord,
        sentenceIndex: currentSentenceIndex,
        paragraphIndex: paragraphIndex,
      ));

      // If the token is punctuation ending a sentence (., ?, !), increment the sentence index.
      // We check if the non-word token contains a sentence-ending character.
      if (!isWord && RegExp(r'[.?!]').hasMatch(wordOrPunc)) {
        currentSentenceIndex++;
      }
    }
    return tokens;
  }
}
