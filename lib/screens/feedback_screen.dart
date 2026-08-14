import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import '../config/config.dart';
import '../controllers/feedback_controller.dart';
import '../models/answer_model.dart';
import '../widgets/custom_banner.dart';
import '../widgets/custom_feedback_form.dart';
import '../widgets/custom_loaded.dart';

class Feedback extends StatelessWidget {
  const Feedback({super.key});

  @override
  Widget build(BuildContext context) {
    final FeedbackController feedbackController = Get.put(FeedbackController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Obx(() {
        // 1. Loading state takes priority
        if (feedbackController.isLoading.value) {
          return const Center(
            child: CustomThreeArchedLoader(size: 60, color: Colors.blue),
          );
        }

        // 2. Patient data found
        if (feedbackController.patData.isNotEmpty) {
          final patient = feedbackController.patData.first;

          return Column(
            children: [
              // if (patient.isSubmitted == '1') ...[
                buildHeader(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FeedbackAlreadySubmittedBanner(
                    patientName: '${patient.patientName}',
                    patientId: '${patient.regNo}',
                  ),
                ),
              // ],
              if (patient.isSubmitted == '0') ...[
                Expanded(
                  child: DynamicFeedbackForm(
                    title: 'IP Feedback',
                    questions: feedbackController.questions.value,
                    onSubmit: (answers) async {
                      String answerStr = FeedbackAnswerModel.formatList(
                        answers,
                      );
                      await feedbackController.saveFeedBack(
                        answerEncode: answerStr,
                      );
                    },
                  ),
                ),
              ],
            ],
          );
        }

        // 3. No patient found
        return Column(
          children: [
            buildHeader(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: NoPatientFoundBanner(
                title: "Patient Not Found",
                message:
                    "We couldn't find a matching patient record. Check the details and try again.",
              ),
            ),
          ],
        );
      }),
    );
  }
}

Widget buildHeader() {
  return Container(
    width: double.infinity,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [Color(0xFF1A4FA8), Color(0xFF4A7FE0)],
      ),
      boxShadow: [
        BoxShadow(
          color: Color(0x26000000),
          blurRadius: 12,
          offset: Offset(0, 5),
        ),
      ],
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      ),
    ),
    child: SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.10),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(
                    Icons.local_hospital_rounded,
                    size: 28,
                    color: Color(0xFF00897B),
                  ),
                ),
              ),
            ),

            const SizedBox(width: 10),

            // ----------------------------------------------------------
            // HOSPITAL NAME
            // ----------------------------------------------------------
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    Config.clientName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 4),

                  // IP Feedback badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.feedback_outlined,
                          color: Colors.white,
                          size: 13,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'IP Feedback',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
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
