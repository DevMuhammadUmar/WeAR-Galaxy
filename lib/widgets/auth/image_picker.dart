import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';


class PickImageWidget extends StatelessWidget {
  const PickImageWidget({super.key, this.pickedImage, required this.function});
  final XFile? pickedImage;
  final Function function;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(
              18.0,
            ),
            child: pickedImage == null
                ? Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(
                        18.0,
                      ),
                    ),
                  )
                : Image.file(
                    File(pickedImage!.path),
                    fit: BoxFit.fill,
                  ),
          ),
        ),
        Positioned(
          top: 0,
          right: 0,
          child: Material(
            borderRadius: BorderRadius.circular(12.0),
            color: const Color.fromARGB(255, 188, 3, 244),
            child: InkWell(
              borderRadius: BorderRadius.circular(12.0),
              onTap: () {
                function();
               },
              splashColor: Colors.red,
              child: const Padding(
                padding: EdgeInsets.all(6.0),
                child: Icon(
                  Icons.camera_alt_rounded,
                  size: 20,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
