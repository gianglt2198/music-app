import 'dart:io';

import 'package:client/core/themes/app_pallete.dart';
import 'package:client/core/utils/util.dart';
import 'package:client/core/widgets/custom_text_field.dart';
import 'package:client/core/widgets/loader.dart';
import 'package:client/features/home/view/pages/home_page.dart';
import 'package:client/features/home/view/widgets/audio_waves.dart';
import 'package:client/features/home/viewmodel/home_viewmodel.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flex_color_picker/flex_color_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UploadSongPage extends ConsumerStatefulWidget {
  const UploadSongPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _UploadSongPageState();
}

class _UploadSongPageState extends ConsumerState<ConsumerStatefulWidget> {
  final _songNameController = TextEditingController();
  final _artistController = TextEditingController();
  Color _selectedColor = Pallete.greyColor;
  File? selectedImage;
  File? selectedAudio;
  final formKey = GlobalKey<FormState>();

  void selectAudio() async {
    final pickedAudio = await pickAudio();
    if (pickedAudio != null) {
      setState(() {
        selectedAudio = pickedAudio;
      });
    }
  }

  void selectImage() async {
    final pickedImage = await pickImage();
    if (pickedImage != null) {
      setState(() {
        selectedImage = pickedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref
        .watch(homeViewModelProvider.select((val) => val?.isLoading == true));

    return Scaffold(
        appBar: AppBar(
          title: const Text("Upload Song"),
          actions: [
            IconButton(
                onPressed: () async {
                  if (formKey.currentState!.validate() &&
                      selectedAudio != null &&
                      selectedImage != null) {
                    ref.read(homeViewModelProvider.notifier).uploadSong(
                          selectedAudio: selectedAudio!,
                          selectedImage: selectedImage!,
                          songName: _songNameController.text,
                          artist: _artistController.text,
                          hexCode: _selectedColor,
                        );
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } else {
                    showSnackBar(context, 'Missing field!');
                  }
                },
                icon: const Icon(Icons.check))
          ],
        ),
        body: isLoading
            ? const Loader()
            : SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: selectImage,
                          child: selectedImage != null
                              ? SizedBox(
                                  height: 150,
                                  width: double.infinity,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(
                                      selectedImage!,
                                      fit: BoxFit.cover,
                                    ),
                                  ))
                              : DottedBorder(
                                  color: Pallete.borderColor,
                                  radius: const Radius.circular(10),
                                  borderType: BorderType.RRect,
                                  strokeCap: StrokeCap.round,
                                  dashPattern: const [4, 10],
                                  child: const SizedBox(
                                    height: 150,
                                    width: double.infinity,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.folder_copy,
                                          size: 40,
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          'Select the thumbnail',
                                          style: TextStyle(
                                            fontSize: 15,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        selectedAudio != null
                            ? AudioWave(path: selectedAudio!.path)
                            : CustomTextField(
                                controller: null,
                                hintText: 'Pick Song',
                                readOnly: true,
                                onTap: selectAudio,
                              ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _songNameController,
                          hintText: 'Song Name',
                        ),
                        const SizedBox(height: 20),
                        CustomTextField(
                          controller: _artistController,
                          hintText: 'Artist',
                        ),
                        ColorPicker(
                            color: _selectedColor,
                            onColorChanged: (Color color) {
                              setState(() {
                                _selectedColor = color;
                              });
                            })
                      ],
                    ),
                  ),
                ),
              ));
  }
}
