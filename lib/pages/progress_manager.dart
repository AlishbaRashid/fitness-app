// [file name]: progress_manager.dart
// [file content begin]
import 'package:flutter/material.dart';

class ProgressManager {
  static final ProgressManager _instance = ProgressManager._internal();
  late VoidCallback _updateCallback;

  factory ProgressManager() {
    return _instance;
  }

  ProgressManager._internal();

  void registerUpdateCallback(VoidCallback callback) {
    _updateCallback = callback;
  }

  void updateProgress(int workoutsCompleted, double additionalTime) {
    // This would update the home screen stats
    _updateCallback();
    }
}
// [file content end]