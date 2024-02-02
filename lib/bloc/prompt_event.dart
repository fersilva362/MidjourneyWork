part of 'prompt_bloc.dart';

@immutable
sealed class PromptEvent {}

class PromptEnteredEvent extends PromptEvent {
  final String prompt;
  final Uint8List image;

  PromptEnteredEvent({required this.image, required this.prompt});
}

class PromptInitialEvent extends PromptEvent {}

class PromptUploadedEvent extends PromptEvent {
  final Uint8List image;

  PromptUploadedEvent({required this.image});
}

class PromptPostEvent extends PromptEvent {
  final Uint8List uint8list;

  PromptPostEvent({required this.uint8list});
}
