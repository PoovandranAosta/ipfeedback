// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:ipfeedback/models/bed_master_model.dart';
// import 'package:ipfeedback/models/ward_master_model.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import '../../config/config.dart';
//
// import '../../config/encryption_helper.dart';
// import '../../controllers/dashboard_controller.dart';
// import '../../services/app_utils.dart';
// import '../../widgets/custom_dropdown.dart';
// import '../../widgets/custom_loaded.dart';
// import '../../widgets/custom_toast.dart';
//
// class QrGenerationScreen extends StatelessWidget {
//   const QrGenerationScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     Get.put(DashboardController());
//
//     return Scaffold(
//       backgroundColor: const Color(0xFFF5F7FB),
//       body: SafeArea(
//         child: Obx(() {
//           final DashboardController controller =
//               Get.find<DashboardController>();
//
//           return SingleChildScrollView(
//             physics: const BouncingScrollPhysics(),
//             padding: const EdgeInsets.only(bottom: 25),
//             child: Column(
//               children: [
//                 // _buildHeader(),
//                 const SizedBox(height: 18),
//
//                 if (controller.isLoading.value) ...[
//                   Center(
//                     child: CustomThreeArchedLoader(
//                       size: 60,
//                       color: Colors.blue,
//                     ),
//                   ),
//                 ],
//                 if (!controller.isLoading.value) ...[
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 16),
//                     child: Column(
//                       children: [
//                         _buildWardDropdown(context),
//
//                         const SizedBox(height: 20),
//                         _buildBedDropdown(context),
//
//                         const SizedBox(height: 24),
//
//                         if (controller.selectedWard.value != null &&
//                             controller.selectedBed.value != null)
//                           _buildQrCard(context),
//                       ],
//                     ),
//                   ),
//                 ],
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
//
// /// =======================================================
// /// HEADER
// /// =======================================================
//
// Widget _buildHeader() {
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.fromLTRB(20, 22, 20, 30),
//     decoration: const BoxDecoration(
//       gradient: LinearGradient(
//         colors: [Color(0xFF0F4CBA), Color(0xFF4A90E2)],
//         begin: Alignment.topLeft,
//         end: Alignment.bottomRight,
//       ),
//       borderRadius: BorderRadius.only(
//         bottomLeft: Radius.circular(32),
//         bottomRight: Radius.circular(32),
//       ),
//     ),
//     child: Row(
//       children: [
//         Container(
//           height: 80,
//           width: 80,
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(22),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(.08),
//                 blurRadius: 12,
//                 offset: const Offset(0, 4),
//               ),
//             ],
//           ),
//           child: Image.asset("assets/images/logo.png", fit: BoxFit.contain),
//         ),
//
//         const SizedBox(width: 16),
//
//         Expanded(
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Text(
//                 "Kovai Medical Center and Hospital Limited",
//                 style: TextStyle(
//                   color: Colors.white,
//                   fontSize: 19,
//                   fontWeight: FontWeight.w800,
//                   height: 1.4,
//                 ),
//               ),
//
//               const SizedBox(height: 10),
//
//               Row(
//                 children: [
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 14,
//                       vertical: 7,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(.18),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: Text(
//                       Config.envName,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                   Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 14,
//                       vertical: 7,
//                     ),
//                     decoration: BoxDecoration(
//                       color: Colors.white.withOpacity(.18),
//                       borderRadius: BorderRadius.circular(30),
//                     ),
//                     child: const Text(
//                       "Department Feedback",
//                       style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.w600,
//                         fontSize: 13,
//                       ),
//                     ),
//                   ),
//                   SizedBox(width: 8),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ],
//     ),
//   );
// }
//
// /// =======================================================
// /// DEPARTMENT DROPDOWN
// /// =======================================================
//
// Widget _buildWardDropdown(BuildContext context) {
//   final DashboardController controller = Get.find<DashboardController>();
//
//   Future<void> onClickWardList(WardMasterModel? value) async {
//     if (value == null) return;
//
//     CustomToast.showLoading(context: context);
//
//     controller.selectedWard.value = value;
//
//     await controller.fetchBedMaster();
//
//     CustomToast.hideLoading();
//
//     debugPrint("Selected Ward : ${value.cWardDesc}");
//   }
//
//   return Container(
//     padding: const EdgeInsets.all(18),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(22),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(.05),
//           blurRadius: 15,
//           offset: const Offset(0, 6),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Row(
//           children: [
//             Icon(Icons.apartment_rounded, color: Color(0xFF0F4CBA)),
//             SizedBox(width: 8),
//             Text(
//               "Select Ward",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 16),
//
//         Obx(() {
//           return CommonDropdown<WardMasterModel>(
//             items: controller.wardMaster,
//
//             selectedValue:
//                 controller.wardMaster.contains(controller.selectedWard.value)
//                 ? controller.selectedWard.value
//                 : null,
//
//             labelText: 'Choose Ward',
//
//             itemLabel: (WardMasterModel item) => item.cWardDesc.toString(),
//
//             onChanged: (value) => onClickWardList(value),
//           );
//         }),
//       ],
//     ),
//   );
// }
//
// Widget _buildBedDropdown(BuildContext context) {
//   final DashboardController controller = Get.find<DashboardController>();
//
//   Future<void> onClickBedList(BedMasterModel? value) async {
//     if (value == null) return;
//
//     CustomToast.showLoading(context: context);
//
//     controller.selectedBed.value = value;
//
//     await controller.fetchPatientInfo();
//
//     CustomToast.hideLoading();
//
//     debugPrint("Selected Ward : ${value.column1}");
//   }
//
//   return Container(
//     padding: const EdgeInsets.all(18),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(22),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(.05),
//           blurRadius: 15,
//           offset: const Offset(0, 6),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Row(
//           children: [
//             Icon(Icons.apartment_rounded, color: Color(0xFF0F4CBA)),
//             SizedBox(width: 8),
//             Text(
//               "Select Bed",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//             ),
//           ],
//         ),
//
//         const SizedBox(height: 16),
//
//         Obx(() {
//           return CommonDropdown<BedMasterModel>(
//             items: controller.bedMaster,
//
//             selectedValue:
//                 controller.bedMaster.contains(controller.selectedBed.value)
//                 ? controller.selectedBed.value
//                 : null,
//
//             labelText: 'Choose Bed',
//
//             itemLabel: (BedMasterModel item) => item.column1.toString(),
//
//             onChanged: (value) => onClickBedList(value),
//           );
//         }),
//       ],
//     ),
//   );
// }
//
// /// =======================================================
// /// QR CARD
// /// =======================================================
//
// Widget _buildQrCard(BuildContext context) {
//   final DashboardController controller = Get.find<DashboardController>();
//
//   final selectedWard = controller.selectedWard.value;
//
//   String encryptDept = SecureEncryptionHelper.encrypt(
//     selectedWard!.iWardId.toString(),
//   );
//
//   final String qrUrl = "${Config.scanUrl}$encryptDept";
//
//   return Container(
//     width: double.infinity,
//     padding: const EdgeInsets.all(22),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(28),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(.06),
//           blurRadius: 18,
//           offset: const Offset(0, 8),
//         ),
//       ],
//     ),
//     child: Column(
//       children: [
//         // /// ICON
//         // Container(
//         //   padding: const EdgeInsets.all(14),
//         //   decoration: BoxDecoration(
//         //     color: const Color(0xFFEAF2FF),
//         //     borderRadius: BorderRadius.circular(18),
//         //   ),
//         //   child: const Icon(
//         //     Icons.qr_code_2_rounded,
//         //     size: 42,
//         //     color: Color(0xFF0F4CBA),
//         //   ),
//         // ),
//         //
//         // const SizedBox(height: 18),
//
//         /// DEPARTMENT NAME
//         Text(
//           selectedWard?.cWardDesc ?? "",
//           textAlign: TextAlign.center,
//           style: const TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: Colors.black87,
//           ),
//         ),
//
//         const SizedBox(height: 8),
//
//         Text(
//           "Scan this QR code to submit patient feedback.",
//           textAlign: TextAlign.center,
//           style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
//         ),
//
//         const SizedBox(height: 24),
//
//         /// QR CODE CONTAINER
//         Container(
//           padding: const EdgeInsets.all(18),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(24),
//             border: Border.all(color: Colors.grey.shade200),
//           ),
//           child: QrImageView(
//             data: qrUrl,
//             version: QrVersions.auto,
//             size: 230,
//             eyeStyle: const QrEyeStyle(
//               eyeShape: QrEyeShape.square,
//               color: Color(0xFF0F4CBA),
//             ),
//             dataModuleStyle: const QrDataModuleStyle(
//               dataModuleShape: QrDataModuleShape.square,
//               color: Colors.black,
//             ),
//           ),
//         ),
//
//         const SizedBox(height: 22),
//
//         /// LINK DISPLAY
//         Container(
//           width: double.infinity,
//           padding: const EdgeInsets.all(14),
//           decoration: BoxDecoration(
//             color: const Color(0xFFF4F7FC),
//             borderRadius: BorderRadius.circular(16),
//             border: Border.all(color: Colors.grey.shade300),
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               const Row(
//                 children: [
//                   Icon(Icons.link_rounded, size: 18, color: Color(0xFF0F4CBA)),
//                   SizedBox(width: 8),
//                   Text(
//                     "Feedback Link",
//                     style: TextStyle(fontWeight: FontWeight.w700),
//                   ),
//                 ],
//               ),
//
//               const SizedBox(height: 10),
//
//               SelectableText(
//                 qrUrl,
//                 style: const TextStyle(
//                   color: Colors.blue,
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ],
//           ),
//         ),
//
//         const SizedBox(height: 24),
//
//         /// BUTTONS
//         Row(
//           children: [
//             /// OPEN BUTTON
//             Expanded(
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   elevation: 0,
//                   backgroundColor: const Color(0xFF0F4CBA),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 22),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 onPressed: () async {
//                   await AppUtils.openUrl(qrUrl);
//                 },
//                 icon: const Icon(Icons.open_in_new_rounded),
//                 label: const Text(
//                   "Open Link",
//                   style: TextStyle(fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ),
//
//             const SizedBox(width: 14),
//
//             /// DOWNLOAD BUTTON
//             Expanded(
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   elevation: 0,
//                   backgroundColor: const Color(0xFF12B76A),
//                   foregroundColor: Colors.white,
//                   padding: const EdgeInsets.symmetric(vertical: 22),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(16),
//                   ),
//                 ),
//                 onPressed: () {
//                   controller.generateQrDepartment(
//                     selectedWard.cWardDesc ?? "",
//                     selectedWard.iWardId.toString() ?? "",
//                   );
//                 },
//                 icon: const Icon(Icons.print),
//                 label: const Text(
//                   "Print",
//                   style: TextStyle(fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:ipfeedback/models/bed_master_model.dart';
import 'package:ipfeedback/models/ward_master_model.dart';
import 'package:ipfeedback/widgets/custom_checkbox.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../controllers/dashboard_controller.dart';
import '../../services/app_utils.dart';
import '../../widgets/custom_dropdown.dart';
import '../../widgets/custom_loaded.dart';
import '../../widgets/custom_toast.dart';

class QrGenerationScreen extends StatelessWidget {
  const QrGenerationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(DashboardController());

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FB),
      body: SafeArea(
        child: Obx(() {
          final DashboardController controller =
              Get.find<DashboardController>();

          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.only(bottom: 25),
            child: Column(
              children: [
                const SizedBox(height: 18),

                if (controller.isLoading.value) ...[
                  Center(
                    child: CustomThreeArchedLoader(
                      size: 60,
                      color: Colors.blue,
                    ),
                  ),
                ],
                if (!controller.isLoading.value) ...[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        // _buildWardDropdown(context),
                        // const SizedBox(height: 20),
                        // _buildBedDropdown(context),
                        // const SizedBox(height: 24),
                        _buildWardDropdown(context),
                        const SizedBox(height: 20),

                        if (controller.selectedWard.value != null) ...[
                          _buildBedDropdown(context),
                          const SizedBox(height: 24),
                        ] else ...[
                          _buildSelectWardHint(),
                          const SizedBox(height: 24),
                        ],

                        if (controller.selectedBed.value != null) ...[
                          _buildCheckBox(),
                          const SizedBox(height: 24),
                        ],

                        // Bed selected but backend returned no patient
                        if (controller.selectedWard.value != null &&
                            controller.selectedBed.value != null &&
                            controller.patientNotFound.value)
                          _buildPatientNotFoundCard(),

                        // Patient found, waiting on / failed the URL fetch
                        if (controller.selectedPatient.value != null &&
                            controller.isUrlLoading.value)
                          _buildUrlLoadingCard(),

                        if (controller.selectedPatient.value != null &&
                            !controller.isUrlLoading.value &&
                            controller.urlFetchFailed.value)
                          _buildUrlFailedCard(context),

                        // Everything succeeded
                        if (controller.selectedPatient.value != null &&
                            !controller.isUrlLoading.value &&
                            !controller.urlFetchFailed.value &&
                            controller.patUrl.value.isNotEmpty)
                          _buildQrCard(context),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          );
        }),
      ),
    );
  }
}

