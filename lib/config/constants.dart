const difficultyLevels = {
  'Easy': {'digits': 3, 'duration': 3},
  'Normal': {'digits': 4, 'duration': 2},
  'Hard': {'digits': 6, 'duration': 1},
};

// 電話番号モードの入力制限時間（秒）
const int phoneModeTimeLimit = 15;

// 数字モードの難易度別入力制限時間（秒）
const Map<String, int> numberModeTimeLimits = {
  'Easy': 5,
  'Normal': 7,
  'Hard': 10,
};
