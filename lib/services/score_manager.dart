class ScoreManager {
  static int _score = 0;

  static int get score => _score;

  static void reset() {
    _score = 0;
  }

  static void increment() {
    _score++;
  }
}