import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/config/app_events.dart';
import 'package:flutter_project_base/config/app_states.dart';
import 'package:flutter_project_base/services/add_meals/models/element_model.dart';

class AddMealBloc extends Bloc<AppEvents, AppStates> {
  AddMealBloc() : super(Start()) {
    on<Update>(_update);
  }

  TextEditingController name = TextEditingController();
  ScrollController scrollController = ScrollController();
  String? mealName;
  bool mealNameValidation = true;
  List<MealElementModel> elements = [
    MealElementModel(),
  ];
  bool mealElementsValidation = true;

  addElement() {
    elements.add(MealElementModel());
    scrollController.animateTo(
      scrollController.position.maxScrollExtent + 360,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    add(Update());
  }

  removeElement(int index) {
    elements.removeAt(index);
    scrollController.animateTo(
      scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 500),
      curve: Curves.ease,
    );
    add(Update());
  }

  _update(AppEvents events, Emitter emit) {
    emit(Start());
  }
}
