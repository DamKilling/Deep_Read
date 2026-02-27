import '../../controllers/audio_sync_controller.dart';
import '../../services/dictionary_service.dart';
import 'package:flutter/material.dart';
import '../../utils/text_parser.dart';
import '../../models/text_token.dart';
import '../widgets/interactive_paragraph.dart';

class ReaderScreen extends StatefulWidget {
  const ReaderScreen({super.key});

  @override
  State<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends State<ReaderScreen> {
  // Dummy data for MVP testing
  final List<String> _mockParagraphs = [
    "It is a truth universally acknowledged, that a single man in possession of a good fortune, must be in want of a wife.",
    "However little known the feelings or views of such a man may be on his first entering a neighbourhood, this truth is so well fixed in the minds of the surrounding families, that he is considered the rightful property of some one or other of their daughters.",
    "\"My dear Mr. Bennet,\" said his lady to him one day, \"have you heard that Netherfield Park is let at last?\"",
    "Mr. Bennet replied that he had not.",
  ];

  late List<List<TextToken>> _parsedParagraphs;
  
  late AudioSyncController _audioController;

  @override
  void initState() {
    super.initState();
    // Parse paragraphs on init
    _parsedParagraphs = List.generate(
      _mockParagraphs.length,
      (index) => TextParser.parseParagraph(_mockParagraphs[index], index),
    );

    // Initialize mock audio controller (mocking an audiobook of Pride & Prejudice)
    // We use a public domain audio sample. Since it's hard to get exact match without manual alignment,
    // we'll just map dummy durations to our 4 sentences for demonstration.
    _audioController = AudioSyncController(
      timestamps: [
        AudioTimestamp(sentenceIndex: 0, start: const Duration(seconds: 0), end: const Duration(seconds: 6)),
        AudioTimestamp(sentenceIndex: 1, start: const Duration(seconds: 6), end: const Duration(seconds: 14)),
        AudioTimestamp(sentenceIndex: 2, start: const Duration(seconds: 14), end: const Duration(seconds: 19)),
        AudioTimestamp(sentenceIndex: 3, start: const Duration(seconds: 19), end: const Duration(seconds: 22)),
      ],
    );
    // Public domain short mp3 just to hear something play
    _audioController.init('https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3');
  }

  @override
  void dispose() {
    _audioController.dispose();
    super.dispose();
  }

  void _onWordTapped(TextToken token) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows the sheet to take up more height if needed
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.4,
          minChildSize: 0.2,
          maxChildSize: 0.8,
          expand: false,
          builder: (context, scrollController) {
            return FutureBuilder<DictionaryResult?>(
              future: DictionaryService.lookupWord(token.text),
              builder: (context, snapshot) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
                  child: ListView(
                    controller: scrollController,
                    children: [
                      Center(
                        child: Container(
                          width: 40,
                          height: 4,
                          margin: const EdgeInsets.only(bottom: 24),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      Text(
                        token.text,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'serif',
                        ),
                      ),
                      const SizedBox(height: 8),
                      if (snapshot.connectionState == ConnectionState.waiting)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32.0),
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else if (snapshot.hasData && snapshot.data != null) ...[
                        Row(
                          children: [
                            if (snapshot.data!.phonetic.isNotEmpty)
                              Text(
                                snapshot.data!.phonetic,
                                style: const TextStyle(color: Colors.grey, fontSize: 18),
                              ),
                            const SizedBox(width: 12),
                            if (snapshot.data!.partOfSpeech.isNotEmpty)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  snapshot.data!.partOfSpeech,
                                  style: TextStyle(color: Colors.blue.shade700, fontSize: 14),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          "Definition",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          snapshot.data!.definition,
                          style: const TextStyle(fontSize: 16, height: 1.5, color: Colors.black54),
                        ),
                        if (snapshot.data!.example.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Text(
                            "Example",
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.black87),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            "\"${snapshot.data!.example}\"",
                            style: const TextStyle(fontSize: 16, height: 1.5, fontStyle: FontStyle.italic, color: Colors.grey),
                          ),
                        ],
                      ] else ...[
                        const Text(
                          "No translation found.",
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          "Original context:\nParagraph: ${token.paragraphIndex}, Sentence: ${token.sentenceIndex}",
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                      const SizedBox(height: 32),
                      ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.bookmark_add),
                        label: const Text("加入生词本 (Add to Vocab)"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chapter 1: The Bennet Family', style: TextStyle(fontFamily: 'serif', fontWeight: FontWeight.bold)),
        actions: [
          ValueListenableBuilder<bool>(
            valueListenable: _audioController.isPlaying,
            builder: (context, isPlaying, _) {
              return IconButton(
                icon: Icon(isPlaying ? Icons.pause_circle_filled : Icons.play_circle_fill),
                iconSize: 32,
                color: Theme.of(context).colorScheme.primary,
                onPressed: _audioController.togglePlayPause,
                tooltip: isPlaying ? 'Pause Audio' : 'Play Audio',
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: ValueListenableBuilder<int?>(
          valueListenable: _audioController.activeSentenceIndex,
          builder: (context, activeIndex, _) {
            return ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
              itemCount: _parsedParagraphs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 28),
              itemBuilder: (context, index) {
                return InteractiveParagraph(
                  tokens: _parsedParagraphs[index],
                  onWordTap: _onWordTapped,
                  activeSentenceIndex: activeIndex,
                );
              },
            );
          },
        ),
      ),
    );
  }
}
