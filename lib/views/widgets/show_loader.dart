import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infosha/views/colors.dart';

class LoaderDialog extends StatelessWidget {
  const LoaderDialog({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      contentPadding: const EdgeInsets.all(50),
      backgroundColor: Colors.transparent,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      children: <Widget>[
        Container(
          height: MediaQuery.of(context).size.height * 0.2,
          decoration: BoxDecoration(
              color: Colors.transparent,
              borderRadius: BorderRadius.circular(10)),
          child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                    child: CircularProgressIndicator(
                  color: baseColor,
                ))
              ]),
        )
      ],
    );
  }

  showLoader() {
    Get.dialog(
      const LoaderDialog(),
    );
  }

  hideLoader() {
    Get.close(1);
  }
}
