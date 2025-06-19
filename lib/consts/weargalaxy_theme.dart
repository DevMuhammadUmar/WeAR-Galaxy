import 'package:flutter/material.dart';
import 'package:weargalaxy/consts/weargalaxy_appcolors.dart';

class Styles{
  static ThemeData themeData({required bool isDarkTheme, required BuildContext context}){
    return ThemeData(
      scaffoldBackgroundColor: isDarkTheme
       ? AppColors.darkScaffoldColor
       :AppColors.lightScaffoldColor,
      cardColor: isDarkTheme 
      ?AppColors.darkPrimary
      :AppColors.lightCardColor,
      brightness: isDarkTheme ? Brightness.dark:Brightness.light,
      appBarTheme: AppBarTheme(
        elevation: 0,
        backgroundColor: isDarkTheme 
        ? AppColors.darkPrimary
        : AppColors.darkPrimary,
      ),
      
  elevatedButtonTheme: ElevatedButtonThemeData(
  style: ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color>(
      (states) {
        if (states.contains(WidgetState.pressed)) {
          return isDarkTheme
              ? const Color.fromARGB(255, 70, 70, 70) // Brighter pressed dark shade
              : const Color.fromARGB(255, 220, 220, 220); // Brighter pressed light shade
        }
        return isDarkTheme
            ? const Color.fromARGB(255, 50, 50, 50) // Slightly lighter dark button
            : Colors.white; // Light button
      },
    ),
    foregroundColor: WidgetStateProperty.resolveWith<Color>(
      (states) => isDarkTheme ? Colors.white : Colors.black,
    ),
    overlayColor: WidgetStateProperty.all(
      isDarkTheme
          ? const Color.fromARGB(80, 255, 255, 255) // Subtle white highlight on dark theme
          : const Color.fromARGB(80, 0, 0, 0), // Subtle black highlight on light theme
    ),
    shape: WidgetStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0), // Fully rounded ends
      ),
    ),
    elevation: WidgetStateProperty.all(10.0), // Higher elevation for a darker shadow
    shadowColor: WidgetStateProperty.resolveWith<Color>(
      (states) => isDarkTheme
          ? Colors.black.withOpacity(0.8) // Darker shadow in dark theme
          : Colors.grey.withOpacity(0.6), // Darker shadow in light theme
    ),
    padding: WidgetStateProperty.all(
      const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0), // Larger padding for bigger buttons
    ),
    textStyle: WidgetStateProperty.all(
      const TextStyle(
        fontSize: 16.0, // Larger font size for visibility
        fontWeight: FontWeight.bold, // Bold text for better emphasis
      ),
    ),
  ),
),

iconTheme: IconThemeData(
  color: isDarkTheme? Colors.white:Colors.white,
)

    );
  }
}