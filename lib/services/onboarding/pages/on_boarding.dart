// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_project_base/config/app_states.dart';
import 'package:flutter_project_base/routers/navigator.dart';
import 'package:flutter_project_base/routers/routers.dart';
import 'package:flutter_project_base/services/onboarding/blocs/onboarding_bloc.dart';
import 'package:flutter_project_base/utilities/components/arrow_back.dart';
import 'package:flutter_project_base/utilities/components/custom_page_body.dart';
import 'package:flutter_svg/svg.dart';

class OnBoardingPage extends StatelessWidget {
  const OnBoardingPage({super.key});

  @override
  Widget build(BuildContext context) {
    var bloc = context.read<OnBoardingCubit>();
    return CustomPageBody(
      body: BlocBuilder<OnBoardingCubit, AppStates>(
        builder: (context, state) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              PageView.builder(
                controller: bloc.pageController,
                itemCount: bloc.content.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 80),
                      Image.asset(
                        "assets/images/onboarding/boarding_image${index + 1}.png",
                        width: 300,
                        height: 300,
                      ),
                      const SizedBox(height: 24),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          "بيتا",
                          style: Theme.of(context)
                              .textTheme
                              .headline3!
                              .copyWith(
                                  color: Theme.of(context).colorScheme.primary),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: Text(
                          bloc.content[index],
                          style: Theme.of(context).textTheme.headline6,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      width: 152,
                      height: 152,
                      child: CircularProgressIndicator(
                        value: (bloc.pageIndex + 1) / 4,
                        backgroundColor: Theme.of(context).dividerColor,
                        color: Theme.of(context).colorScheme.primary,
                        strokeWidth: 2,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        if (bloc.pageIndex == 3) {
                          // bloc.completeOnBoarding();
                          CustomNavigator.push(Routes.login);
                        } else {
                          print('sldkfjslkdjfsd');
                          bloc.goToNextPage();
                        }
                      },
                      child: Container(
                        width: 135,
                        height: 135,
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.primary,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: SizedBox(
                            width: 56,
                            height: 56,
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: SvgPicture.asset(
                                "assets/icons/svg/arrow_left.svg",
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }
}
