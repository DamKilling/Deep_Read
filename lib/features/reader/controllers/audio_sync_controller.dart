import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:just_audio/just_audio.dart';

class AudioTimestamp {
  final int sentenceIndex;
  final Duration start;
  final Duration end;

  AudioTimestamp({
    required this.sentenceIndex,
    required this.start,
    required this.end,
  });
}

class AudioSyncController {
  final AudioPlayer player = AudioPlayer();
  final List<AudioTimestamp> timestamps;
  
  // Reactive state for the UI to listen to
  final ValueNotifier<int?> activeSentenceIndex = ValueNotifier<int?>(null);
  final ValueNotifier<bool> isPlaying = ValueNotifier<bool>(false);

  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerStateSubscription;

  AudioSyncController({required this.timestamps});

  Future<void> init(String url) async {
    try {
      await player.setUrl(url);
      
      _positionSubscription = player.positionStream.listen((position) {
        _checkAndHighlightSentence(position);
      });

      _playerStateSubscription = player.playerStateStream.listen((state) {
        isPlaying.value = state.playing;
        // If it finished, reset the highlight
        if (state.processingState == ProcessingState.completed) {
          activeSentenceIndex.value = null;
        }
      });
    } catch (e) {
      print("Error loading audio: \$e");
    }
  }

  void _checkAndHighlightSentence(Duration currentPosition) {
    for (var stamp in timestamps) {
      if (currentPosition >= stamp.start && currentPosition <= stamp.end) {
        if (activeSentenceIndex.value != stamp.sentenceIndex) {
          activeSentenceIndex.value = stamp.sentenceIndex;
        }
        return;
      }
    }
    // If we reach here, we aren't in any valid timestamp interval (e.g., silence between sentences)
    // You might optionally want to set activeSentenceIndex.value = null here.
  }

  Future<void> togglePlayPause() async {
    if (player.playing) {
      await player.pause();
    } else {
      // If completed, seek to start before playing again
      if (player.processingState == ProcessingState.completed) {
        await player.seek(Duration.zero);
      }
      await player.play();
    }
  }

  Future<void> seekToSentence(int sentenceIndex) async {
    try {
      final stamp = timestamps.firstWhere((s) => s.sentenceIndex == sentenceIndex);
      await player.seek(stamp.start);
      if (!player.playing) {
        await player.play();
      }
    } catch (e) {
      print("Timestamp for sentence \$sentenceIndex not found");
    }
  }

  void dispose() {
    _positionSubscription?.cancel();
    _playerStateSubscription?.cancel();
    player.dispose();
    activeSentenceIndex.dispose();
    isPlaying.dispose();
  }
}