Widget _buildCheckBox() {
  DashboardController controller = Get.put(DashboardController());
  return Obx(() {
    return Row(
      children: [
        Expanded(
          child: CustomCheckBoxItem(
            title: "WiFi",
            icon: Icons.wifi,
            value: controller.checkWifi.value,
            selectedColor: Colors.blue,
            onChanged: (value) {
              print(value);
              controller.checkWifi.value = value;
            },
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: CustomCheckBoxItem(
            title: "IP Feedback",
            icon: Icons.feedback_outlined,
            value: controller.checkFeedback.value,
            selectedColor: Colors.orange,
            onChanged: (value) {
              print(value);
              controller.checkFeedback.value = value;
            },
          ),
        ),

        const SizedBox(width: 10),

        Expanded(
          child: CustomCheckBoxItem(
            title: "Food Order",
            icon: Icons.restaurant_outlined,
            value: controller.checkFoodOrder.value,
            selectedColor: Colors.green,
            onChanged: (value) {
              print(value);
              controller.checkFoodOrder.value = value;
            },
          ),
        ),
      ],
    );
  });
}

/// =======================================================
/// WARD DROPDOWN
/// =======================================================
///
///
/// final TextEditingController wardTextController = TextEditingController();
final FocusNode wardFocusNode = FocusNode();

final TextEditingController bedTextController = TextEditingController();
final FocusNode bedFocusNode = FocusNode();

Widget _buildSelectWardHint() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: const Color(0xFFF4F7FC),
      borderRadius: BorderRadius.circular(22),
      border: Border.all(color: Colors.grey.shade200),
    ),
    child: Row(
      children: [
        Icon(Icons.info_outline_rounded, color: Colors.grey.shade500, size: 20),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            "Select a ward first to choose a bed.",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
          ),
        ),
      ],
    ),
  );
}

