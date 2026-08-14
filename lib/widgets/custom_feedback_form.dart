// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
//
// import '../controllers/feedback_controller.dart';
// import '../models/question_model.dart';
// import 'custom_header_card.dart';
// import 'custom_text_field.dart';
// import 'custom_toggle.dart';
//
// /// ======================================================
// /// ANSWER MODEL
// /// ======================================================
// class FeedbackAnswerModel {
//   final String questionText;
//   final String questionType;
//   final dynamic answer;
//   final dynamic selectedRatingId;
//   final dynamic selectedRatingValue;
//
//   FeedbackAnswerModel({
//     required this.questionText,
//     required this.questionType,
//     required this.answer,
//     this.selectedRatingId,
//     this.selectedRatingValue,
//   });
//
//   Map<String, dynamic> toJson() {
//     return {
//       'QuestionText': questionText,
//       'QuestionType': questionType,
//       'Answer': answer,
//       'SelectedRatingId': selectedRatingId,
//       'SelectedRatingValue': selectedRatingValue,
//     };
//   }
// }
//
// /// ======================================================
// /// DYNAMIC FEEDBACK FORM
// /// ======================================================
// class DynamicFeedbackForm extends StatefulWidget {
//   final List<QuestionModel> questions;
//   final Function(List<FeedbackAnswerModel>) onSubmit;
//   final String title;
//
//   const DynamicFeedbackForm({
//     super.key,
//     required this.questions,
//     required this.onSubmit,
//     this.title = 'Patient Feedback',
//   });
//
//   @override
//   State<DynamicFeedbackForm> createState() => _DynamicFeedbackFormState();
// }
//
// class _DynamicFeedbackFormState extends State<DynamicFeedbackForm> {
//   final Map<int, int> selectedIndex = {};
//   final Map<int, TextEditingController> textControllers = {};
//   final ScrollController scrollController = ScrollController();
//
//   bool isSubmitting = false;
//
//   @override
//   void initState() {
//     super.initState();
//
//     for (int i = 0; i < widget.questions.length; i++) {
//       if (_normalizeType(widget.questions[i].questionType) == 'text') {
//         textControllers.putIfAbsent(i, () => TextEditingController());
//       }
//     }
//   }
//
//   // @override
//   // void dispose() {
//   //   for (final controller in textControllers.values) {
//   //     controller.dispose();
//   //   }
//   //   scrollController.dispose();
//   //   super.dispose();
//   // }
//
//   @override
//   void dispose() {
//     for (final controller in textControllers.values) {
//       controller.dispose();
//     }
//     textControllers.clear();
//     scrollController.dispose();
//     super.dispose();
//   }
//
//   String _normalizeType(String type) => type.trim().toLowerCase();
//
//   bool _isValidIndex(List list, int index) {
//     return index >= 0 && index < list.length;
//   }
//
//   bool _validate() {
//     for (int i = 0; i < widget.questions.length; i++) {
//       final question = widget.questions[i];
//       final type = _normalizeType(question.questionType);
//
//       if (type == 'text') {
//         final controller = textControllers[i];
//         final value = controller?.text.trim() ?? '';
//
//         print(
//           '🔍 Text Question $i | Controller exists: ${controller != null} | Value: "$value"',
//         ); // Remove later
//
//         if (value.isEmpty) {
//           _showMessage('Please enter your feedback for Question ${i + 1}.');
//           return false;
//         }
//       } else {
//         if (!selectedIndex.containsKey(i)) {
//           _showMessage('Please answer Question ${i + 1}.');
//           return false;
//         }
//       }
//     }
//     return true;
//   }
//
//   void _showMessage(String message) {
//     ScaffoldMessenger.of(context).hideCurrentSnackBar();
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
//     );
//   }
//
//   Future<void> _submit() async {
//     if (!_validate()) return;
//
//     setState(() => isSubmitting = true);
//
//     final List<FeedbackAnswerModel> result = [];
//
//     for (int i = 0; i < widget.questions.length; i++) {
//       final question = widget.questions[i];
//       final type = _normalizeType(question.questionType);
//
//       print("Type : $type");
//
//       if (type == 'text') {
//         result.add(
//           FeedbackAnswerModel(
//             questionText: question.questionText,
//             questionType: question.questionType,
//             answer: textControllers[i]?.text.trim() ?? '',
//           ),
//         );
//       } else {
//         final index = selectedIndex[i]!;
//
//         result.add(
//           FeedbackAnswerModel(
//             questionText: question.questionText,
//             questionType: question.questionType,
//             answer: _isValidIndex(question.options, index)
//                 ? question.options[index]
//                 : null,
//             selectedRatingId: _isValidIndex(question.ratingIds, index)
//                 ? question.ratingIds[index]
//                 : null,
//             selectedRatingValue: _isValidIndex(question.ratingValues, index)
//                 ? question.ratingValues[index]
//                 : null,
//           ),
//         );
//       }
//     }
//
//     await Future.delayed(const Duration(milliseconds: 500));
//
//     if (mounted) {
//       setState(() => isSubmitting = false);
//       widget.onSubmit(result);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final FeedbackController feedbackController = Get.put(FeedbackController());
//
//     if (widget.questions.isEmpty) {
//       return const Center(child: Text('No feedback questions available.'));
//     }
//
//     return Container(
//       color: Colors.white,
//       child: Column(
//         children: [
//           _buildHeader(),
//           Expanded(
//             child: ListView(
//               controller: scrollController,
//               padding: const EdgeInsets.all(0),
//               children: [
//                 _buildLang(),
//
//                 ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: widget.questions.length,
//                   itemBuilder: (context, index) {
//                     return _buildQuestionCard(widget.questions[index], index);
//                   },
//                 ),
//
//                 Padding(
//                   padding: const EdgeInsets.only(
//                     left: 25,
//                     right: 25,
//                     top: 0,
//                     bottom: 20,
//                   ),
//                   child: _buildSubmitButton(),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildLang() {
//     final FeedbackController feedbackController = Get.put(FeedbackController());
//     return Column(
//       children: [
//         CustomHeaderCard(
//           title: "Feedback Questions",
//           accentColor: Colors.blue,
//           showAction: false,
//           padding: const EdgeInsets.all(8.0),
//         ),
//
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//             // padding: const EdgeInsets.all(6),
//             decoration: BoxDecoration(
//               color: Colors.grey.shade100,
//               borderRadius: BorderRadius.circular(20),
//               boxShadow: [
//                 BoxShadow(
//                   color: Colors.black.withOpacity(0.05),
//                   blurRadius: 12,
//                   offset: const Offset(0, 6),
//                 ),
//               ],
//             ),
//             child: ModernToggleButton(
//               option1Label: 'English',
//               option2Label: 'Tamil',
//               subTitle1: 'Patient Feedback',
//               subTitle2: 'நோயாளி கருத்து',
//               initialSelection: true,
//               option1Icon: Icons.language_rounded,
//               option2Icon: Icons.translate_rounded,
//               selectedColor: const Color(0xFF1a4fa8),
//               selectedTextColor: Colors.white,
//               unselectedTextColor: Colors.black,
//
//               onChanged: (isEnglish) async {
//                 final lang = isEnglish ? "en" : "ta";
//
//                 await feedbackController.fetchQuestion(lang);
//
//                 debugPrint("Language changed: $lang");
//               },
//             ),
//           ),
//         ),
//       ],
//     );
//   }
//
//
//
//   Widget _buildHeader() {
//     return Container(
//       width: double.infinity,
//       decoration: const BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//           colors: [Color(0xFF0F3D91), Color(0xFF0F3D91), Color(0xFF0F3D91)],
//         ),
//         // borderRadius: BorderRadius.only(
//         //   bottomLeft: Radius.circular(32),
//         //   bottomRight: Radius.circular(32),
//         // ),
//         boxShadow: [
//           BoxShadow(
//             color: Color(0x33000000),
//             blurRadius: 20,
//             offset: Offset(0, 8),
//           ),
//         ],
//       ),
//       child: SafeArea(
//         bottom: false,
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(6, 6, 6, 6),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Hospital Info Card
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.white.withValues(alpha: 0.15),
//                   borderRadius: BorderRadius.circular(24),
//                   border: Border.all(
//                     color: Colors.white.withValues(alpha: 0.20),
//                     width: 1,
//                   ),
//                 ),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     // Logo Container
//                     Container(
//                       width: 78,
//                       height: 78,
//                       padding: const EdgeInsets.all(8),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(12),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withValues(alpha: 0.08),
//                             blurRadius: 10,
//                             offset: const Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Image.asset(
//                         'assets/images/logo.png',
//                         fit: BoxFit.contain,
//                       ),
//                     ),
//
//                     const SizedBox(width: 16),
//
//                     // Text Section
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             "Kovai Medical Center And Hospital Limited",
//                             maxLines: 3,
//                             overflow: TextOverflow.ellipsis,
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 20,
//                               fontWeight: FontWeight.w800,
//                               height: 1.25,
//                               letterSpacing: 0.2,
//                             ),
//                           ),
//                           const SizedBox(height: 10),
//
//                           // Feedback Title Badge
//                           Container(
//                             padding: const EdgeInsets.symmetric(
//                               horizontal: 12,
//                               vertical: 6,
//                             ),
//                             decoration: BoxDecoration(
//                               color: Colors.white.withValues(alpha: 0.18),
//                               borderRadius: BorderRadius.circular(30),
//                               border: Border.all(
//                                 color: Colors.white.withValues(alpha: 0.25),
//                               ),
//                             ),
//                             child: Text(
//                               "Blood Bank",
//                               maxLines: 2,
//                               overflow: TextOverflow.ellipsis,
//                               style: const TextStyle(
//                                 color: Colors.white,
//                                 fontSize: 14,
//                                 fontWeight: FontWeight.w600,
//                                 letterSpacing: 0.3,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//
//               // const SizedBox(height: 18),
//               //
//               // // Subtitle
//               // Container(
//               //   padding: const EdgeInsets.symmetric(
//               //     horizontal: 14,
//               //     vertical: 10,
//               //   ),
//               //   decoration: BoxDecoration(
//               //     color: Colors.white.withValues(alpha: 0.10),
//               //     borderRadius: BorderRadius.circular(16),
//               //   ),
//               //   child: Row(
//               //     children: [
//               //       Icon(
//               //         Icons.favorite_outline_rounded,
//               //         color: Colors.white.withValues(alpha: 0.95),
//               //         size: 20,
//               //       ),
//               //       const SizedBox(width: 4),
//               //       Expanded(
//               //         child: Text(
//               //           'Your feedback helps us improve our service.',
//               //           style: TextStyle(
//               //             color: Colors.white.withValues(alpha: 0.95),
//               //             fontSize: 14,
//               //             fontWeight: FontWeight.w500,
//               //             height: 1.4,
//               //           ),
//               //         ),
//               //       ),
//               //     ],
//               //   ),
//               // ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildQuestionCard(QuestionModel question, int index) {
//     final type = _normalizeType(question.questionType);
//
//     return Card(
//
//       color: Colors.white,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
//       child: Padding(
//         padding: const EdgeInsets.all(8),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 const SizedBox(width: 2),
//                 Expanded(
//                   child: Text(
//                     "${index + 1}.  ${question.questionText}",
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.w600,
//                       height: 1.4,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 10),
//             if (type == 'rating') _buildRatingQuestion(question, index),
//             if (type == 'yesno') _buildYesNoQuestion(question, index),
//             if (type == 'text') _buildTextQuestion(index),
//           ],
//         ),
//       ),
//     );
//   }
//
//
//   Widget _buildRatingQuestion(QuestionModel question, int questionIndex) {
//     final selected = selectedIndex[questionIndex];
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final theme = Theme.of(context);
//         final primaryColor = theme.primaryColor;
//         final borderColor = Colors.blueGrey.shade100;
//
//         const spacing = 8.0;
//         const minItemWidth = 140.0; // Minimum width for each option card
//
//         // Calculate how many items can fit in the available width
//         final crossAxisCount = (constraints.maxWidth / (minItemWidth + spacing))
//             .floor()
//             .clamp(1, question.options.length);
//
//         // Exact width for each item so all options fit perfectly
//         final itemWidth =
//             (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
//             crossAxisCount;
//
//         return Wrap(
//           spacing: spacing,
//           runSpacing: spacing,
//           children: List.generate(question.options.length, (optionIndex) {
//             final optionText = question.options[optionIndex];
//             final isSelected = selected == optionIndex;
//
//             return SizedBox(
//               width: itemWidth,
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(8),
//                   onTap: () {
//                     setState(() {
//                       selectedIndex[questionIndex] = optionIndex;
//                     });
//                   },
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 12,
//                       vertical: 12,
//                     ),
//
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? primaryColor.withOpacity(0.05)
//                           : Colors.white,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: isSelected ? primaryColor : borderColor,
//                         width: isSelected ? 1.5 : 1,
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         // Radio Indicator
//                         AnimatedContainer(
//                           duration: const Duration(milliseconds: 200),
//                           width: 16,
//                           height: 16,
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                               color: isSelected
//                                   ? primaryColor
//                                   : Colors.blueGrey.shade300,
//                               width: 2,
//                             ),
//                           ),
//                           child: Center(
//                             child: AnimatedContainer(
//                               duration: const Duration(milliseconds: 200),
//                               width: isSelected ? 7 : 0,
//                               height: isSelected ? 7 : 0,
//                               decoration: BoxDecoration(
//                                 shape: BoxShape.circle,
//                                 color: primaryColor,
//                               ),
//                             ),
//                           ),
//                         ),
//
//                         const SizedBox(width: 6),
//
//                         // Option Text
//                         Expanded(
//                           child: Text(
//                             optionText,
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 12,
//                               height: 1.1,
//                               color: isSelected
//                                   ? primaryColor
//                                   : Colors.blueGrey.shade700,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
//
//   Widget _buildYesNoQuestion(QuestionModel question, int questionIndex) {
//     final options = question.options.isEmpty ? ['Yes', 'No'] : question.options;
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final theme = Theme.of(context);
//         final primaryColor = theme.colorScheme.primary;
//         final borderColor = theme.dividerColor.withOpacity(0.5);
//
//         const spacing = 8.0;
//         const minItemWidth = 150.0;
//
//         // Automatically calculate how many items fit in available width
//         final crossAxisCount = (constraints.maxWidth / (minItemWidth + spacing))
//             .floor()
//             .clamp(1, options.length);
//
//         // Calculate exact width so items fit perfectly
//         final itemWidth =
//             (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
//             crossAxisCount;
//
//         return Wrap(
//           spacing: spacing,
//           runSpacing: spacing,
//           children: List.generate(options.length, (optionIndex) {
//             final option = options[optionIndex];
//             final isSelected = selectedIndex[questionIndex] == optionIndex;
//
//             return SizedBox(
//               width: itemWidth,
//               child: Material(
//                 color: Colors.transparent,
//                 child: InkWell(
//                   borderRadius: BorderRadius.circular(8),
//                   onTap: () {
//                     setState(() {
//                       selectedIndex[questionIndex] = optionIndex;
//                     });
//                   },
//                   child: AnimatedContainer(
//                     duration: const Duration(milliseconds: 200),
//                     curve: Curves.easeInOut,
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 10,
//                     ),
//                     // Reduced padding
//                     decoration: BoxDecoration(
//                       color: isSelected
//                           ? primaryColor.withOpacity(0.06)
//                           : theme.cardColor,
//                       borderRadius: BorderRadius.circular(8),
//                       border: Border.all(
//                         color: isSelected ? primaryColor : borderColor,
//                         width: isSelected ? 1.5 : 1,
//                       ),
//                     ),
//                     child: Row(
//                       children: [
//                         // Compact Checkbox Indicator
//                         AnimatedContainer(
//                           duration: const Duration(milliseconds: 200),
//                           width: 18,
//                           height: 18,
//                           decoration: BoxDecoration(
//                             color: isSelected
//                                 ? primaryColor
//                                 : Colors.transparent,
//                             borderRadius: BorderRadius.circular(4),
//                             border: Border.all(
//                               color: isSelected
//                                   ? primaryColor
//                                   : theme.dividerColor,
//                               width: 1.5,
//                             ),
//                           ),
//                           child: isSelected
//                               ? Icon(
//                                   Icons.check_rounded,
//                                   size: 12,
//                                   color: theme.colorScheme.onPrimary,
//                                 )
//                               : null,
//                         ),
//
//                         const SizedBox(width: 8),
//
//                         // Option Text
//                         Expanded(
//                           child: Text(
//                             option,
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                             style: theme.textTheme.bodyMedium?.copyWith(
//                               fontSize: 13,
//                               fontWeight: isSelected
//                                   ? FontWeight.w600
//                                   : FontWeight.w500,
//                               color: isSelected
//                                   ? primaryColor
//                                   : theme.colorScheme.onSurface,
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }),
//         );
//       },
//     );
//   }
//
//   Widget _buildTextQuestion(int questionIndex) {
//     // Ensure controller always exists
//     textControllers.putIfAbsent(questionIndex, () => TextEditingController());
//
//     return LayoutBuilder(
//       builder: (context, constraints) {
//         final isMobile = constraints.maxWidth < 600;
//
//         return Container(
//           width: double.infinity,
//           padding: EdgeInsets.all(isMobile ? 8 : 12), // Reduced outer padding
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(8), // Reduced radius
//             border: Border.all(color: Colors.grey.shade300, width: 1),
//           ),
//           child: TextField(
//             controller: textControllers[questionIndex]!,
//             maxLines: 4,
//             // Reduced height
//             minLines: 3,
//             textInputAction: TextInputAction.newline,
//             style: TextStyle(
//               fontSize: isMobile ? 13 : 14,
//               fontWeight: FontWeight.w500,
//               height: 1.3,
//               color: Colors.black87,
//             ),
//             decoration: InputDecoration(
//               hintText: 'Type your answer here...',
//               hintStyle: TextStyle(
//                 color: Colors.grey.shade500,
//                 fontSize: isMobile ? 13 : 14,
//                 fontWeight: FontWeight.w400,
//               ),
//
//               // Light background
//               filled: true,
//               fillColor: const Color(0xFFF8FAFC),
//
//               // Reduced inner padding
//               contentPadding: EdgeInsets.symmetric(
//                 horizontal: isMobile ? 10 : 12,
//                 vertical: isMobile ? 10 : 12,
//               ),
//
//               // Remove default borders to save space
//               border: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderRadius: BorderRadius.circular(6),
//                 borderSide: const BorderSide(
//                   color: Color(0xFF2563EB),
//                   width: 1.2,
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
//   }
//
//
//   Widget _buildSubmitButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 56,
//       child: ElevatedButton(
//         onPressed: isSubmitting ? null : _submit,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: const Color(0xFF1a4fa8),
//           foregroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(18),
//           ),
//         ),
//         child: isSubmitting
//             ? const SizedBox(
//                 width: 24,
//                 height: 24,
//                 child: CircularProgressIndicator(
//                   strokeWidth: 2.5,
//                   color: Colors.white,
//                 ),
//               )
//             : const Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Icon(Icons.send_rounded),
//                   SizedBox(width: 8),
//                   Text(
//                     'Submit Feedback',
//                     style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:ipfeedback/config/config.dart';
import '../controllers/feedback_controller.dart';
import '../models/answer_model.dart';
import '../models/question_model.dart';
import 'custom_dot_lines.dart';
import 'custom_header_card.dart';
import 'custom_loaded.dart';
import 'custom_patient_details.dart';
import 'custom_toggle.dart';
import 'package:flutter/services.dart';

