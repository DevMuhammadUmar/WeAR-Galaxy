import 'package:flutter/material.dart';
import 'package:weargalaxy/widgets/subtitles_text.dart';
import 'package:weargalaxy/widgets/titles_text.dart';
import 'assets_manager.dart';

class WeargalaxyAppMethods {
  static Future<void> showErrorOrWarningDialog({
  required BuildContext context,
  required String subtitle,
  bool isError = true,
  required Function fct,
}) async {
  await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.0)),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                isError ? AssetsManager.error : AssetsManager.warning,
                height: 60,
                width: 60,
              ),
              const SizedBox(
                height: 16.0,
              ),
              SubtitleTextWidget(
                label: subtitle,
                fontWeight: FontWeight.w600,
              ),
              const SizedBox(
                height: 16.0,
              ),
              Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    TextButton(
      onPressed: () {
        Navigator.pop(context);
      },
      child: const SubtitleTextWidget(
        label: "Cancel",
        color: Color.fromARGB(255, 223, 0, 0),
      ),
    ),
    TextButton(
      onPressed: () {
        fct();
        Navigator.pop(context);
      },
      child: const SubtitleTextWidget(
        label: "OK",
        color: Color.fromARGB(255, 21, 139, 6),
      ),
    ),
  ],
)

            ],
          ),
        );
      });
}


  static Future<void> imagePickerDialog({
    required BuildContext context,
    required Function cameraFCT,
    required Function galleryFCT,
    required Function removeFCT,
  }) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(
              child: TitleTextWidget(
                label: "Choose option",
              ),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      cameraFCT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(Icons.camera),
                    label: const Text("Camera"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      galleryFCT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.browse_gallery,
                    ),
                    label: const Text("Gallery"),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      removeFCT();
                      if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      }
                    },
                    icon: const Icon(
                      Icons.remove_circle_outline,
                    ),
                    label: const Text("Remove"),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
