import 'package:flutter/material.dart';
import 'package:flutter_project_base/utilities/theme/text_styles.dart';

enum ColorsThemeType { lightTheme, darkTheme }

class ColoresThemes {
  //=========================================================================================
  //=========================================================================================
  //========================================================================================= Light Theme
  ThemeData lightTheme(String fontFamily) => ThemeData(
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: Color(0xff2D3436)),
        iconTheme: const IconThemeData(color: Color(0xff2D3436)),
        hintColor: const Color(0xffBFBFBF),
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.light(
          primary: const Color(0xff1B72C0),
          onPrimary: const Color(0xffFBFBFB),
          primaryContainer: const Color(0xffFAFAFA),
          secondary: const Color(0xff2D3436),
          onSecondary: const Color(0xffAD8B73).withOpacity(.2),
          error: const Color(0xffEA3939).withOpacity(.2),
        ),
        //=================================
        //=================================
        //================================= Text Theme
        // fontFamily: fontFamily,
        textTheme: const TextTheme(
          headline1: TextStyle(fontSize: 103, fontWeight: FontWeight.w300, letterSpacing: -1.5),
          headline2: TextStyle(fontSize: 64, fontWeight: FontWeight.w300, letterSpacing: -0.5),
          headline3: TextStyle(fontSize: 51, fontWeight: FontWeight.w400),
          headline4: TextStyle(fontSize: 36, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          headline5: TextStyle(fontSize: 26, fontWeight: FontWeight.w500),
          headline6: TextStyle(fontSize: 21, fontWeight: FontWeight.w500, letterSpacing: 0.15),
          subtitle1: TextStyle(fontSize: 17, fontWeight: FontWeight.w400, letterSpacing: 0.15),
          subtitle2: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, letterSpacing: 0.1),
          bodyText1: TextStyle(fontSize: 16, fontWeight: FontWeight.w400, letterSpacing: 0.5),
          bodyText2: TextStyle(fontSize: 14, fontWeight: FontWeight.w400, letterSpacing: 0.25),
          button: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, letterSpacing: 1.25),
          caption: TextStyle(fontSize: 12, fontWeight: FontWeight.w400, letterSpacing: 0.4),
          overline: TextStyle(fontSize: 10, fontWeight: FontWeight.w400, letterSpacing: 1.5),
        ),
        //=================================
        //=================================
        //================================= App Bar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffAD8B73),
          toolbarTextStyle: TextStyle(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        //=================================
        //=================================
        //================================= Bottom Navigation Bar Theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: Color(0xffA7A7A7),
          selectedItemColor: Color(0xffe26166),
          backgroundColor: Colors.white,
          elevation: 3,
        ),
        //=================================
        //=================================
        //================================= Page Transitions Theme
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );

  //=========================================================================================
  //=========================================================================================
  //========================================================================================= Dark Theme

  ThemeData darkTheme(String fontFamily) => ThemeData(
        progressIndicatorTheme: const ProgressIndicatorThemeData(color: Color(0xff704E37)),
        iconTheme: const IconThemeData(color: Color(0xffffffff)),
        hintColor: const Color(0xff5C5C5C),
        scaffoldBackgroundColor: const Color(0xff0d0d0d),
        colorScheme: ColorScheme.light(
          primary: const Color(0xff6f6f6f),
          onPrimary: const Color(0xff2C3639),
          secondary: const Color(0xff313b4b),
          onSecondary: const Color(0xff313b4b).withOpacity(.2),
          error: const Color(0xffEA3939).withOpacity(.2),
          // background: const Color(0xff15191d),
        ),
        //=================================
        //=================================
        //================================= Text Theme
        fontFamily: fontFamily,
        textTheme: TextTheme(
          //====================== Titles Theme
          titleLarge: const TextStyle(color: Color(0xffffffff)),
          titleMedium: const TextStyle(color: Color(0xffffffff)),
          titleSmall: AppTextStyles.w700.copyWith(
            fontSize: 12,
            color: const Color(0xffffffff),
          ),

          //====================== Bodies Theme
          bodyLarge: AppTextStyles.w600.copyWith(
            fontSize: 24,
            color: const Color.fromRGBO(255, 255, 255, .7),
          ),
          bodyMedium: AppTextStyles.w400.copyWith(
            fontSize: 12,
            color: const Color(0xffffffff).withOpacity(.7),
          ),
          bodySmall: AppTextStyles.w400.copyWith(
            fontSize: 12,
            color: const Color(0xff6f6f6f),
          ),
        ),
        //=================================
        //=================================
        //================================= App Bar Theme
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xffDCD7C9),
          toolbarTextStyle: TextStyle(color: Colors.white),
          iconTheme: IconThemeData(color: Colors.white),
          elevation: 0,
        ),
        //=================================
        //=================================
        //================================= Bottom Navigation Bar Theme
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          unselectedItemColor: Color(0xffA7A7A7),
          selectedItemColor: Color(0xffDCD7C9),
          backgroundColor: Colors.white,
          elevation: 1,
        ),
        //=================================
        //=================================
        //================================= Page Transitions Theme
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      );

  ThemeData mapColor(ColorsThemeType type, String fontFamily) {
    switch (type) {
      case ColorsThemeType.lightTheme:
        return lightTheme(fontFamily);
      case ColorsThemeType.darkTheme:
        return darkTheme(fontFamily);
    }
  }
}
