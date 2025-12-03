String formatPhone(String raw) {
  raw = raw.replaceAll('-', '');
  if (raw.length < 11) return raw;
  return '${raw.substring(0, 3)}-${raw.substring(3, 7)}-${raw.substring(7)}';
}

class TimeFormatter {
  static String format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    final milliseconds =
        duration.inMilliseconds.remainder(1000).toString().padLeft(3, '0');
    return '$minutes:$seconds.$milliseconds';
  }
}
