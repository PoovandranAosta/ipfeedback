// // import 'package:get/get.dart';
// // import 'package:ipfeedback/models/bed_master_model.dart';
// // import 'package:ipfeedback/models/dashboard_patient_model.dart';
// // import 'package:ipfeedback/models/ward_master_model.dart';
// // import '../config/config.dart';
// // import '../config/encryption_helper.dart';
// // import '../services/app_utils.dart';
// // import '../services/pdf_services.dart';
// //
// // class DashboardController extends GetxController {
// //
// //   @override
// //   void onInit() {
// //     fetchWardMaster();
// //     super.onInit();
// //   }
// //   RxList<WardMasterModel> wardMaster = <WardMasterModel>[].obs;
// //   Rx<WardMasterModel?> selectedWard = Rx(null);
// //
// //   RxList<BedMasterModel> bedMaster = <BedMasterModel>[].obs;
// //   Rx<BedMasterModel?> selectedBed = Rx(null);
// //
// //   RxList<DashboardPatientModel> patientData = <DashboardPatientModel>[].obs;
// //
// //   final isLoading = false.obs;
// //   final AppUtils _appUtils = AppUtils();
// //   final PdfServices _pdfServices = PdfServices();
// //
// //   Future<void> fetchWardMaster() async {
// //     print("fetchWardMaster");
// //     isLoading.value = true;
// //     wardMaster.value = await _appUtils.fetchModelData(
// //       url: Config.connectUrl,
// //       body: {
// //         "strQuery": "exec astil_mapps.dbo.sp_general_mapps @opt = 5",
// //         "strCon": "BB_CONSTR",
// //       },
// //       fromJson: (json) => WardMasterModel.fromJson(json),
// //     );
// //     isLoading.value = false;
// //   }
// //
// //   Future<void> fetchBedMaster() async {
// //     print("fetchBedMaster");
// //     isLoading.value = true;
// //     bedMaster.value = await _appUtils.fetchModelData(
// //       url: Config.connectUrl,
// //       body: {
// //         "strQuery":
// //             "exec astil_mapps.dbo.sp_general_mapps @opt = 6,  @wardid = '${selectedWard.value?.iWardId}'",
// //         "strCon": "BB_CONSTR",
// //       },
// //       fromJson: (json) => BedMasterModel.fromJson(json),
// //     );
// //     isLoading.value = false;
// //   }
// //
// //   Future<void> fetchPatientInfo() async {
// //     isLoading.value = true;
// //     bedMaster.value = await _appUtils.fetchModelData(
// //       url: Config.connectUrl,
// //       body: {
// //         "strQuery":
// //             "exec astil_mapps.dbo.sp_general_mapps @opt = 1,  @wardid ='${selectedWard.value?.iWardId}' ,@bedid = '${selectedBed.value?.iBedId}'",
// //         "strCon": "BB_CONSTR",
// //       },
// //       fromJson: (json) => BedMasterModel.fromJson(json),
// //     );
// //     isLoading.value = false;
// //   }
// //
// //   void generateQrDepartment(String deptName, String deptId) {
// //     // final encWardId = AppUtils.encrypt(deptId, "DepartmentFeedBack");
// //     final encWardId = SecureEncryptionHelper.encrypt(deptId);
// //     _pdfServices.departmentQrPdf(deptName: deptName, deptId: encWardId);
// //   }
// //
// // }
//
//
// import 'package:get/get.dart';
// import 'package:ipfeedback/models/bed_master_model.dart';
// import 'package:ipfeedback/models/dashboard_patient_model.dart';
// import 'package:ipfeedback/models/ward_master_model.dart';
// import '../config/config.dart';
// import '../config/encryption_helper.dart';
// import '../services/app_utils.dart';
// import '../services/pdf_services.dart';
//
// class DashboardController extends GetxController {
//   @override
//   void onInit() {
//     fetchWardMaster();
//     super.onInit();
//   }
//
//   RxList<WardMasterModel> wardMaster = <WardMasterModel>[].obs;
//   Rx<WardMasterModel?> selectedWard = Rx(null);
//
//   RxList<BedMasterModel> bedMaster = <BedMasterModel>[].obs;
//   Rx<BedMasterModel?> selectedBed = Rx(null);
//
//   // Fixed: patient data now lives in its own list, not bedMaster
//   RxList<DashboardPatientModel> patientData = <DashboardPatientModel>[].obs;
//
//   // Convenience holder for the single active patient in the selected bed
//   Rx<DashboardPatientModel?> selectedPatient = Rx(null);
//
//   final isLoading = false.obs;
//   final AppUtils _appUtils = AppUtils();
//   final PdfServices _pdfServices = PdfServices();
//
//   RxString patUrl="".obs;
//
//   Future<void> fetchWardMaster() async {
//     isLoading.value = true;
//     wardMaster.value = await _appUtils.fetchModelData(
//       url: Config.connectUrl,
//       body: {
//         "strQuery": "exec astil_mapps.dbo.sp_general_mapps @opt = 5",
//         "strCon": "BB_CONSTR",
//       },
//       fromJson: (json) => WardMasterModel.fromJson(json),
//     );
//     isLoading.value = false;
//   }
//
//   Future<void> fetchBedMaster() async {
//
//     // Reset downstream state whenever ward changes
//     selectedBed.value = null;
//     patientData.clear();
//     selectedPatient.value = null;
//
//     bedMaster.value = await _appUtils.fetchModelData(
//       url: Config.connectUrl,
//       body: {
//         "strQuery":
//         "exec astil_mapps.dbo.sp_general_mapps @opt = 6, @wardid = '${selectedWard.value?.iWardId}'",
//         "strCon": "BB_CONSTR",
//       },
//       fromJson: (json) => BedMasterModel.fromJson(json),
//     );
//   }
//
//   /// Fixed: was writing into bedMaster with the wrong model.
//   /// Now correctly populates patientData with DashboardPatientModel.
//   Future<void> fetchPatientInfo() async {
//
//     patientData.value = await _appUtils.fetchModelData(
//       url: Config.connectUrl,
//       body: {
//         "strQuery":
//         "exec astil_mapps.dbo.sp_general_mapps @opt = 1, @wardid ='${selectedWard.value?.iWardId}' ,@bedid = '${selectedBed.value?.iBedId}'",
//         "strCon": "BB_CONSTR",
//       },
//       fromJson: (json) => DashboardPatientModel.fromJson(json),
//     );
//
//     selectedPatient.value =
//     patientData.isNotEmpty ? patientData.first : null;
//   }
//
//   Future<void> fetchUrl() async {
//
//     patUrl.value = await _appUtils.fetchString(
//       url: Config.connectUrl,
//       body: {
//         "strQuery":
//         "exec astil_mapps.dbo.sp_deptfeedback_encrpdecrp @ipid = ${patientData.first.iipid},@opt = 1",
//         "strCon": "BB_CONSTR"
//       },
//     );
//   }
//
//   /// Returns the encrypted iipid-based feedback URL for the current patient
//   String? get patientQrUrl {
//     final patient = selectedPatient.value;
//     if (patient?.iipid == null) return null;
//
//     final encryptedIpId =
//     SecureEncryptionHelper.encrypt(patient!.iipid.toString());
//
//     return "${Config.scanUrl}$encryptedIpId";
//   }
//
//   /// Generates/prints the QR for the currently selected patient
//   void generateQrPatient() {
//     final patient = selectedPatient.value;
//     if (patient?.iipid == null) return;
//
//     final encryptedIpId =
//     SecureEncryptionHelper.encrypt(patient!.iipid.toString());
//
//     _pdfServices.departmentQrPdf(
//       deptName: patient.wardname ?? "",
//       deptId: encryptedIpId,
//     );
//   }
// }

