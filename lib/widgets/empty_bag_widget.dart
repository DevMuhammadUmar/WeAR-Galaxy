import 'package:flutter/material.dart';
import 'package:weargalaxy/widgets/subtitles_text.dart';
import 'package:weargalaxy/widgets/titles_text.dart';

class EmptyBagWidget extends StatelessWidget {
  final String imagePath, title, subtitle, buttonText;
  const EmptyBagWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    
    // Get the current theme
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.only(top: 50),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Center content vertically
        crossAxisAlignment: CrossAxisAlignment.center, // Center content horizontally
        children: [
          Image.asset(
            imagePath,
            height: size.height * 0.25,
            width: double.infinity,
          ),
          TitleTextWidget(
            label: 'Ooops !',
            fontSize: 40,
            color: isDarkMode ? Colors.white : const Color.fromARGB(255, 79, 0, 143), // Change based on theme
          ),
          SubtitleTextWidget(
            label: title,
            fontWeight: FontWeight.w600,
            fontSize: 25,
            color: isDarkMode ? Colors.white : Colors.black, // Change based on theme
          ),
          SizedBox(
            height: 20,
          ),
          // Wrap subtitle with Padding and apply dynamic text color
        Padding(
  padding: const EdgeInsets.symmetric(horizontal: 50),
  child: Text(
    subtitle,  // Displaying the subtitle as text
    textAlign: TextAlign.center,  // This will justify the text
    style: TextStyle(
      fontWeight: FontWeight.w400,
      fontSize: 20,
      fontFamily: "poppins",
      color: isDarkMode ? Colors.white70 : Colors.black87,  // Change color based on theme
    ),
  ),
),

          SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.all(20),
            ),
            onPressed: () {},
            child: Text(
              buttonText,
              style: TextStyle(
                fontSize: 16,
                fontFamily: "Poppins",
                color: isDarkMode ? Colors.white : Colors.black, // Button text color based on theme
              ),
            ),
          ),
        ],
      ),
    );
  }
}