// Widget _buildWardDropdown(BuildContext context) {
//   final DashboardController controller = Get.find<DashboardController>();
//   final TextEditingController wardTextController = TextEditingController(
//     text: controller.selectedWard.value?.cWardDesc?.toString() ?? "",
//   );
//
//   Future<void> onClickWardList(WardMasterModel? value) async {
//     if (value == null) return;
//
//     CustomToast.showLoading(context: context);
//     controller.selectedWard.value = value;
//     await controller.fetchBedMaster();
//     CustomToast.hideLoading();
//
//     debugPrint("Selected Ward : ${value.cWardDesc}");
//   }
//
//   return Container(
//     padding: const EdgeInsets.all(18),
//     decoration: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(22),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.black.withOpacity(.05),
//           blurRadius: 15,
//           offset: const Offset(0, 6),
//         ),
//       ],
//     ),
//     child: Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Row(
//           children: [
//             Icon(Icons.apartment_rounded, color: Color(0xFF0F4CBA)),
//             SizedBox(width: 8),
//             Text(
//               "Select Ward",
//               style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
//             ),
//           ],
//         ),
//         const SizedBox(height: 16),
//         Obx(() {
//           // Keep field text in sync if ward selection is reset elsewhere
//           if (controller.selectedWard.value == null &&
//               wardTextController.text.isNotEmpty) {
//             wardTextController.clear();
//           }
//
//           return TypeAheadField<WardMasterModel>(
//             controller: wardTextController,
//             hideOnEmpty: false,
//             builder: (context, textController, focusNode) {
//               return TextField(
//                 controller: textController,
//                 focusNode: focusNode,
//                 decoration: InputDecoration(
//                   labelText: 'Choose Ward',
//                   hintText: 'Type to search ward...',
//                   filled: true,
//                   fillColor: const Color(0xFFF7F9FC),
//                   prefixIcon: const Icon(
//                     Icons.search_rounded,
//                     color: Color(0xFF0F4CBA),
//                   ),
//                   suffixIcon: textController.text.isNotEmpty
//                       ? IconButton(
//                           icon: const Icon(Icons.clear_rounded, size: 20),
//                           onPressed: () {
//                             textController.clear();
//                             controller.selectedWard.value = null;
//                             controller.bedMaster.clear();
//                             controller.selectedBed.value = null;
//                             controller.patientData.clear();
//                             controller.selectedPatient.value = null;
//                             controller.patUrl.value = "";
//
//                             focusNode.requestFocus();
//                           },
//                         )
//                       : null,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(14),
//                     borderSide: BorderSide.none,
//                   ),
//                   contentPadding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 14,
//                   ),
//                 ),
//               );
//             },
//             suggestionsCallback: (pattern) {
//               if (pattern.isEmpty) return controller.wardMaster.toList();
//
//               return controller.wardMaster
//                   .where(
//                     (ward) => (ward.cWardDesc ?? "")
//                         .toString()
//                         .toLowerCase()
//                         .contains(pattern.toLowerCase()),
//                   )
//                   .toList();
//             },
//             itemBuilder: (context, WardMasterModel ward) {
//               final bool isSelected =
//                   controller.selectedWard.value?.cWardDesc == ward.cWardDesc;
//
//               return Container(
//                 color: isSelected ? const Color(0xFFEAF2FF) : null,
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16,
//                   vertical: 12,
//                 ),
//                 child: Row(
//                   children: [
//                     const Icon(
//                       Icons.apartment_rounded,
//                       size: 18,
//                       color: Color(0xFF0F4CBA),
//                     ),
//                     const SizedBox(width: 10),
//                     Text(
//                       ward.cWardDesc?.toString() ?? "",
//                       style: const TextStyle(fontWeight: FontWeight.w600),
//                     ),
//                   ],
//                 ),
//               );
//             },
//             emptyBuilder: (context) => Container(
//               padding: const EdgeInsets.all(16),
//               alignment: Alignment.center,
//               child: Text(
//                 "No matching wards found",
//                 style: TextStyle(color: Colors.grey.shade600),
//               ),
//             ),
//             onSelected: (WardMasterModel ward) {
//               wardTextController.text = ward.cWardDesc?.toString() ?? "";
//               onClickWardList(ward);
//             },
//             decorationBuilder: (context, child) {
//               return Material(
//                 type: MaterialType.card,
//                 elevation: 4,
//                 borderRadius: BorderRadius.circular(14),
//                 child: child,
//               );
//             },
//             offset: const Offset(0, 8),
//             constraints: const BoxConstraints(maxHeight: 260),
//           );
//         }),
//       ],
//     ),
//   );
// }
/// =======================================================
/// WARD DROPDOWN
/// =======================================================

