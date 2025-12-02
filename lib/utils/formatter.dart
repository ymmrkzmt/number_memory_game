String formatPhone(String raw) {
  raw = raw.replaceAll('-', '');
  if (raw.length < 11) return raw;
  return '${raw.substring(0, 3)}-${raw.substring(3, 7)}-${raw.substring(7)}';
}