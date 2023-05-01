import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/base/models/settings_model.dart';
import 'package:flutter_project_base/config/app_states.dart';
import 'package:flutter_project_base/handlers/localization_handler.dart';
import 'package:flutter_project_base/handlers/shared_handler.dart';
import 'package:flutter_project_base/routers/navigator.dart';
import '../../utilities/theme/colors.dart';

class SettingsBloc extends Cubit<AppStates> {
  SettingsBloc() : super(Start());
  static SettingsBloc get instance => BlocProvider.of(CustomNavigator.navigatorState.currentContext!);
  init() {
    emit(Loading());
    // init theme
    String theme = SharedHandler.instance!.getData(key: SharedKeys().theme, valueType: ValueType.string);
    if (theme.isEmpty) {
      settingsModel.theme = ColorsThemeType.lightTheme;
    } else {
      settingsModel.theme = _themeTypeFromString(theme);
    }
    // init lang
    String lang = SharedHandler.instance!.getData(key: SharedKeys().lang, valueType: ValueType.string);
    settingsModel.lang = (lang != "") ? lang : "en";
    emit(Done());
  }

  SettingsModel settingsModel = SettingsModel(lang: "en", theme: ColorsThemeType.lightTheme);

  set updateLang(String value) {
    if (value != currentLang()) SharedHandler.instance!.setData(SharedKeys().lang, value: value);
    settingsModel.lang = value;
    emit(Done());
  }

  // observer value setters
  set updateTheme(ColorsThemeType value) {
    SharedHandler.instance!.setData(SharedKeys().theme, value: value.toString());
    settingsModel.theme = value;
    emit(Done());
  }

  ColorsThemeType _themeTypeFromString(String value) {
    if (value == ColorsThemeType.darkTheme.toString()) {
      return ColorsThemeType.darkTheme;
    } else {
      return ColorsThemeType.lightTheme;
    }
  }
}
