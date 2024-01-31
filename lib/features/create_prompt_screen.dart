// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/bloc/prompt_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class ScreenPrompt extends StatefulWidget {
  const ScreenPrompt({super.key});

  @override
  State<ScreenPrompt> createState() => _ScreenPromptState();
}

class _ScreenPromptState extends State<ScreenPrompt> {
  late TextEditingController controller;
  PromptBloc promptBloc = PromptBloc();
  Uint8List webImage = Uint8List(8);

  @override
  void initState() {
    super.initState();
    promptBloc.add(PromptInitialEvent());
    controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
//Function to upload images
    Future<void> _imagePicker() async {
      try {
        final ImagePicker _imagePicker = ImagePicker();
        XFile? _image =
            await _imagePicker.pickImage(source: ImageSource.gallery);
        if (_image != null) {
          var f = await _image.readAsBytes();
          setState(() {
            webImage = f;
            promptBloc.add(PromptUploadedEvent(image: webImage));
          });
        } else {
          print('no image has been picked');
        }
      } catch (e) {
        print('no image has been found');
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('MidJourney'),
        ),
        body: BlocConsumer<PromptBloc, PromptState>(
          bloc: promptBloc,
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.runtimeType) {
              // Loading State
              case PromptGeneratingImageLoadState:
                return const CircularProgressIndicator();
              //error State
              case PromptGeneratingImageErrorState:
                return const Center(child: Text('Something went wrong'));
              //Success
              case PromptGeneratingImageSuccessState:
                final stateSuccess = state as PromptGeneratingImageSuccessState;
                Uint8List data = stateSuccess.uint8list;
                return Column(
                  children: [
                    //Image display-box
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: MemoryImage(data), fit: BoxFit.contain),
                        ),
                      ),
                    ),

                    Container(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        children: [
                          //Button upload image
                          ElevatedButton(
                            onPressed: () {
                              _imagePicker();
                            },
                            child: const Text('Upload image'),
                          ),

                          //Text field
                          TextField(
                            controller: controller,
                          ),
                          // Button Generate
                          ElevatedButton(
                            onPressed: () {
                              promptBloc.add(
                                PromptEnteredEvent(
                                  prompt: controller.text,
                                  image: data,
                                ),
                              );
                            },
                            child: const Text('Generate'),
                          ),
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