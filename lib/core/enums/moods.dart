enum Mood {
  angry('Angry', '😡'),
  sad('Sad', '☹️'),
  neutral('Neutral', '😐'),
  happy('Happy', '🙂'),
  love('Love', '😍');

  const Mood(this.label, this.emoji);

  final String label;
  final String emoji;

  /// Convert from label or emoji to Mood safely
  static Mood? fromString(final String? value) {
    if (value == null) {
      return null;
    }

    for (final Mood mood in Mood.values) {
      if (mood.label == value || mood.emoji == value) {
        return mood;
      }
    }

    return null;
  }
}
