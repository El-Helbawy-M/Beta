import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/base/failure.dart';
import 'package:flutter_project_base/services/profile/models/appointment_model.dart';
import 'package:intl/intl.dart';

import '../../../../base/base_state.dart';
import '../../../../config/api_names.dart';
import '../../../../network/network_handler.dart';

class UpdateProfileCubit extends Cubit<BaseState<UserModel>> {
  UpdateProfileCubit() : super(const BaseState());

  void updateProfile({
    required String name,
    required String phone,
    required DateTime birthday,
    required String sugerType,
  }) async {
    try {
      emit(const BaseState(status: BaseStatus.inProgress));
      String timeFormatPattern = 'yyyy-MM-dd';
      final FormData formData = FormData.fromMap({
        'name': name,
        'phone': phone,
        'birthday': DateFormat(timeFormatPattern).format(birthday),
        'sugar_type': sugerType,
      });

      final Response? response = await NetworkHandler.instance?.post(
        url: ApiNames.editProfile,
        body: formData,
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