/// ======================================================
/// DYNAMIC FEEDBACK FORM
/// ======================================================
class DynamicFeedbackForm extends StatefulWidget {
  final List<QuestionModel> questions;
  final Function(List<FeedbackAnswerModel>) onSubmit;
  final String title;

  const DynamicFeedbackForm({
    super.key,
    required this.questions,
    required this.onSubmit,
    this.title = 'Patient Feedback',
  });

  @override
  State<DynamicFeedbackForm> createState() => _DynamicFeedbackFormState();
}

class _DynamicFeedbackFormState extends State<DynamicFeedbackForm> {
  // For rating questions: single selection (int index)
  final Map<int, int> selectedRatingIndex = {};

  // For yesno questions: multi-selection (Set of selected indices)
  final Map<int, Set<int>> selectedYesNoIndices = {};

  final Map<int, Set<int>> selectedCRatingIndices = {};

  // For text questions
  final Map<int, TextEditingController> textControllers = {};
  final ScrollController scrollController = ScrollController();

  bool isSubmitting = false;
  bool isToggle = true;

  // ── Theme colours ──────────────────────────────────────
  static const Color _primary = Color(0xFF0F3D91);
  static const Color _primaryLight = Color(0xFF1a4fa8);
  static const Color _accent = Color(0xFF2563EB);

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    for (int i = 0; i < widget.questions.length; i++) {
      if (_normalizeType(widget.questions[i].questionType) == 'text') {
        textControllers.putIfAbsent(i, () => TextEditingController());
      }
    }
  }

  @override
  void didUpdateWidget(DynamicFeedbackForm oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Re-init controllers when questions change (language switch etc.)
    if (oldWidget.questions != widget.questions) {
      // Dispose old text controllers
      for (final c in textControllers.values) {
        c.dispose();
      }
      textControllers.clear();
      selectedRatingIndex.clear();
      selectedYesNoIndices.clear();
      _initControllers();
    }
  }

  @override
  void dispose() {
    for (final c in textControllers.values) {
      c.dispose();
    }
    textControllers.clear();
    scrollController.dispose();
    super.dispose();
  }

  // ── Helpers ───────────────────────────────────────────
  String _normalizeType(String type) => type.trim().toLowerCase();

  bool _isValidIndex(List list, int index) => index >= 0 && index < list.length;

  // ── Validation ────────────────────────────────────────
  bool _validate() {
    for (int i = 0; i < widget.questions.length; i++) {
      final question = widget.questions[i];
      final type = _normalizeType(question.questionType);

      if (type == 'label') {
        continue;
      }

      if (type == 'text') {
        final value = textControllers[i]?.text.trim() ?? '';
        if (value.isEmpty) {
          _showMessage('Please answer Question ${i + 1}.');
          return false;
        }
      } else if (type == 'yesno') {
        // Must select at least one checkbox
        final selected = selectedYesNoIndices[i];
        if (selected == null || selected.isEmpty) {
          _showMessage('Please answer Question ${i + 1}.');
          return false;
        }
      } else if (type == 'crating') {
        // Must select at least one checkbox
        final selected = selectedCRatingIndices[i];
        if (selected == null || selected.isEmpty) {
          _showMessage('Please answer Question ${i + 1}.');
          return false;
        }
      } else {
        // rating (single select)
        if (!selectedRatingIndex.containsKey(i)) {
          _showMessage('Please answer Question ${i + 1}.');
          return false;
        }
      }
    }
    return true;
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(
              Icons.info_outline_rounded,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: _primaryLight,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ── Submit ────────────────────────────────────────────
  Future<void> _submit() async {
    if (!_validate()) return;

    setState(() => isSubmitting = true);

    final List<FeedbackAnswerModel> result = [];

    for (int i = 0; i < widget.questions.length; i++) {
      final question = widget.questions[i];
      final type = _normalizeType(question.questionType);

      if (type == 'text') {
        result.add(
          FeedbackAnswerModel(
            questionText: question.questionText,
            questionType: question.questionType,
            answer: textControllers[i]?.text.trim() ?? '',
            questionID: question.questionID,
            selectedRatingId: question.ratingIds,
            selectedRatingValue: question.ratingValues,
          ),
        );
      }
      else if (type == 'label') {
        result.add(
          FeedbackAnswerModel(
            questionText: question.questionText,
            questionType: question.questionType,
            answer: '',
            questionID: question.questionID,
            selectedRatingId: question.ratingIds,
            selectedRatingValue: question.ratingValues,
          ),
        );
      }
      else if (type == 'yesno') {
        // Collect all selected options as a List
        final selectedSet = selectedYesNoIndices[i] ?? {};
        final selectedOptions = selectedSet
            .where((idx) => _isValidIndex(question.options, idx))
            .map((idx) => question.options[idx])
            .toList();

        final selectedIds = selectedSet
            .where((idx) => _isValidIndex(question.ratingIds, idx))
            .map((idx) => question.ratingIds[idx])
            .toList();

        final selectedValues = selectedSet
            .where((idx) => _isValidIndex(question.ratingValues, idx))
            .map((idx) => question.ratingValues[idx])
            .toList();

        result.add(
          FeedbackAnswerModel(
            questionText: question.questionText,
            questionType: question.questionType,
            answer: "",
            selectedRatingId: selectedIds,
            selectedRatingValue: selectedValues,
            questionID: question.questionID,
          ),
        );
      } else if (type == 'crating') {
        // Collect all selected options as a List
        final selectedSet = selectedCRatingIndices[i] ?? {};
        final selectedOptions = selectedSet
            .where((idx) => _isValidIndex(question.options, idx))
            .map((idx) => question.options[idx])
            .toList();

        final selectedIds = selectedSet
            .where((idx) => _isValidIndex(question.ratingIds, idx))
            .map((idx) => question.ratingIds[idx])
            .toList();

        final selectedValues = selectedSet
            .where((idx) => _isValidIndex(question.ratingValues, idx))
            .map((idx) => question.ratingValues[idx])
            .toList();

        result.add(
          FeedbackAnswerModel(
            questionText: question.questionText,
            questionType: question.questionType,
            answer: "",
            selectedRatingId: selectedIds,
            selectedRatingValue: selectedValues,
            questionID: question.questionID,
          ),
        );
      } else {
        // rating — single select
        final index = selectedRatingIndex[i]!;
        result.add(
          FeedbackAnswerModel(
            questionText: question.questionText,
            questionType: question.questionType,
            answer: ratingCommentControllers[i]?.text.trim() ?? '',
            selectedRatingId: _isValidIndex(question.ratingIds, index)
                ? question.ratingIds[index]
                : null,
            selectedRatingValue: _isValidIndex(question.ratingValues, index)
                ? question.ratingValues[index]
                : null,
            questionID: question.questionID,
          ),
        );
      }
    }

    await Future.delayed(const Duration(milliseconds: 400));

    if (mounted) {
      setState(() => isSubmitting = false);
      widget.onSubmit(result);
    }
  }

  // ── Build ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    FeedbackController feedbackController = Get.put(FeedbackController());

    if(feedbackController.isLoading.value){
      return Center(
        child: CustomThreeArchedLoader(
          size: 60,
          color: Colors.blue,
        ),
      );
    }

    if (widget.questions.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.quiz_outlined, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text(
              'No feedback questions available.',
              style: TextStyle(color: Colors.grey, fontSize: 15),
            ),
          ],
        ),
      );
    }

    return Container(
      color: Colors.grey.shade100,
      child: Column(
        children: [
          buildHeader(),
          patientCard(),
          CustomHeaderCard(
            title: "Feedback Questions",
            accentColor: Colors.blue,
            showAction: false,
            padding: const EdgeInsets.only(left: 8, right: 8, top: 0,bottom: 0),
          ),
          _buildLangToggle(),
          // patientInfoCard(patientName: "Poovandran G", registerNumber: "54321"),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 12,right: 12,bottom:12,top: 0),
              child: ListView(
                controller: scrollController,
                padding: EdgeInsets.zero,
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: widget.questions.length,
                    itemBuilder: (context, index) =>
                        _buildQuestionCard(widget.questions[index], index),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                    child: _buildSubmitButton(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Header ────────────────────────────────────────────
  // Widget _buildHeader() {
  //   FeedbackController feedbackController = Get.put(FeedbackController());
  //   return Container(
  //     width: double.infinity,
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [Color(0xFF1A4FA8), Color(0xFF4A7FE0)],
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Color(0x26000000),
  //           blurRadius: 24,
  //           offset: Offset(0, 10),
  //         ),
  //       ],
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(28),
  //         bottomRight: Radius.circular(28),
  //       ),
  //     ),
  //     child: SafeArea(
  //       bottom: false,
  //       child: Padding(
  //         padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
  //         child: Container(
  //           padding: const EdgeInsets.all(14),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withOpacity(0.14),
  //             borderRadius: BorderRadius.circular(24),
  //             border: Border.all(
  //               color: Colors.white.withOpacity(0.22),
  //               width: 1,
  //             ),
  //             boxShadow: [
  //               BoxShadow(
  //                 color: Colors.black.withOpacity(0.08),
  //                 blurRadius: 18,
  //                 offset: const Offset(0, 8),
  //               ),
  //             ],
  //           ),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               // Hospital Logo Card
  //               Container(
  //                 width: 82,
  //                 height: 82,
  //                 padding: const EdgeInsets.all(10),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(20),
  //                   border: Border.all(
  //                     color: Colors.white.withOpacity(0.9),
  //                     width: 1.5,
  //                   ),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withOpacity(0.10),
  //                       blurRadius: 14,
  //                       offset: const Offset(0, 6),
  //                     ),
  //                   ],
  //                 ),
  //                 child: ClipRRect(
  //                   borderRadius: BorderRadius.circular(12),
  //                   child: Image.asset(
  //                     'assets/images/logo.png',
  //                     fit: BoxFit.contain,
  //                     errorBuilder: (_, __, ___) => const Icon(
  //                       Icons.local_hospital_rounded,
  //                       size: 40,
  //                       color: Color(0xFF00897B),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //
  //               const SizedBox(width: 16),
  //
  //               // Hospital Information
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     // Hospital Name
  //                     const Text(
  //                       'Kovai Medical Center and Hospital Limited',
  //                       maxLines: 2,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 18,
  //                         fontWeight: FontWeight.w800,
  //                         height: 1.25,
  //                         letterSpacing: 0.2,
  //                       ),
  //                     ),
  //
  //                     const SizedBox(height: 6),
  //
  //                     // Department Badge
  //                     Container(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 12,
  //                         vertical: 6,
  //                       ),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white.withOpacity(0.18),
  //                         borderRadius: BorderRadius.circular(30),
  //                         border: Border.all(
  //                           color: Colors.white.withOpacity(0.25),
  //                         ),
  //                       ),
  //                       child: Row(
  //                         mainAxisSize: MainAxisSize.min,
  //                         children: [
  //                           const Icon(
  //                             Icons.bloodtype_rounded,
  //                             color: Colors.white,
  //                             size: 16,
  //                           ),
  //                           const SizedBox(width: 6),
  //
  //                           Text(
  //                             'IP Feedback',
  //                             style: const TextStyle(
  //                               color: Colors.white,
  //                               fontSize: 13,
  //                               fontWeight: FontWeight.w700,
  //                               letterSpacing: 0.2,
  //                             ),
  //                           ),
  //                         ],
  //                       ),
  //                     ),
  //
  //                     // const SizedBox(height: 6),
  //
  //                     // Subtitle
  //                     // Text(
  //                     //   'Department Feedback Form',
  //                     //   style: TextStyle(
  //                     //     color: Colors.white.withOpacity(0.92),
  //                     //     fontSize: 12,
  //                     //     fontWeight: FontWeight.w500,
  //                     //     letterSpacing: 0.3,
  //                     //   ),
  //                     // ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  // Widget _buildHeader() {
  //   return Container(
  //     width: double.infinity,
  //     decoration: const BoxDecoration(
  //       gradient: LinearGradient(
  //         begin: Alignment.topLeft,
  //         end: Alignment.bottomRight,
  //         colors: [Color(0xFF1A4FA8), Color(0xFF4A7FE0)],
  //       ),
  //       boxShadow: [
  //         BoxShadow(
  //           color: Color(0x26000000),
  //           blurRadius: 24,
  //           offset: Offset(0, 10),
  //         ),
  //       ],
  //       borderRadius: BorderRadius.only(
  //         bottomLeft: Radius.circular(28),
  //         bottomRight: Radius.circular(28),
  //       ),
  //     ),
  //     child: SafeArea(
  //       bottom: false,
  //       child: Padding(
  //         padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
  //         child: Container(
  //           padding: const EdgeInsets.all(16),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withOpacity(.12),
  //             borderRadius: BorderRadius.circular(24),
  //             border: Border.all(color: Colors.white.withOpacity(.20)),
  //           ),
  //           child: Column(
  //             children: [
  //               /// Hospital Info
  //               Row(
  //                 crossAxisAlignment: CrossAxisAlignment.center,
  //                 children: [
  //                   Container(
  //                     width: 80,
  //                     height: 80,
  //                     padding: const EdgeInsets.all(10),
  //                     decoration: BoxDecoration(
  //                       color: Colors.white,
  //                       borderRadius: BorderRadius.circular(18),
  //                       boxShadow: [
  //                         BoxShadow(
  //                           color: Colors.black.withOpacity(.10),
  //                           blurRadius: 10,
  //                           offset: const Offset(0, 4),
  //                         ),
  //                       ],
  //                     ),
  //                     child: ClipRRect(
  //                       borderRadius: BorderRadius.circular(12),
  //                       child: Image.asset(
  //                         'assets/images/logo.png',
  //                         fit: BoxFit.contain,
  //                         errorBuilder: (_, __, ___) => const Icon(
  //                           Icons.local_hospital_rounded,
  //                           size: 40,
  //                           color: Color(0xFF00897B),
  //                         ),
  //                       ),
  //                     ),
  //                   ),
  //
  //                   const SizedBox(width: 14),
  //
  //                   Expanded(
  //                     child: Column(
  //                       crossAxisAlignment: CrossAxisAlignment.start,
  //                       children: [
  //                         Text(
  //                           Config.clientName,
  //                           maxLines: 2,
  //                           overflow: TextOverflow.ellipsis,
  //                           style: const TextStyle(
  //                             color: Colors.white,
  //                             fontSize: 18,
  //                             fontWeight: FontWeight.w800,
  //                             height: 1.2,
  //                           ),
  //                         ),
  //
  //                         const SizedBox(height: 8),
  //
  //                         Container(
  //                           padding: const EdgeInsets.symmetric(
  //                             horizontal: 12,
  //                             vertical: 6,
  //                           ),
  //                           decoration: BoxDecoration(
  //                             color: Colors.white.withOpacity(.15),
  //                             borderRadius: BorderRadius.circular(30),
  //                           ),
  //                           child: const Row(
  //                             mainAxisSize: MainAxisSize.min,
  //                             children: [
  //                               Icon(
  //                                 Icons.feedback_outlined,
  //                                 color: Colors.white,
  //                                 size: 16,
  //                               ),
  //                               SizedBox(width: 6),
  //                               Text(
  //                                 'IP Feedback',
  //                                 style: TextStyle(
  //                                   color: Colors.white,
  //                                   fontSize: 13,
  //                                   fontWeight: FontWeight.w700,
  //                                 ),
  //                               ),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //
  //               // const SizedBox(height: 16),
  //
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A4FA8),
            Color(0xFF4A7FE0),
          ],
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
              // ----------------------------------------------------------
              // LOGO
              // ----------------------------------------------------------
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

  // Widget _buildHeader() {
  //   return Container(
  //     width: double.infinity,
  //     decoration: const BoxDecoration(
  //       color: _primary,
  //       boxShadow: [
  //         BoxShadow(color: Color(0x33000000), blurRadius: 20, offset: Offset(0, 8)),
  //       ],
  //     ),
  //     child: SafeArea(
  //       bottom: false,
  //       child: Padding(
  //         padding: const EdgeInsets.all(12),
  //         child: Container(
  //           padding: const EdgeInsets.all(12),
  //           decoration: BoxDecoration(
  //             color: Colors.white.withOpacity(0.13),
  //             borderRadius: BorderRadius.circular(20),
  //             border: Border.all(color: Colors.white.withOpacity(0.20)),
  //           ),
  //           child: Row(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             children: [
  //               // Logo
  //               Container(
  //                 width: 72,
  //                 height: 72,
  //                 padding: const EdgeInsets.all(8),
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius: BorderRadius.circular(12),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.black.withOpacity(0.10),
  //                       blurRadius: 10,
  //                       offset: const Offset(0, 4),
  //                     ),
  //                   ],
  //                 ),
  //                 child: Image.asset('assets/images/logo.png', fit: BoxFit.contain),
  //               ),
  //               const SizedBox(width: 14),
  //               // Text
  //               Expanded(
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text(
  //                       "Kovai Medical Center And Hospital Limited",
  //                       maxLines: 3,
  //                       overflow: TextOverflow.ellipsis,
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 17,
  //                         fontWeight: FontWeight.w800,
  //                         height: 1.3,
  //                       ),
  //                     ),
  //                     const SizedBox(height: 8),
  //                     Container(
  //                       padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
  //                       decoration: BoxDecoration(
  //                         color: Colors.white.withOpacity(0.18),
  //                         borderRadius: BorderRadius.circular(30),
  //                         border: Border.all(color: Colors.white.withOpacity(0.25)),
  //                       ),
  //                       child: const Text(
  //                         "Blood Bank",
  //                         style: TextStyle(
  //                           color: Colors.white,
  //                           fontSize: 13,
  //                           fontWeight: FontWeight.w600,
  //                         ),
  //                       ),
  //                     ),
  //                   ],
  //                 ),
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  // ── Language Toggle ───────────────────────────────────
  Widget _buildLangToggle() {
    final FeedbackController feedbackController = Get.put(FeedbackController());
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ModernToggleButton(
              option1Label: 'English',
              option2Label: 'தமிழ்',
              subTitle1: 'Patient Feedback',
              subTitle2: 'நோயாளி கருத்து',
              initialSelection: isToggle,
              option1Icon: Icons.language_rounded,
              option2Icon: Icons.translate_rounded,
              selectedColor: _primary,
              selectedTextColor: Colors.white,
              unselectedTextColor: Colors.black,
              onChanged: (isEnglish) async {
                final lang = isEnglish ? "en" : "ta";
                isToggle = isEnglish;
                await feedbackController.fetchQuestion(lang);
                for (final controller in ratingCommentControllers.values) {
                  controller.clear();
                }
              },
            ),
          ),
        ),
      ],
    );
  }

  // ── Question Card ─────────────────────────────────────
  Widget _buildQuestionCard(QuestionModel question, int index) {
    final type = _normalizeType(question.questionType);

    // Type label config
    final (labelText, labelColor) = switch (type) {
      'krating' => ('Rating', Colors.orange),
      'rating' => ('Rating', Colors.orange),
      'yesno' => ('Yes or No Choice', Colors.teal),
      'crating' => ('Multiple Choice', Colors.teal),
      'text' => ('Text', Colors.purple),
      _ => ('Question', Colors.grey),
    };

    return Container(
      // margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        // borderRadius: BorderRadius.circular(14),
        // border: Border.all(color: Colors.grey.shade200),
        // boxShadow: [
        //   BoxShadow(
        //     color: Colors.black.withOpacity(0.04),
        //     blurRadius: 8,
        //     offset: const Offset(0, 3),
        //   ),
        // ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Question number + type badge row
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Number badge
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: question.questionType != "Label"
                        ? _primary
                        : Colors.green,
                    borderRadius: question.questionType != "Label"
                        ? BorderRadius.circular(8)
                        : BorderRadius.circular(16),
                  ),
                  child: Text(
                    question.displayOrder,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    question.questionText,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.45,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ),

                const SizedBox(width: 8),
                // Type badge
                // Container(
                //   padding: const EdgeInsets.symmetric(
                //     horizontal: 8,
                //     vertical: 3,
                //   ),
                //   decoration: BoxDecoration(
                //     color: labelColor.withOpacity(0.10),
                //     borderRadius: BorderRadius.circular(20),
                //     border: Border.all(color: labelColor.withOpacity(0.30)),
                //   ),
                //   child: Text(
                //     labelText,
                //     style: TextStyle(
                //       fontSize: 10,
                //       fontWeight: FontWeight.w600,
                //       color: labelColor.withOpacity(0.85),
                //     ),
                //   ),
                // ),
              ],
            ),

            // const SizedBox(height: 12),
            if (question.questionType != "Label") ...[
              const SizedBox(height: 12),
            ] else ...[
              const SizedBox(height: 0),
            ],

            // Content
            if (type == 'krating' || type=='rating') _buildRatingQuestion(question, index),
            if (type == 'yesno') _buildYesNoQuestion(question, index),
            if (type == 'crating') _buildCRatingQuestion(question, index),
            if (type == 'text') _buildTextQuestion(index),
          ],
        ),
      ),
    );
  }

  // ── Rating (single select radio) ─────────────────────
  // Widget _buildRatingQuestion(QuestionModel question, int questionIndex) {
  //   final selected = selectedRatingIndex[questionIndex];
  //
  //   return LayoutBuilder(
  //     builder: (context, constraints) {
  //       const spacing = 8.0;
  //       const minItemWidth = 140.0;
  //       final crossAxisCount = (constraints.maxWidth / (minItemWidth + spacing))
  //           .floor()
  //           .clamp(1, question.options.length);
  //       final itemWidth =
  //           (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
  //           crossAxisCount;
  //
  //       return Wrap(
  //         spacing: spacing,
  //         runSpacing: spacing,
  //         children: List.generate(question.options.length, (optionIndex) {
  //           final isSelected = selected == optionIndex;
  //           return SizedBox(
  //             width: itemWidth,
  //             child: _RadioOptionTile(
  //               label: question.options[optionIndex],
  //               isSelected: isSelected,
  //               primaryColor: _accent,
  //               onTap: () => setState(
  //                 () => selectedRatingIndex[questionIndex] = optionIndex,
  //               ),
  //             ),
  //           );
  //         }),
  //       );
  //     },
  //   );
  // }
  // Store controllers
  final Map<int, TextEditingController> ratingCommentControllers = {};

  Widget _buildRatingQuestion(QuestionModel question, int questionIndex) {
    final selected = selectedRatingIndex[questionIndex];

    ratingCommentControllers.putIfAbsent(
      questionIndex,
      () => TextEditingController(),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            const spacing = 8.0;
            const minItemWidth = 140.0;

            final crossAxisCount =
                (constraints.maxWidth / (minItemWidth + spacing)).floor().clamp(
                  1,
                  question.options.length,
                );

            final itemWidth =
                (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
                crossAxisCount;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: List.generate(question.options.length, (optionIndex) {
                final isSelected = selected == optionIndex;

                return SizedBox(
                  width: itemWidth,
                  child: _RadioOptionTile(
                    label: question.options[optionIndex],
                    isSelected: isSelected,
                    primaryColor: _accent,
                    onTap: () => setState(
                      () => selectedRatingIndex[questionIndex] = optionIndex,
                    ),
                  ),
                );
              }),
            );
          },
        ),

        const SizedBox(height: 6),
        TextFormField(
          controller: ratingCommentControllers[questionIndex],
          maxLines: 1,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Comments',
          ),
        ),
        SizedBox(
          height: 1,
          child: CustomPaint(
            painter: DottedLinePainter(),
            size: const Size(double.infinity, 1),
          ),
        ),
        // TextFormField(
        //   controller: ratingCommentControllers[questionIndex],
        //   maxLines: 1,
        //   inputFormatters: [
        //     FilteringTextInputFormatter.allow(
        //       RegExp(r'[a-zA-Z0-9\u0B80-\u0BFF\s.,]'),
        //     ),
        //   ],
        //   style: TextStyle(fontSize: 14, color: Colors.black),
        //   decoration: InputDecoration(
        //     hintText: isToggle ? 'Comments' : 'கருத்து',
        //     hintStyle: const TextStyle(fontSize: 14),
        //     border: InputBorder.none,
        //     enabledBorder: const UnderlineInputBorder(
        //       borderSide: BorderSide(color: Color(0xFFD6DCE5), width: 1),
        //     ),
        //     focusedBorder: const UnderlineInputBorder(
        //       borderSide: BorderSide(color: Color(0xFF4F6FAF), width: 1.5),
        //     ),
        //     contentPadding: const EdgeInsets.symmetric(
        //       vertical: 8,
        //       horizontal: 4,
        //     ),
        //   ),
        // ),
      ],
    );
  }

  // ── CRating (multi-select checkboxes) ──────────────────
  Widget _buildCRatingQuestion(QuestionModel question, int questionIndex) {
    final options = question.options.isEmpty
        ? ['option 1', 'option 2']
        : question.options;
    selectedCRatingIndices.putIfAbsent(questionIndex, () => <int>{});
    final selectedSet = selectedCRatingIndices[questionIndex]!;

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        const minItemWidth = 150.0;
        final crossAxisCount = (constraints.maxWidth / (minItemWidth + spacing))
            .floor()
            .clamp(1, options.length);
        final itemWidth =
            (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
            crossAxisCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Helper label
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  // Icon(
                  //   Icons.check_box_outlined,
                  //   size: 14,
                  //   color: Colors.teal.shade400,
                  // ),
                  // const SizedBox(width: 4),
                  // Text(
                  //   'Select all that apply',
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     color: Colors.teal.shade600,
                  //     fontWeight: FontWeight.w500,
                  //   ),
                  // ),
                ],
              ),
            ),
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: List.generate(options.length, (optionIndex) {
                final isSelected = selectedSet.contains(optionIndex);
                return SizedBox(
                  width: itemWidth,
                  child: _CheckboxOptionTile(
                    label: options[optionIndex],
                    isSelected: isSelected,
                    primaryColor: Colors.teal,
                    onTap: () {
                      setState(() {
                        if (isSelected) {
                          selectedSet.remove(optionIndex);
                        } else {
                          selectedSet.add(optionIndex);
                        }
                      });
                    },
                  ),
                );
              }),
            ),
            SizedBox(height: 16),
            SizedBox(
              height: 1,
              child: CustomPaint(
                painter: DottedLinePainter(),
                size: const Size(double.infinity, 1),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildYesNoQuestion(QuestionModel question, int questionIndex) {
    final options = question.options.isEmpty ? ['Yes', 'No'] : question.options;

    // Store only one selected index
    selectedYesNoIndices.putIfAbsent(questionIndex, () => {-1});

    int selectedIndex = selectedYesNoIndices[questionIndex]!.isEmpty
        ? -1
        : selectedYesNoIndices[questionIndex]!.first;

    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        const minItemWidth = 150.0;

        final crossAxisCount = (constraints.maxWidth / (minItemWidth + spacing))
            .floor()
            .clamp(1, options.length);

        final itemWidth =
            (constraints.maxWidth - (spacing * (crossAxisCount - 1))) /
            crossAxisCount;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: spacing,
              runSpacing: spacing,
              children: List.generate(options.length, (optionIndex) {
                final isSelected = selectedIndex == optionIndex;

                return SizedBox(
                  width: itemWidth,
                  child: _CheckboxOptionTile(
                    label: options[optionIndex],
                    isSelected: isSelected,
                    primaryColor: Colors.teal,
                    onTap: () {
                      setState(() {
                        // Clear previous selection
                        selectedYesNoIndices[questionIndex]!.clear();

                        // Add only current selection
                        selectedYesNoIndices[questionIndex]!.add(optionIndex);
                      });
                    },
                  ),
                );
              }),
            ),
          ],
        );
      },
    );
  }

  // ── Text Question ─────────────────────────────────────
  Widget _buildTextQuestion(int questionIndex) {
    textControllers.putIfAbsent(questionIndex, () => TextEditingController());

    return TextField(
      controller: textControllers[questionIndex]!,
      maxLines: 4,
      minLines: 3,
      textInputAction: TextInputAction.newline,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        height: 1.4,
        color: Colors.black87,
      ),
      inputFormatters: [
        FilteringTextInputFormatter.allow(
          RegExp(r'[a-zA-Z0-9\u0B80-\u0BFF\s.,]'),
        ),
      ],
      decoration: InputDecoration(
        hintText: 'Type your feedback here...',
        hintStyle: TextStyle(
          color: Colors.grey.shade500,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: _accent, width: 1.5),
        ),
      ),
    );
  }

  // ── Submit Button ─────────────────────────────────────
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: isSubmitting ? null : _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryLight,
          foregroundColor: Colors.white,
          disabledBackgroundColor: Colors.grey.shade300,
          elevation: 2,
          shadowColor: _primary.withOpacity(0.4),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: isSubmitting
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  color: Colors.white,
                ),
              )
            : const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.send_rounded, size: 20),
                  SizedBox(width: 10),
                  Text(
                    'Submit Feedback',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
      ),
    );
  }
}

