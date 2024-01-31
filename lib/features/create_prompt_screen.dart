import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/prompt_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenPrompt extends StatefulWidget {
  const ScreenPrompt({super.key});

  @override
  State<ScreenPrompt> createState() => _ScreenPromptState();
}

class _ScreenPromptState extends State<ScreenPrompt> {
  late TextEditingController controller;
  PromptBloc promptBloc = PromptBloc();

  @override
  void initState() {
    super.initState();
    promptBloc.add(PromptInitialEvent());
    controller = TextEditingController();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('MidJourney'),
        ),
        body: BlocConsumer<PromptBloc, PromptState>(
          bloc: promptBloc,
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.runtimeType) {
              case PromptGeneratingImageLoadState:
                return const CircularProgressIndicator();
              case PromptGeneratingImageErrorState:
                return const Center(child: Text('Something went wrong'));
              case PromptGeneratingImageSuccessState:
                final stateSuccess = state as PromptGeneratingImageSuccessState;
                Uint8List data = stateSuccess.uint8list;
                return Column(
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: MemoryImage(data),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          TextField(
                            controller: controller,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                promptBloc.add(
                                  PromptEnteredEvent(
                                    prompt: controller.text,
                                    image: data,
                                  ),
                                );
                              },
                              child: const Text('Generate'))
                        ],
                      ),
                    )
                  ],
                );
              default:
                return const Center(
                    child: Text('Something went wrong and went to default'));
            }
          },
        ));
  }
}


/*  */



          /*  */