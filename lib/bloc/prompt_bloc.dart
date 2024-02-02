import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/repository/prompt_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
part 'prompt_event.dart';
part 'prompt_state.dart';

class PromptBloc extends Bloc<PromptEvent, PromptState> {
  PromptBloc() : super(PromptInitial()) {
    on<PromptInitialEvent>(
      (event, emit) async {
        try {
          //!
          final ByteData bytes = await rootBundle.load('assets/peakpx.jpg');
          final Uint8List list = bytes.buffer.asUint8List();

          emit(PromptGeneratingImageSuccessState(uint8list: list));
        } catch (e) {
          rethrow;
        }
      },
    );
    on<PromptEnteredEvent>((event, emit) async {
      emit(PromptGeneratingImageLoadState());
      Uint8List? uint8List =
          await PromptRepo.generateImage(event.prompt, event.image);

      if (uint8List != null) {
        try {
          emit(PromptGeneratingImageSuccessState(uint8list: uint8List));
        } catch (e) {
          emit(PromptGeneratingImageErrorState());
        }
      } else {
        emit(PromptGeneratingImageErrorState());
      }
    });
    on<PromptUploadedEvent>((event, emit) {
      emit(PromptGeneratingImageSuccessState(uint8list: event.image));
    });
  }
}
