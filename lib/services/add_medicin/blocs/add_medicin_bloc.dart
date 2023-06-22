import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/base/models/select_option.dart';
import 'package:flutter_project_base/config/app_events.dart';
import 'package:flutter_project_base/config/app_states.dart';
import 'package:flutter_project_base/routers/navigator.dart';

class AddMedicinBloc extends Bloc<AppEvents, AppStates> {
  AddMedicinBloc() : super(Start()) {
    on<Update>(_update);
    on<Next>(_goToNextPage);
    on<Back>(_goToPrivousPage);
  }

  //================================================== Veriables ===============================
  int pageIndex = 1;
  //=====================
  bool isTablets = false;
  String? name;
  bool nameValidation = true;
  DateTime? startDate;
  bool startDateValidation = true;
  num? duration;
  bool durationValidation = true;
  List<String> days = [];
  bool daysValidation = true;
  num? turns;
  bool turnsValidation = true;
  SelectOption? insulenType;
  bool insulnumypeValidation = true;
  //=============================================================================================
  //================================================== Internal Functions =======================

  bool _checkDurationStep() {
    durationValidation = duration != null && duration != 0;
    daysValidation = days.isNotEmpty;
    startDateValidation = startDate != null;
    turnsValidation = turns != null && turns != 0;
    return durationValidation &&
        daysValidation &&
        turnsValidation &&
        startDateValidation;
  }

  bool _checkMedicinDetailsStep() {
    nameValidation = name != null && name != "";

    if (!isTablets) {
      if (name == "انسولين") insulnumypeValidation = insulenType != null;
      return nameValidation &&
          (name == "انسولين" ? insulnumypeValidation : true);
    }
    return nameValidation;
  }

  //=============================================================================================
  //============================================== Events Callbacks =============================
  void _update(AppEvents event, Emitter emit) {
    emit(Start());
  }

  void _goToNextPage(AppEvents event, Emitter emit) {
    switch (pageIndex) {
      case 1:
        if (_checkDurationStep()) {
          pageIndex++;
        }
        add(Update());
        break;
      case 2:
        if (_checkMedicinDetailsStep()) {
          CustomNavigator.pop();
        }
        add(Update());
    }
  }

  void _goToPrivousPage(AppEvents event, Emitter emit) {
    pageIndex--;
    add(Update());
  }
  //=============================================================================================
}
