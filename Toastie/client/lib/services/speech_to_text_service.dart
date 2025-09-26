import 'package:flutter/foundation.dart';
import 'package:speech_to_text/speech_to_text.dart';

enum SpeechToTextState {
  idle,
  listening,
  thinking,
  error,
}

class SpeechToTextService extends ChangeNotifier {
  late final SpeechToText _speechToText = SpeechToText();

  bool _speechEnabled = false;
  String _transcription = '';
  double _confidenceLevel = 0; // Currently not being used
  SpeechToTextState _state = SpeechToTextState.idle;
  String? _errorMessage;

  // Getters
  bool get speechEnabled => _speechEnabled;
  String get transcription => _transcription;
  double get confidenceLevel => _confidenceLevel;
  SpeechToTextState get state => _state;
  String? get errorMessage => _errorMessage;
  bool get isListening => _speechToText.isListening;
  bool get isNotListening => _speechToText.isNotListening;
  String get statusMessage => getStatusMessage();

  @override
  void dispose() {
    _speechToText.stop();
    super.dispose();
  }

  Future<bool> initialize() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onError: (error) {
          _errorMessage = error.errorMsg;
          _setStateAndNotifyListeners(SpeechToTextState.error);
        },
        onStatus: (status) {
          if (status == 'done') {
            _setStateAndNotifyListeners(SpeechToTextState.idle);
          }
        },
      );
      _setStateAndNotifyListeners(SpeechToTextState.idle);
      return _speechEnabled;
    } catch (e) {
      _errorMessage = e.toString();
      _setStateAndNotifyListeners(SpeechToTextState.error);
      return false;
    }
  }

  Future<void> startListening({
    Function(String)? onPartialResult,
    Function(String)? onFinalResult,
  }) async {
    if (!_speechEnabled) return;

    _setStateAndNotifyListeners(SpeechToTextState.listening);

    try {
      _clearError();

      await _speechToText.listen(
        onResult: (result) {
          _transcription = result.recognizedWords;
          _confidenceLevel = result.confidence;

          if (result.finalResult) {
            onFinalResult?.call(_transcription);
          } else {
            onPartialResult?.call(_transcription);
          }

          notifyListeners();
        },
      );
    } catch (e) {
      _errorMessage = e.toString();
      _setStateAndNotifyListeners(SpeechToTextState.error);
    }
  }

  Future<void> stopListening() async {
    if (_speechToText.isListening) {
      await _speechToText.stop();
      _setStateAndNotifyListeners(SpeechToTextState.idle);
    }
  }

  void clearTranscription() {
    _transcription = '';
    _confidenceLevel = 0;
    _clearError();
    notifyListeners();
  }

  String getStatusMessage() {
    switch (_state) {
      case SpeechToTextState.idle:
        return _speechEnabled
            ? 'Tap to start recording...'
            : 'Speech not available. Update your microphone permission in Settings.';
      case SpeechToTextState.listening:
        return 'Recording...';
      case SpeechToTextState.thinking:
        return 'Thinking...';
      case SpeechToTextState.error:
        return _errorMessage ?? 'An error occurred';
    }
  }

  void _setStateAndNotifyListeners(SpeechToTextState newState) {
    _state = newState;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    if (_state == SpeechToTextState.error) {
      _setStateAndNotifyListeners(SpeechToTextState.idle);
    }
  }

  void reset() {
    stopListening();
    clearTranscription();
    _clearError();
  }
}