Widget _buildWardDropdown(BuildContext context) {
  final DashboardController controller = Get.find<DashboardController>();

  Future<void> onClickWardList(WardMasterModel? value) async {
    if (value == null) return;

    controller.wardTextController.text = value.cWardDesc?.toString() ?? "";

    controller.selectedBed.value = null;
    controller.bedTextController.text = "";

    CustomToast.showLoading(context: context);
    controller.selectedWard.value = value;
    await controller.fetchBedMaster();
    CustomToast.hideLoading();

    debugPrint("Selected Ward : ${value.cWardDesc}");
  }

  void onClear() {
    controller.wardTextController.clear();
    controller.selectedWard.value = null;
    controller.bedMaster.clear();
    controller.selectedBed.value = null;
    controller.patientData.clear();
    controller.selectedPatient.value = null;
    controller.patUrl.value = "";
    controller.wardFocusNode.requestFocus();
  }

  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.apartment_rounded, color: Color(0xFF0F4CBA)),
            SizedBox(width: 8),
            Text(
              "Select Ward",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          final wards = controller.wardMaster.toList();

          return TypeAheadField<WardMasterModel>(
            controller: controller.wardTextController,
            focusNode: controller.wardFocusNode,
            hideOnEmpty: false,
            builder: (context, textController, focusNode) {
              return TextField(
                controller: textController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: 'Choose Ward',
                  hintText: 'Type to search ward...',
                  filled: true,
                  fillColor: const Color(0xFFF7F9FC),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF0F4CBA),
                  ),
                  suffixIcon: textController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: onClear,
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              );
            },
            suggestionsCallback: (pattern) {
              if (pattern.isEmpty) return wards;

              return wards
                  .where(
                    (ward) => (ward.cWardDesc ?? "")
                        .toString()
                        .toLowerCase()
                        .contains(pattern.toLowerCase()),
                  )
                  .toList();
            },
            itemBuilder: (context, WardMasterModel ward) {
              final bool isSelected =
                  controller.selectedWard.value?.cWardDesc == ward.cWardDesc;

              return Container(
                color: isSelected ? const Color(0xFFEAF2FF) : null,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.apartment_rounded,
                      size: 18,
                      color: Color(0xFF0F4CBA),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      ward.cWardDesc?.toString() ?? "",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            },
            emptyBuilder: (context) => Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Text(
                "No matching wards found",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            onSelected: (ward) => onClickWardList(ward),
            decorationBuilder: (context, child) {
              return Material(
                type: MaterialType.card,
                elevation: 4,
                borderRadius: BorderRadius.circular(14),
                child: child,
              );
            },
            offset: const Offset(0, 8),
            constraints: const BoxConstraints(maxHeight: 260),
          );
        }),
      ],
    ),
  );
}

