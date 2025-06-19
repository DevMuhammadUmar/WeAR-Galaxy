import 'dart:io';
import 'package:flutter/material.dart';
import 'package:deepar_flutter/deepar_flutter.dart';
import 'package:weargalaxy/consts/constants.dart';
import 'package:weargalaxy/services/assets_manager.dart';
import '../data/filter_data.dart'; // Update with your actual path

class ArScreen extends StatefulWidget {
  static const routeName = "/ARScreen";
  const ArScreen({super.key});

  @override
  State<ArScreen> createState() => _ArScreenState();
}

class _ArScreenState extends State<ArScreen> {
  final deepArController = DeepArController();

  Future<void> initializeController() async {
    await deepArController.initialize(
      androidLicenseKey: licenseKey,
      iosLicenseKey: '',
      resolution: Resolution.high,
    );
  }

  // Updated buildButtons with only the camera switch button
  Widget buildButtons() => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconButton(
            onPressed: deepArController.flipCamera,
            icon: const Icon(
              Icons.flip_camera_ios_outlined,
              size: 34,
              color: Colors.white,
            ),
          ),
        ],
      );

  Widget buildCameraPreview() => SizedBox(
        height: MediaQuery.of(context).size.height * 0.68,
        child: Transform.scale(
          scale: 1.5,
          child: DeepArPreview(deepArController),
        ),
      );

  Widget buildFilters() => SizedBox(
        height: MediaQuery.of(context).size.height * 0.1,
        child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.horizontal,
            itemCount: filters.length,
            itemBuilder: (context, index) {
              final filter = filters[index];
              final effectFile =
                  File('assets/filters/${filter.filterPath}').path;
              return InkWell(
                onTap: () => deepArController.switchEffect(effectFile),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    width: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      image: DecorationImage(
                        image:
                            AssetImage('assets/previews/${filter.imagePath}'),
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
              );
            }),
      );

  @override
  void dispose() {
    deepArController.destroy();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.asset(
          AssetsManager.wgb,
          height: 120,
        ),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: initializeController(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Stack(
              children: [
                // Camera preview and controls
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    buildCameraPreview(),
                    buildButtons(),  // Camera switch button only
                    buildFilters(),  // Filters section
                  ],
                ),
              ],
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