import 'package:get/get.dart';
import 'package:ipfeedback/models/bed_master_model.dart';
import 'package:ipfeedback/models/dashboard_patient_model.dart';
import 'package:ipfeedback/models/food_order_model.dart';
import 'package:ipfeedback/models/ward_master_model.dart';
import 'package:ipfeedback/widgets/custom_toast.dart';
import '../config/config.dart';
import '../config/tamil_text.dart';
import '../services/app_utils.dart';
import '../services/pdf_services.dart';
import 'package:flutter/material.dart';

class DashboardController extends GetxController {
  @override
  void onInit() {
    fetchWardMaster();
    super.onInit();
  }

  // ---- Master data ----
  RxList<WardMasterModel> wardMaster = <WardMasterModel>[].obs;
  Rx<WardMasterModel?> selectedWard = Rx(null);

  RxList<BedMasterModel> bedMaster = <BedMasterModel>[].obs;
  Rx<BedMasterModel?> selectedBed = Rx(null);

  RxList<FoodOrderModel> foodOrder = <FoodOrderModel>[].obs;

  RxList<DashboardPatientModel> patientData = <DashboardPatientModel>[].obs;
  Rx<DashboardPatientModel?> selectedPatient = Rx(null);

  final isLoading = false.obs;
  final isUrlLoading = false.obs;