/// =======================================================
/// BED DROPDOWN — fetches patient info + url on selection
/// =======================================================

Widget _buildBedDropdown(BuildContext context) {
  final DashboardController controller = Get.find<DashboardController>();

  Future<void> onClickBedList(BedMasterModel? value) async {
    if (value == null) return;

    controller.bedTextController.text = value.column1?.toString() ?? "";

    // CustomToast.showLoading(context: context);
    controller.selectedBed.value = value;
    await controller.fetchPatientInfo();
    // CustomToast.hideLoading();

    debugPrint("Selected Bed : ${value.column1}");
  }

  void onClear() {
    controller.bedTextController.clear();
    controller.selectedBed.value = null;
    controller.patientData.clear();
    controller.selectedPatient.value = null;
    controller.patUrl.value = "";
    controller.bedFocusNode.requestFocus();
  }

  return Container(
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(22),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.bed_rounded, color: Color(0xFF0F4CBA)),
            SizedBox(width: 8),
            Text(
              "Select Bed",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          final beds = controller.bedMaster.toList();

          return TypeAheadField<BedMasterModel>(
            controller: controller.bedTextController,
            focusNode: controller.bedFocusNode,
            hideOnEmpty: false,
            builder: (context, textController, focusNode) {
              return TextField(
                controller: textController,
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: 'Choose Bed',
                  hintText: 'Type to search bed...',
                  filled: true,
                  fillColor: const Color(0xFFF7F9FC),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF0F4CBA),
                  ),
                  suffixIcon: textController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear_rounded, size: 20),
                          onPressed: onClear,
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
              );
            },
            suggestionsCallback: (pattern) {
              if (pattern.isEmpty) return beds;

              return beds
                  .where(
                    (bed) => (bed.column1 ?? "")
                        .toString()
                        .toLowerCase()
                        .contains(pattern.toLowerCase()),
                  )
                  .toList();
            },
            itemBuilder: (context, BedMasterModel bed) {
              final bool isSelected =
                  controller.selectedBed.value?.column1 == bed.column1;

              return Container(
                color: isSelected ? const Color(0xFFEAF2FF) : null,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.bed_rounded,
                      size: 18,
                      color: Color(0xFF0F4CBA),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      bed.column1?.toString() ?? "",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              );
            },
            emptyBuilder: (context) => Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: Text(
                "No matching beds found",
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ),
            onSelected: (bed) => onClickBedList(bed),
            decorationBuilder: (context, child) {
              return Material(
                type: MaterialType.card,
                elevation: 4,
                borderRadius: BorderRadius.circular(14),
                child: child,
              );
            },
            offset: const Offset(0, 8),
            constraints: const BoxConstraints(maxHeight: 260),
          );
        }),
      ],
    ),
  );
}

