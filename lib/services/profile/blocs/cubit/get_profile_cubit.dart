import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/base/failure.dart';
import 'package:flutter_project_base/services/profile/models/appointment_model.dart';

import '../../../../base/base_state.dart';
import '../../../../config/api_names.dart';
import '../../../../network/network_handler.dart';

class GetProfileCubit extends Cubit<BaseState<UserModel>> {
  GetProfileCubit() : super(const BaseState());

  void getProfileDetails() async {
    try {
      emit(const BaseState(status: BaseStatus.inProgress));

      final Response? response = await NetworkHandler.instance?.get(
        url: ApiNames.getProfileDetails,
        withToken: true,
      );

      if (response == null) return;
      emit(BaseState(
          status: BaseStatus.success,
          item: UserModel.fromJson(
            response.data['data'],
          )));
    } on DioError catch (e) {
      String? msg = e.response?.data.toString();

      if (e.response?.data is Map &&
          (e.response?.data as Map).containsKey('errors')) {
        msg = e.response?.data['errors'].toString();
      }
      final failure = Failure(message: msg);

      emit(BaseState(status: BaseStatus.failure, failure: failure));
    }
  }
}
