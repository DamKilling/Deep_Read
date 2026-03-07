import 'package:flutter/material.dart';

@immutable
class ReaderSettings {
  final double fontSize;
  final double lineHeight;
  final bool showTranslation;
  final String theme;

  const ReaderSettings({
    this.fontSize = 20.0,
    this.lineHeight = 1.8,
    this.showTranslation = true,
    this.theme = 'light',
  });

  ReaderSettings copyWith({
    double? fontSize,
    double? lineHeight,
    bool? showTranslation,
    String? theme,
  }) {
    return ReaderSettings(
      fontSize: fontSize ?? this.fontSize,
      lineHeight: lineHeight ?? this.lineHeight,
      showTranslation: showTranslation ?? this.showTranslation,
      theme: theme ?? this.theme,
    );
  }
}
