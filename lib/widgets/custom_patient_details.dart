import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:ipfeedback/controllers/feedback_controller.dart';

Widget patientCard() {
  FeedbackController feedbackController = Get.put(FeedbackController());
  return Obx(() {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF1565C0), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.12),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Left Icons
            Column(
              children: [
                Icon(
                  Icons.person_pin_outlined,
                  size: 24,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(height: 6),
                Icon(
                  Icons.badge_outlined,
                  size: 24,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(height: 6),
                Icon(
                  Icons.local_hospital_outlined,
                  size: 24,
                  color: Colors.grey.shade500,
                ),
                const SizedBox(height: 6),
                Icon(Icons.bed_outlined, size: 24, color: Colors.grey.shade500),
                const SizedBox(height: 6),
                Container(
                  width: 18,
                  height: 18,
                  decoration: const BoxDecoration(
                    color: Color(0xFF6E92DB),
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),

            const SizedBox(width: 14),

            /// Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// Name & Age
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${feedbackController.patData.first.patientName}",
                          style: const TextStyle(
                            color: Color(0xFF1565C0),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      // Text(
                      //   "${feedbackController.patData.first.age}",
                      //   style: const TextStyle(
                      //     color: Color(0xFF1565C0),
                      //     fontSize: 14,
                      //     fontWeight: FontWeight.bold,
                      //   ),
                      // ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    feedbackController.patData.first.regNo! +
                        " | " +
                        feedbackController.patData.first.iPatId.toString()!,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${feedbackController.patData.first.doctor}",
                    style: const TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "${feedbackController.patData.first.room}",
                    style: TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 8),

                  Row(
                    children: [
                      Text("- Generals", style: TextStyle(fontSize: 12)),
                      const SizedBox(width: 12),
                      const Icon(
                        Icons.bed_outlined,
                        size: 18,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          "${feedbackController.patData.first.endDate}",
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });
}
// Widget patientCard() {
//   final FeedbackController feedbackController =
//   Get.put(FeedbackController());
//
//   return Obx(() {
//     final patient = feedbackController.patData.first;
//
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: const Color(0xFF1565C0),
//           width: 1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.06),
//             blurRadius: 4,
//             offset: const Offset(0, 1),
//           ),
//         ],
//       ),
//       child: Row(
//         children: [
//           // Avatar
//           Container(
//             width: 32,
//             height: 32,
//             decoration: BoxDecoration(
//               color: const Color(0xFFEAF2FF),
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: const Icon(
//               Icons.person_outline,
//               color: Color(0xFF1565C0),
//               size: 18,
//             ),
//           ),
//           const SizedBox(width: 8),
//
//           // Name + reg no (fixed-ish width so info section has room)
//           Expanded(
//             flex: 3,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Text(
//                   "${patient.patientName}",
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(
//                     color: Color(0xFF1565C0),
//                     fontSize: 13,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//                 Text(
//                   "${patient.regNo} • ${patient.iPatId}",
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: TextStyle(
//                     color: Colors.grey.shade600,
//                     fontSize: 10.5,
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//
//           Container(
//             height: 30,
//             width: 1,
//             color: Colors.grey.shade200,
//             margin: const EdgeInsets.symmetric(horizontal: 8),
//           ),
//
//           // Doctor / Room / Date — compact, inline
//           Expanded(
//             flex: 4,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 _inlineInfo(Icons.medical_services_outlined, "${patient.doctor}"),
//                 const SizedBox(height: 2),
//                 Row(
//                   children: [
//                     Expanded(child: _inlineInfo(Icons.bed_outlined, "${patient.room}")),
//                     Expanded(child: _inlineInfo(Icons.calendar_today_outlined, "${patient.endDate}")),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   });
// }
//
// /// Ultra-compact icon + value row (no title label, saves vertical space)
// Widget _inlineInfo(IconData icon, String value) {
//   return Row(
//     mainAxisSize: MainAxisSize.min,
//     children: [
//       Icon(icon, size: 12, color: Colors.grey.shade500),
//       const SizedBox(width: 3),
//       Flexible(
//         child: Text(
//           value,
//           maxLines: 1,
//           overflow: TextOverflow.ellipsis,
//           style: const TextStyle(
//             fontSize: 10.5,
//             fontWeight: FontWeight.w600,
//             color: Color(0xFF333333),
//           ),
//         ),
//       ),
//     ],
//   );
// }
// Widget patientCard() {
//   final FeedbackController feedbackController =
//   Get.put(FeedbackController());
//
//   return Obx(() {
//     final patient = feedbackController.patData.first;
//
//     return Container(
//       margin: const EdgeInsets.all(8),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: Colors.white,
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(
//           color: const Color(0xFF1565C0),
//           width: 1.1,
//         ),
//         boxShadow: [
//           BoxShadow(
//             color: Colors.black.withOpacity(.08),
//             blurRadius: 6,
//             offset: const Offset(0, 2),
//           ),
//         ],
//       ),
//       child: Column(
//         children: [
//
//           // ============================================================
//           // SECTION 1 - PATIENT
//           // ============================================================
//           Row(
//             children: [
//               Container(
//                 width: 42,
//                 height: 42,
//                 decoration: BoxDecoration(
//                   color: const Color(0xFFEAF2FF),
//                   borderRadius: BorderRadius.circular(12),
//                 ),
//                 child: const Icon(
//                   Icons.person_outline,
//                   color: Color(0xFF1565C0),
//                   size: 25,
//                 ),
//               ),
//
//               const SizedBox(width: 10),
//
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       "${patient.patientName}",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: const TextStyle(
//                         color: Color(0xFF1565C0),
//                         fontSize: 14,
//                         fontWeight: FontWeight.w700,
//                       ),
//                     ),
//
//                     const SizedBox(height: 3),
//
//                     Text(
//                       "${patient.regNo}  •  ${patient.iPatId}",
//                       maxLines: 1,
//                       overflow: TextOverflow.ellipsis,
//                       style: TextStyle(
//                         color: Colors.grey.shade700,
//                         fontSize: 11.5,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 10),
//
//           // Divider between sections
//           Divider(
//             height: 1,
//             thickness: .8,
//             color: Colors.grey.shade200,
//           ),
//
//           const SizedBox(height: 10),
//
//           // ============================================================
//           // SECTION 2 - MEDICAL DETAILS
//           // ============================================================
//           Row(
//             children: [
//
//               // Doctor
//               Expanded(
//                 child: _patientInfoItem(
//                   icon: Icons.medical_services_outlined,
//                   title: "Doctor",
//                   value: "${patient.doctor}",
//                 ),
//               ),
//
//               const SizedBox(width: 8),
//
//               // Room
//               Expanded(
//                 child: _patientInfoItem(
//                   icon: Icons.bed_outlined,
//                   title: "Room",
//                   value: "${patient.room}",
//                 ),
//               ),
//
//               const SizedBox(width: 8),
//
//               // Ward / Date
//               Expanded(
//                 child: _patientInfoItem(
//                   icon: Icons.calendar_today_outlined,
//                   title: "General",
//                   value: "${patient.endDate}",
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   });
// }
//
//
// /// Compact patient information item
// Widget _patientInfoItem({
//   required IconData icon,
//   required String title,
//   required String value,
// }) {
//   return Row(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     children: [
//       Icon(
//         icon,
//         size: 17,
//         color: Colors.grey.shade500,
//       ),
//
//       const SizedBox(width: 6),
//
//       Expanded(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               title,
//               style: TextStyle(
//                 fontSize: 10,
//                 color: Colors.grey.shade500,
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//
//             const SizedBox(height: 2),
//
//             Text(
//               value,
//               maxLines: 1,
//               overflow: TextOverflow.ellipsis,
//               style: const TextStyle(
//                 fontSize: 11.5,
//                 fontWeight: FontWeight.w600,
//                 color: Color(0xFF333333),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ],
//   );
// }