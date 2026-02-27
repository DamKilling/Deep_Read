class TextToken {
  final String text;
  final bool isWord;
  final int sentenceIndex;
  final int paragraphIndex;

  TextToken({
    required this.text,
    required this.isWord,
    required this.sentenceIndex,
    required this.paragraphIndex,
  });

  @override
  String toString() {
    return 'TextToken(text: $text, isWord: $isWord, sentenceIndex: $sentenceIndex)';
  }
}