  RxString patUrl = "".obs;
  RxBool urlFetchFailed = false.obs;

  RxBool patientNotFound = false.obs;

  RxBool checkWifi = false.obs;
  RxBool checkFeedback = false.obs;
  RxBool checkFoodOrder = false.obs;

  final AppUtils _appUtils = AppUtils();
  final PdfServices _pdfServices = PdfServices();

  final TextEditingController wardTextController = TextEditingController();
  final FocusNode wardFocusNode = FocusNode();

  final TextEditingController bedTextController = TextEditingController();
  final FocusNode bedFocusNode = FocusNode();

  @override
  void onClose() {
    wardTextController.dispose();
    wardFocusNode.dispose();
    bedTextController.dispose();
    bedFocusNode.dispose();
    super.onClose();
  }

  Future<void> fetchWardMaster() async {
    isLoading.value = true;
    try {
      wardMaster.value = await _appUtils.fetchModelData(
        url: Config.connectUrl,
        body: {
          "strQuery": "exec astil_mapps.dbo.sp_general_mapps @opt = 5",
          "strCon": "BB_CONSTR",
        },
        fromJson: (json) => WardMasterModel.fromJson(json),
      );
    } catch (e) {
      wardMaster.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchBedMaster() async {
    // isLoading.value = true;

    // Reset everything downstream of ward selection
    selectedBed.value = null;
    patientData.clear();
    selectedPatient.value = null;
    patUrl.value = "";
    urlFetchFailed.value = false;
    patientNotFound.value = false;

    try {
      bedMaster.value = await _appUtils.fetchModelData(
        url: Config.connectUrl,
        body: {
          "strQuery":
              "exec astil_mapps.dbo.sp_general_mapps @opt = 6, @wardid = '${selectedWard.value?.iWardId}'",
          "strCon": "BB_CONSTR",
        },
        fromJson: (json) => BedMasterModel.fromJson(json),
      );
    } catch (e) {
      bedMaster.clear();
    } finally {
      // isLoading.value = false;
    }
  }

  Future<void> fetchPatientInfo() async {
    patientData.clear();
    selectedPatient.value = null;
    patUrl.value = "";
    urlFetchFailed.value = false;
    patientNotFound.value = false;

    try {
      patientData.value = await _appUtils.fetchModelData(
        url: Config.connectUrl,
        body: {
          "strQuery":
              "exec astil_mapps.dbo.sp_general_mapps @opt = 1, @wardid ='${selectedWard.value?.iWardId}' ,@bedid = '${selectedBed.value?.iBedId}'",
          "strCon": "BB_CONSTR",
        },
        fromJson: (json) => DashboardPatientModel.fromJson(json),
      );
    } catch (e) {
      patientData.clear();
    }

    if (patientData.isEmpty || patientData.first.iipid == null) {
      patientNotFound.value = true;
      selectedPatient.value = null;
      return;
    }

    selectedPatient.value = patientData.first;

    await fetchFoodOrder();
    await fetchUrl(selectedPatient.value!.iipid!);
  }

  Future<void> fetchFoodOrder() async {
    try {
      foodOrder.value = await _appUtils.fetchModelData(
        url: Config.connectUrl,
        body: {
          "strQuery":
              "EXEC kmch_dietary.dbo.SP_DietQRGen @opt=3,@wardid='${selectedWard.value?.iWardId}',@BedId='${selectedBed.value?.iBedId}'",
          "strCon": "BB_CONSTR",
        },
        fromJson: (json) => FoodOrderModel.fromJson(json),
      );
    } catch (e) {
      foodOrder.clear();
    } finally {
      print("Food Order Link Loaded");
      print("${foodOrder.first.cURL}");
    }
  }

  Future<void> fetchUrl(int ipid) async {
    isUrlLoading.value = true;
    urlFetchFailed.value = false;

    try {
      final result = await _appUtils.fetchString(
        url: Config.connectUrl,
        body: {
          "strQuery":
              "exec astil_mapps.dbo.sp_deptfeedback_encrpdecrp @ipid = $ipid, @opt = 1",
          "strCon": "BB_CONSTR",
        },
      );

      if (result.trim().isEmpty) {
        urlFetchFailed.value = true;
        patUrl.value = "";
      } else {
        patUrl.value = result.trim();
      }
    } catch (e) {
      urlFetchFailed.value = true;
      patUrl.value = "";
    } finally {
      isUrlLoading.value = false;
    }
  }

  Future<void> retryFetchUrl() async {
    final patient = selectedPatient.value;
    if (patient?.iipid == null) return;
    await fetchFoodOrder();
    await fetchUrl(patient!.iipid!);
  }

  Future<void> generateQrPatient(BuildContext context) async {
    
    final patient = selectedPatient.value;
    if (patient == null || patUrl.value.isEmpty) return;

    // No checkbox selected
    if (!checkWifi.value && !checkFoodOrder.value && !checkFeedback.value) {
      CustomToast.show(
        context: context,
        message: "Please select at least one service.",
      );
      // Get.snackbar(
      //   'Selection Required',
      //   'Please select at least one service.',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      return;
    }

    // 2. Wi-Fi selected, but Wi-Fi is not available for this patient
    if (checkWifi.value && (patient.wifiFlag ?? 0) == 0) {
      CustomToast.show(
        context: context,
        message: "No Wi-Fi is available for this bed.",
      );

      // Get.snackbar(
      //   'Wi-Fi Not Available',
      //   'No Wi-Fi is available for this ward and bed.',
      //   snackPosition: SnackPosition.BOTTOM,
      // );
      return;
    }

    // 3. Generate Tamil labels
    final wifiLabel = await TamilTextImage.render(
      'இலவச WiFi சேவைக்கு ஸ்கேன்\nசெய்யவும் (2 GB / தினமும்)',
    );

    final foodLabel = await TamilTextImage.render(
      'நோயாளிகளுடன் இருப்பவர்களின் உணவுக்கு ஸ்கேன் செய்யவும்',
    );

    final feedbackLabel = await TamilTextImage.render(
      'உதவிக்கு மற்றும் கருத்துக்கள் பகிர\nஸ்கேன் செய்யவும்',
    );

    // 4. Generate PDF
    _pdfServices.qrPdf(
      ward: patient.wardname ?? "",
      bed: patient.bedno ?? "",
      mobileNumber: "+91 80563 70563",
      foodOrderUrl: "${foodOrder.first.cURL}",
      feedbackUrl: patUrl.value,
      wifiTamilLabel: wifiLabel,
      foodTamilLabel: foodLabel,
      feedbackTamilLabel: feedbackLabel,
      isWifi: patient.wifiFlag ?? 0,
      checkWifi: checkWifi.value,
      checkFoodOrder: checkFoodOrder.value,
      checkFeedback: checkFeedback.value,
    );
  }

  // Future<void> generateQrPatient() async {
  //   final patient = selectedPatient.value;
  //   if (patient == null || patUrl.value.isEmpty) return;

  //   final wifiLabel = await TamilTextImage.render(
  //     'இலவச WiFi சேவைக்கு ஸ்கேன்\nசெய்யவும் (2 GB / தினமும்)',
  //   );
  //   final foodLabel = await TamilTextImage.render(
  //     'நோயாளிகளுடன் இருப்பவர்களின் உணவுக்கு ஸ்கேன் செய்யவும்',
  //   );
  //   final feedbackLabel = await TamilTextImage.render(
  //     'உதவிக்கு மற்றும் கருத்துக்கள் பகிர\nஸ்கேன் செய்யவும்',
  //   );

  //   _pdfServices.qrPdf(
  //     ward: patient.wardname ?? "",
  //     bed: patient.bedno ?? "",
  //     mobileNumber: "+91 80563 70563",
  //     foodOrderUrl: "${foodOrder.first.cURL}",
  //     feedbackUrl: patUrl.value,
  //     wifiTamilLabel: wifiLabel,
  //     foodTamilLabel: foodLabel,
  //     feedbackTamilLabel: feedbackLabel,
  //     isWifi: patient.wifiFlag ?? 0,
  //     checkWifi: checkWifi.value,
  //     checkFoodOrder: checkFoodOrder.value,
  //     checkFeedback: checkFeedback.value
  //   );
  // }
}
