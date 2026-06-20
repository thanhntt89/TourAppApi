import 'package:flutter/material.dart';

/// Small flag icon widget that maps a language code to its emoji flag.
///
/// Supported mappings:
/// - `vi` -> flag of Vietnam
/// - `en` -> flag of United Kingdom
/// - `ko` -> flag of South Korea
/// - `zh` -> flag of China
class LanguageFlag extends StatelessWidget {
  const LanguageFlag({
    required this.languageCode,
    this.size = 20,
    super.key,
  });

  final String languageCode;
  final double size;

  static const _flags = {
    'vi': '\u{1F1FB}\u{1F1F3}', // Vietnam
    'en': '\u{1F1EC}\u{1F1E7}', // United Kingdom
    'ko': '\u{1F1F0}\u{1F1F7}', // South Korea
    'zh': '\u{1F1E8}\u{1F1F3}', // China
  };

  @override
  Widget build(BuildContext context) {
    final flag = _flags[languageCode.toLowerCase()];

    if (flag == null) {
      // Fallback: show language code text
      return SizedBox(
        width: size,
        height: size,
        child: Center(
          child: Text(
            languageCode.toUpperCase(),
            style: TextStyle(
              fontSize: size * 0.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      );
    }

    return Text(
      flag,
      style: TextStyle(fontSize: size),
    );
  }
}