/// ======================================================
/// REUSABLE OPTION TILES
/// ======================================================

// Radio tile — used for Rating
class _RadioOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  const _RadioOptionTile({
    required this.label,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor.withOpacity(0.07) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              // Radio dot
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? primaryColor : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                child: Center(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    width: isSelected ? 8 : 0,
                    height: isSelected ? 8 : 0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: primaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? primaryColor : Colors.blueGrey.shade700,
                    height: 1.2,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Checkbox tile — used for YesNo (multi-select)
class _CheckboxOptionTile extends StatelessWidget {
  final String label;
  final bool isSelected;
  final Color primaryColor;
  final VoidCallback onTap;

  const _CheckboxOptionTile({
    required this.label,
    required this.isSelected,
    required this.primaryColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            color: isSelected ? primaryColor.withOpacity(0.07) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isSelected ? primaryColor : Colors.grey.shade300,
              width: isSelected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              // Checkbox square
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: isSelected ? primaryColor : Colors.transparent,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: isSelected ? primaryColor : Colors.grey.shade400,
                    width: 1.8,
                  ),
                ),
                child: isSelected
                    ? const Icon(
                        Icons.check_rounded,
                        size: 13,
                        color: Colors.white,
                      )
                    : null,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? primaryColor : Colors.blueGrey.shade700,
                    height: 1.25,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
