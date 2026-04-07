class UserTextNormalizer {
  const UserTextNormalizer._();

  static const _acronyms = {
    'AMRAP',
    'EMOM',
    'HIIT',
    'JM',
    'PR',
    'RDL',
  };

  static String normalizeTitle(String input) {
    final trimmed = input.trim().replaceAll(RegExp(r'\s+'), ' ');
    if (trimmed.isEmpty) {
      return '';
    }

    return trimmed
        .split(' ')
        .map(_normalizeWord)
        .join(' ');
  }

  static String _normalizeWord(String word) {
    return word
        .split('/')
        .map(
          (segment) => segment
              .split('-')
              .map(_normalizeToken)
              .join('-'),
        )
        .join('/');
  }

  static String _normalizeToken(String part) {
    final upper = part.toUpperCase();
    if (_acronyms.contains(upper)) {
      return upper;
    }

    if (part.isEmpty) {
      return part;
    }

    return '${part[0].toUpperCase()}${part.substring(1).toLowerCase()}';
  }
}