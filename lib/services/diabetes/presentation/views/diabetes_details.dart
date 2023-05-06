import 'package:flutter/material.dart';

import '../../../../utilities/components/custom_page_body.dart';
import 'widgets/diaebetes_card.dart';

class DiabetesDetails extends StatelessWidget {
  const DiabetesDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPageBody(
      appBar: AppBar(
        leading: const Icon(Icons.arrow_back),
        backgroundColor: const Color(0xff1B72C0),
        title: const Text('قياسات سكر الدم'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      physics: const BouncingScrollPhysics(),
                      itemCount: 4,
                      itemBuilder: (context, index) => const DiabetesCard()),
                )
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xff1B72C0),
        child: const Icon(Icons.add),
      ),
    );
  }
}
