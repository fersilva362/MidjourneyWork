import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
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
          final ByteData bytes = await rootBundle.load('assets/best.png');
          final Uint8List list = bytes.buffer.asUint8List();

          emit(PromptGeneratingImageSuccessState(uint8list: list));
        } catch (e) {
          print('error PromptInitialEvent ');
        }
      },
    );
    on<PromptEnteredEvent>((event, emit) async {
      emit(PromptGeneratingImageLoadState());
      Uint8List? uint8List = await PromptRepo.generateImage(event.prompt);
      print(uint8List.toString());
      if (uint8List != null) {
        try {
          emit(PromptGeneratingImageSuccessState(uint8list: uint8List));
        } catch (e) {
          print(' error PromptEnteredEvent');
          emit(PromptGeneratingImageErrorState());
        }
      } else {
        emit(PromptGeneratingImageErrorState());
        print('error in try/catch of PromptEnteredEvent');
      }
    });
  }
}