Widget _cardShell({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(24),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.05),
          blurRadius: 15,
          offset: const Offset(0, 6),
        ),
      ],
    ),
    child: child,
  );
}

Widget _buildPatientNotFoundCard() {
  return _cardShell(
    child: Column(
      children: [
        const Icon(Icons.person_off_rounded, size: 42, color: Colors.redAccent),
        const SizedBox(height: 12),
        const Text(
          "No Patient Found",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          "There is no active patient record for the selected bed.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
      ],
    ),
  );
}

Widget _buildUrlLoadingCard() {
  return _cardShell(
    child: Column(
      children: const [
        SizedBox(
          height: 32,
          width: 32,
          child: CircularProgressIndicator(strokeWidth: 3),
        ),
        SizedBox(height: 12),
        Text(
          "Generating feedback link...",
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

Widget _buildUrlFailedCard(BuildContext context) {
  final DashboardController controller = Get.find<DashboardController>();

  return _cardShell(
    child: Column(
      children: [
        const Icon(Icons.error_outline_rounded, size: 42, color: Colors.orange),
        const SizedBox(height: 12),
        const Text(
          "Couldn't Generate Link",
          style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          "Something went wrong while generating the feedback URL.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        const SizedBox(height: 16),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0F4CBA),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          onPressed: () => controller.retryFetchUrl(),
          icon: const Icon(Icons.refresh_rounded),
          label: const Text("Retry"),
        ),
      ],
    ),
  );
}

/// =======================================================
/// QR CARD — uses server-generated patUrl
/// =======================================================

Widget _buildQrCard(BuildContext context) {
  final DashboardController controller = Get.find<DashboardController>();
  final patient = controller.selectedPatient.value;
  final String qrUrl = controller.patUrl.value;
  final String foodOrderUrl = controller.foodOrder.first.cURL ?? "";

  if (patient == null || qrUrl.isEmpty) {
    return const SizedBox.shrink();
  }

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(22),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(28),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(.06),
          blurRadius: 18,
          offset: const Offset(0, 8),
        ),
      ],
    ),
    child: Column(
      children: [
        Text(
          patient.wardname ?? "",
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "${patient.bedno ?? '-'}",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
        ),
        // const SizedBox(height: 8),
        // Text(
        //   "Scan this QR code to submit patient feedback.",
        //   textAlign: TextAlign.center,
        //   style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
        // ),
        // const SizedBox(height: 24),
        const SizedBox(height: 20),

        // Container(
        //   padding: const EdgeInsets.all(18),
        //   decoration: BoxDecoration(
        //     color: Colors.white,
        //     borderRadius: BorderRadius.circular(24),
        //     border: Border.all(color: Colors.grey.shade200),
        //   ),
        //   child: QrImageView(
        //     data: qrUrl,
        //     version: QrVersions.auto,
        //     size: 230,
        //     eyeStyle: const QrEyeStyle(
        //       eyeShape: QrEyeShape.square,
        //       color: Color(0xFF0F4CBA),
        //     ),
        //     dataModuleStyle: const QrDataModuleStyle(
        //       dataModuleShape: QrDataModuleShape.square,
        //       color: Colors.black,
        //     ),
        //   ),
        // ),
        //
        // const SizedBox(height: 22),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F7FC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.link_rounded, size: 18, color: Color(0xFF0F4CBA)),
                  SizedBox(width: 8),
                  Text("Link", style: TextStyle(fontWeight: FontWeight.w700)),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Food Order : ",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Flexible(
                    child: SelectableText(
                      foodOrderUrl,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Feedback : ",
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Flexible(
                    child: SelectableText(
                      qrUrl,
                      style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            // Expanded(
            //   child: ElevatedButton.icon(
            //     style: ElevatedButton.styleFrom(
            //       elevation: 0,
            //       backgroundColor: const Color(0xFF0F4CBA),
            //       foregroundColor: Colors.white,
            //       padding: const EdgeInsets.symmetric(vertical: 22),
            //       shape: RoundedRectangleBorder(
            //         borderRadius: BorderRadius.circular(16),
            //       ),
            //     ),
            //     onPressed: () async {
            //       await AppUtils.openUrl(qrUrl);
            //     },
            //     icon: const Icon(Icons.open_in_new_rounded),
            //     label: const Text(
            //       "Open Link",
            //       style: TextStyle(fontWeight: FontWeight.w700),
            //     ),
            //   ),
            // ),
            // const SizedBox(width: 14),
            Expanded(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF12B76A),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 22),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                onPressed: () => controller.generateQrPatient(context),
                icon: const Icon(Icons.print),
                label: const Text(
                  "Print",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    ),
  );
}
