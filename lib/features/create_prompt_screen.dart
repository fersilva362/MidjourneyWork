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

    final widthScreen = MediaQuery.of(context).size.width;
    print(widthScreen);

    return Scaffold(
        appBar: AppBar(
          title: const Text('My AI Journey Work'),
          centerTitle: true,
        ),
        body: BlocConsumer<PromptBloc, PromptState>(
          bloc: promptBloc,
          listener: (context, state) {},
          builder: (context, state) {
            switch (state.runtimeType) {
              // Loading State
              case PromptGeneratingImageLoadState:
                return const Center(child: CircularProgressIndicator());
              //error State
              case PromptGeneratingImageErrorState:
                return const Center(child: Text('Something went wrong'));
              //Success
              case PromptGeneratingImageSuccessState:
                final stateSuccess = state as PromptGeneratingImageSuccessState;
                Uint8List data = stateSuccess.uint8list;

                return Center(
                  child: Container(
                    /* margin: const EdgeInsets.only(right: 10, left: 10), */
                    width: (widthScreen > 500) ? 500 : double.maxFinite,
                    child: Column(
                      children: [
                        //Image display-box
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: MemoryImage(data), fit: BoxFit.fill),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ), //Button upload image
                        Container(
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  _imagePicker();
                                },
                                icon: const Icon(
                                  Icons.image_outlined,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'My Image',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              const VerticalDivider(
                                color: Color.fromRGBO(59, 61, 83, 1),
                                thickness: 1,
                              ),
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.save_alt_outlined,
                                  color: Colors.white,
                                ),
                                label: const Text(
                                  'save',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Divider(
                          color: Color.fromRGBO(59, 61, 83, 1),
                        ),

                        Container(
                          height: 200,
                          padding: const EdgeInsets.all(10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (controller.text.isNotEmpty) {
                                    promptBloc.add(
                                      PromptEnteredEvent(
                                        prompt: controller.text,
                                        image: data,
                                      ),
                                    );
                                  }
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              Color.fromRGBO(91, 105, 225, 1),
                                              Color.fromRGBO(172, 125, 248, 1)
                                            ]),
                                        borderRadius:
                                            BorderRadius.circular(50)),
                                    height: 35,
                                    width: double.maxFinite,
                                    padding: const EdgeInsets.all(8),
                                    child: const Center(
                                      child: Text(
                                        'Generate',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    )),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              //Text field

                              const Text(
                                'Enter prompt of your imagination',
                                style: TextStyle(
                                  color: Color.fromRGBO(143, 149, 167, 1),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextField(
                                cursorColor: Color.fromRGBO(172, 125, 248, 1),
                                decoration: const InputDecoration(
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromRGBO(
                                                172, 125, 248, 1))),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)))),
                                style: const TextStyle(
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                controller: controller,
                              ),
                              // Button Generate
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
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