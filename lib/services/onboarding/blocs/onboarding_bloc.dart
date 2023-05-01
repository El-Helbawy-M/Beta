import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/config/app_states.dart';

class OnBoardingCubit extends Cubit<AppStates> {
  OnBoardingCubit() : super(Done()) {
    pageController.addListener(
      () {
        pageIndex = (pageController.page ?? 0).toInt();
        emit(Done());
      },
    );
  }

  //==========================================
  // Variables

  int pageIndex = 0;
  PageController pageController = PageController(initialPage: 0);
  List<String> content = [
    "يتيح لك تطبيق بيتا القدرة على تسجيل قراءات السكر يدويًا أو آليًا عن طريق مقياس سكر الدم و إضافتها إلى تقارير و إحصائيات تتعرف بها على إحصائيات سكر دمك بشكل مستمر",
    "لأن مريض السكري يبذل جهدًا كبيرًا في ضبط سكر الدم ؛ لذلك بنينا نظام بيتا ليكون حلقة الوصل بين مريض السكري وفريقنا الصحي الذي يعمل معك على الحد من الارتفاعات والانخفاضات لسكر الدم و التعرف على أسبابها و مساعدته في ضبط أسلوب حياته.",
    "الحفاظ على جدول مواعيد أدوية السكر و الأنسولين من أهم الخطوات في الحفاظ على مستوى السكر في الدم ؛ لذلك يتيح بيتا لمريض السكري القدرة على تسجيل مواعيد أدويته و متابعتها بشكل يومي",
    "و لأن مريض السكري يُعاني في الحفاظ على وجبات طعامه اليوميه و التي تؤثر بشكل كبير على مستوى السكر في الدم لذلك يتيح بيتا لمريض السكري القدرة على تصوير وجبات الطعام و تسجيلها و معرفة القيم الغذائية الخاصة به",
  ];

  //==========================================
  // Methods
  void goToNextPage() {
    pageIndex++;
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void goToPreviousPage() {
    pageIndex--;
    pageController.animateToPage(
      pageIndex,
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }
}
