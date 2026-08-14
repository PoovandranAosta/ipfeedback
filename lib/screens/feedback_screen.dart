
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';

import '../controllers/feedback_controller.dart';
import '../models/answer_model.dart';
import '../widgets/custom_feedback_form.dart';


class Feedback extends StatelessWidget {
  const Feedback({super.key});

  @override
  Widget build(BuildContext context) {
    final FeedbackController feedbackController = Get.put(FeedbackController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        return DynamicFeedbackForm(
          title: 'IP Feedback',
          questions: feedbackController.questions.value,
          onSubmit: (answers) async {
            String answerStr = FeedbackAnswerModel.formatList(answers);
            await feedbackController.saveFeedBack(answerEncode: answerStr);
          },
        );
      }),
    );
  }
}

// class Feedback extends StatelessWidget {
//   const Feedback({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Center(child: Text("Ip Feedback"),),
//     );
//   }
// }


