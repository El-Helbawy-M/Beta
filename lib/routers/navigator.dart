import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/routers/routers.dart';
import 'package:flutter_project_base/services/add_meals/blocs/add_meal_bloc.dart';
import 'package:flutter_project_base/services/add_medicin/blocs/add_medicin_bloc.dart';
import 'package:flutter_project_base/services/add_pressure/pages/add_pressure_page.dart';
import 'package:flutter_project_base/services/chat_room/pages/chat_room_page.dart';
import 'package:flutter_project_base/services/medicins_list/pages/medicine_list_page.dart';
import 'package:flutter_project_base/services/onboarding/blocs/onboarding_bloc.dart';
import 'package:flutter_project_base/services/onboarding/pages/on_boarding.dart';
import 'package:flutter_project_base/services/pressures_list/pages/pressures_list_page.dart';
import 'package:flutter_project_base/services/video_call/pages/audio_call_page.dart';

import '../base/pages/base_page.dart';
import '../services/add_diabetes/pages/add_diabetes_page.dart';
import '../services/add_meals/pages/add_meal_page.dart';
import '../services/add_medicin/pages/add_medicin_page.dart';
import '../services/authentication/login/pages/login.dart';
import '../services/authentication/register/pages/registration_page.dart';
import '../services/diabtes_list/pages/diabetes_details.dart';
import '../services/doctor_details/pages/doctor_details_page.dart';
import '../services/food_list/pages/food_list_page.dart';
import '../services/splash/pages/splash_page.dart';
import '../services/video_call/pages/video_call_page.dart';

const begin = Offset(0.0, 1.0);
const end = Offset.zero;
const curve = Curves.easeInOut;
var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

class CustomNavigator {
  static final GlobalKey<NavigatorState> navigatorState =
      GlobalKey<NavigatorState>();
  static final RouteObserver<PageRoute> routeObserver =
      RouteObserver<PageRoute>();
  static final GlobalKey<ScaffoldMessengerState> scaffoldState =
      GlobalKey<ScaffoldMessengerState>();

  static _pageRoute(Widget screen) => PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => screen,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      );

  static Route<dynamic> onCreateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.login:
        return _pageRoute(const LoginPage());
      case Routes.addMedicines:
        return _pageRoute(BlocProvider(
          create: (context) => AddMedicinBloc(),
          child: const AddMedicinPage(),
        ));
      case Routes.register:
        return _pageRoute(const RegistrationPage());
      case Routes.splash:
        return _pageRoute(const SplashPage());
      case Routes.boarding:
        return _pageRoute(BlocProvider(
            create: (context) => OnBoardingCubit(),
            child: const OnBoardingPage()));
      case Routes.home:
        return _pageRoute(const BasePage());
      case Routes.diabtesList:
        return _pageRoute(const DiabetesListPage());
      case Routes.doctorDetails:
        int doctorID = settings.arguments as int;
        return _pageRoute(DoctorDetailsPage(doctorID));
      case Routes.addNewDiabte:
        return _pageRoute(const AddDiabetesPage());
      case Routes.addPressure:
        return _pageRoute(const AddPressurePage());
      case Routes.addMeal:
        return _pageRoute(BlocProvider(
          create: (context) => AddMealBloc(),
          child: const AddMealPage(),
        ));
      case Routes.pressuresList:
        return _pageRoute(const PressuresListPage());
      case Routes.medicinesList:
        return _pageRoute(const MedicinesListPage());
      case Routes.foodList:
        return _pageRoute(const FoodListPage());
      case Routes.videoCall:
        return _pageRoute(const VideoCallPage());
      case Routes.voiceCall:
        return _pageRoute(const AudioCallPage());
      case Routes.chatRoom:
        final List args = settings.arguments as List;
        return _pageRoute(
          ChatRoomPage(
            args[0],
            userId: args[1],
          ),
        );
    }
    return MaterialPageRoute(builder: (_) => Container());
  }

  static pop({dynamic result}) {
    if (navigatorState.currentState!.canPop()) {
      navigatorState.currentState!.pop(result);
    }
  }

  static push(String routeName,
      {arguments, bool replace = false, bool clean = false}) {
    if (clean) {
      return navigatorState.currentState!.pushNamedAndRemoveUntil(
          routeName, (_) => false,
          arguments: arguments);
    } else if (replace) {
      return navigatorState.currentState!
          .pushReplacementNamed(routeName, arguments: arguments);
    } else {
      return navigatorState.currentState!
          .pushNamed(routeName, arguments: arguments);
    }
  }
}
