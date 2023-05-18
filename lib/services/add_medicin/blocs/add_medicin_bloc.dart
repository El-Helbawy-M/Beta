import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/config/app_events.dart';
import 'package:flutter_project_base/config/app_states.dart';

class AddMedicinBloc extends Bloc<AppEvents, AppStates> {
  AddMedicinBloc() : super(Start());

  bool isTablets = false;

  String? name;
  bool nameValidation = true;
  String? startDate;
  bool startDateValidation = true;
  int? duration;
  bool durationValidation = true;
  List<String> days = [];
  bool daysValidation = true;
  int? turns;
  bool turnsValidation = true;
  String? insulinType;
  bool insulinTypeValidation = true;

  bool _checkDurationStep() {
    durationValidation = duration != null || duration != 0;
    daysValidation = days.isNotEmpty;
    turnsValidation = turns != null || turns != 0;
    return durationValidation && daysValidation && turnsValidation;
  }

  bool _checkMedicinDetailsStep() {
    nameValidation = name != null || name != "";
    startDateValidation = startDate != null || startDate != "";
    if (!isTablets) {
      insulinTypeValidation = insulinType != null || insulinType != "";
      return nameValidation && startDateValidation && insulinTypeValidation;
    }
    return nameValidation && startDateValidation;
  }
}
