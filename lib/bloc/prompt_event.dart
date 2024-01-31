part of 'prompt_bloc.dart';

@immutable
sealed class PromptEvent {}

class PromptEnteredEvent extends PromptEvent {
  final String prompt;
  final Uint8List image;

  PromptEnteredEvent({required this.image, required this.prompt});
}

class PromptInitialEvent extends PromptEvent {}
