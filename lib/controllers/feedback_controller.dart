import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ipfeedback/models/patient_detail_model.dart';
import '../config/config.dart';
import '../models/answer_model.dart';
import '../models/question_model.dart';
import '../routes/app_routes.dart';
import '../services/api_services.dart';
import '../services/app_utils.dart';

class FeedbackController extends GetxController {
  @override
  void onInit() {
    fetchData();
    super.onInit();
  }

  ApiService apiService = ApiService();
  final AppUtils _commonMethods = AppUtils();

  RxList<PatientDetailModel> patData = <PatientDetailModel>[].obs;
  RxList<QuestionModel> questions = <QuestionModel>[].obs;
  RxList<FeedbackAnswerModel> answers = <FeedbackAnswerModel>[].obs;

  // RxList<PatientDetailModel> patients = <PatientDetailModel>[].obs;
  // RxList<DeptNameModel> departments = <DeptNameModel>[].obs;

  final isLoading = false.obs;

  Future<void> fetchData() async {
    String ExtractedValue = AppUtils.extractUrlValue()!;
    print("Extracted Value : $ExtractedValue");

    await fetchPatientDetail(ExtractedValue);
    await fetchQuestion("en");
  }

  Future<void> fetchQuestion(String lang) async {
    isLoading.value = true;
    questions.value = await _commonMethods.fetchModelData(
      url: Config.connectUrl,
      body: {
        "strQuery":
            "exec astil_mapps..sp_qrdeptfeedback @opt = 1,@lang = '$lang',@ideptid = '7'",
        "strCon": "BB_CONSTR",
      },
      fromJson: (json) => QuestionModel.fromJson(json),
    );
    isLoading.value = false;
  }

  Future<void> fetchPatientDetail(String encryptVal) async {
    isLoading.value = true;
    patData.value = await _commonMethods.fetchModelData(
      url: Config.connectUrl,
      body: {
        "strQuery":
            "exec astil_mapps.dbo.sp_deptfeedback_encrpdecrp @curl = '$encryptVal',@opt = 2",
        "strCon": "BB_CONSTR",
      },
      fromJson: (json) => PatientDetailModel.fromJson(json),
    );
    // print("Pat Data : ${patData.first.patientName}");
    isLoading.value = false;
  }

  Future<void> saveFeedBack({required String answerEncode}) async {
    print("Answer Encoded : $answerEncode");
    String isSaved = await _commonMethods.fetchString(
      url: Config.connectUrl,
      body: {
        "strQuery":
            "exec astil_mapps..sp_qrdeptfeedback @opt = 3,"
                "@ipattype = 1,@cattendername = '',"
                "@cattendermobile = '${patData.first.mobile}',"
                "@cregno = '${patData.first.regNo}',"
                "@cpatientname = '${patData.first.patientName}',"
                "@Answertext = '$answerEncode'",
        "strCon": "BB_CONSTR",
      },
    );
    // print("isSaved : $isSaved");

    Get.offAllNamed(AppRoutes.thanks);
  }
}
