import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class Ratingscreen extends StatefulWidget {
  const Ratingscreen({super.key});

  @override
  State<Ratingscreen> createState() => _RatingscreenState();
}

class _RatingscreenState extends State<Ratingscreen> {
  XFile? imageFile;
  double rating = 0;
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  var picker = ImagePicker();

  Future<void> showInformationDialogue(BuildContext) async {
    return await showDialog(
        context: context,
        builder: (context) {
          final TextEditingController _textEditingController =
              TextEditingController();
          // bool isChecked = false;
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                // insetPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28)),
                content: SingleChildScrollView(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(margin: const EdgeInsets.all(10)),
                        Image.asset('assets/Images/InfoshaGirlImage.png'),
                        const SizedBox(height: 12),
                        Text('Rate'.tr),
                        const SizedBox(height: 12),
                        RatingBar.builder(
                          initialRating: 0,
                          direction: Axis.horizontal,
                          itemCount: 5,
                          itemSize: 24,
                          itemPadding: const EdgeInsets.symmetric(
                            horizontal: 3,
                          ),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.yellow,
                          ),
                          onRatingUpdate: (rating) {
                            setState(() {
                              this.rating = rating;
                            });
                          },
                        ),
                        SizedBox(height: Get.height * 0.03),
                        TextFormField(
                          controller: _textEditingController,
                          validator: (value) {
                            if (value!.trim().isEmpty) {
                              return "Please write comment".tr;
                            }
                          },
                          decoration: InputDecoration(
                            labelText: 'Nickname'.tr,
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        imageFile != null
                            ? Image.file(
                                File(
                                  imageFile!.path,
                                ),
                                height: 50,
                              )
                            : Container(),
                        TextFormField(
                          minLines: 1,
                          maxLines: 3,
                          keyboardType: TextInputType.multiline,
                          decoration: InputDecoration(
                            hintText: 'Write Comment Here...',
                            // icon: Icon(Icons.camera_alt_outlined),
                            suffixIcon: InkWell(
                              child: Icon(Icons.camera_alt_outlined),
                              onTap: () {
                                _getFromCamera(ImageSource.gallery);
                              },
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        SizedBox(
                          width: 296,
                          height: 40,
                          child: ElevatedButton(
                            onPressed: () {},
                            child: Text('Submit'),
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Color(0xFF1B2870)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // body: ElevatedButton(
        //     onPressed: () async {
        //       await showInformationDialogue(BuildContext);
        //     },
        //     child: Column(
        //       children: [],
        //     )),
        );
  }

  _getFromCamera(src) async {
    XFile? pickedFile = await picker.pickImage(source: src);
    if (pickedFile != null) {
      setState(() {
        imageFile = pickedFile;
      });
    }
  }
}
